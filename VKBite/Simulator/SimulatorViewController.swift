import UIKit

protocol SimulatorViewProtocol: AnyObject {
    func start(with configuration: Configuration)
}

class SimulatorViewController: UIViewController {
    // MARK: Properties
    private let simulationQueue = DispatchQueue(label: "simulationQueue")
    private var simulationTimer: DispatchSourceTimer?
    private var currentScale: CGFloat = 1.0
    
    var presenter: SimulatorPresenterProtocol?
    var configuration: Configuration?
    
    var group = Group(size: 0)
    var infectedHumanPositions = Set<Position>()
    
    // MARK: UI Elements
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        let collectionView = UICollectionView(frame: .infinite, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        collectionView.register(HumanCell.self, forCellWithReuseIdentifier: HumanCell.identifier)
        return collectionView
    }()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewLoaded()
        initialize()
    }
}

// MARK: - Module
extension SimulatorViewController: SimulatorViewProtocol {
    func start(with configuration: Configuration) {
        self.configuration = configuration
        group = Group(size: configuration.groupSize)
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
        startSimulation()
    }
}

// MARK: - Setup
private extension SimulatorViewController {
    func initialize() {
        view.backgroundColor = .white
        setupLayout()
        setupPinchGestureRecognizer()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func setupLayout() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupPinchGestureRecognizer() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        pinchGesture.delegate = self
        self.view.addGestureRecognizer(pinchGesture)
    }
}

// MARK: - CollectionView
extension SimulatorViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        group.humans.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        group.humans[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HumanCell.identifier, for: indexPath) as? HumanCell else {
            fatalError("DEBUG: Failed with custom cell bug")
        }
        
        let human = group.humans[indexPath.section][indexPath.item]
        cell.configure(status: human.isInfected)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let human = group.humans[indexPath.section][indexPath.item]
        infectedHumanPositions.insert(human.position)
        
        simulationQueue.async {
            self.handleCellSelection(at: indexPath)
        }
    }
}

// MARK: - Simulation Methods
private extension SimulatorViewController {
    private func startSimulation() {
        guard let configuration = configuration else { return }
        
        let timestampInSeconds = TimeInterval(configuration.timestamp)

        simulationTimer = DispatchSource.makeTimerSource(queue: simulationQueue)
        simulationTimer?.schedule(deadline: .now(), repeating: timestampInSeconds)
        simulationTimer?.setEventHandler { [weak self] in
            self?.concurrentUpdate()
        }
        simulationTimer?.resume()
    }

    private func concurrentUpdate() {
        DispatchQueue.global().async {
            for infectedPosition in self.infectedHumanPositions {
                var infectionFactor = self.configuration?.infectionFactor ?? 0
                var availableNeighbors = infectedPosition.getAvailableNeighbors(bottomRightCorner: self.group.information.bottomRightCorner,
                                                                                residue: self.group.information.residue)
                
                // All the neighbors of current human are infected
                if self.infectedHumanPositions.containsAll(availableNeighbors) {
                    self.infectedHumanPositions.remove(infectedPosition)
                    continue
                }
                
                while !availableNeighbors.isEmpty, infectionFactor > 0 {
                    let randomIndex = Int.random(in: 0..<availableNeighbors.count)
                    let randomVictim = availableNeighbors[randomIndex]
                    
                    // Making sure that two neighbors don't infect the same one
                    if !self.infectedHumanPositions.contains(randomVictim) {
                        self.infectedHumanPositions.insert(randomVictim)
                        infectionFactor -= 1
                        
                        let indexPath = IndexPath(item: randomVictim.x, section: randomVictim.y)
                        self.group.humans[indexPath.section][indexPath.item].setInfected()
                        
                        DispatchQueue.main.async {
                            self.collectionView.reloadItems(at: [indexPath])
                        }
                    }
                    
                    availableNeighbors.remove(at: randomIndex)
                }
            }
        }
    }
}

// MARK: - Actions
extension SimulatorViewController: UIGestureRecognizerDelegate {
    private func handleCellSelection(at indexPath: IndexPath) {
        let selectedHuman = group.humans[indexPath.section][indexPath.item]
        selectedHuman.setInfected()
        group.humans[indexPath.section][indexPath.item] = selectedHuman
        
        DispatchQueue.main.async {
            self.collectionView.reloadItems(at: [indexPath])
        }
    }
    
    @objc private func handlePinchGesture(_ gestureRecognizer: UIPinchGestureRecognizer) {
        guard gestureRecognizer.view != nil else { return }

        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            let scale = gestureRecognizer.scale * currentScale
            let scaledTransform = CGAffineTransform(scaleX: scale, y: scale)
            
            if scale <= 2.0, scale >= 0.8 {
                collectionView.transform = scaledTransform
            }
        } else if gestureRecognizer.state == .ended {
            currentScale = 1.0
            let scaledTransform = CGAffineTransform(scaleX: currentScale, y: currentScale)
            
            UIView.animate(withDuration: 0.15) {
                self.collectionView.transform = scaledTransform
            }
        }
    }
}
