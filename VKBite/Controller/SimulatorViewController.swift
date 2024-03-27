import UIKit

class SimulatorViewController: UIViewController {
    // MARK: Properties
    private let simulationQueue = DispatchQueue(label: "simulationQueue")
    private var simulationTimer: DispatchSourceTimer?
    private var swipedIndexes = Set<IndexPath>()
    private var isSwipeMode: Bool = false {
        didSet {
            if isSwipeMode {
                collectionView.isScrollEnabled = false
            } else {
                collectionView.isScrollEnabled = true
            }
        }
    }
    
    var configuration: Configuration
    var group: Group
    var infectedHumanPositions = Set<Position>()
    
    // MARK: Initialize
    init(with configuration: Configuration) {
        self.configuration = configuration
        self.group = Group(size: configuration.groupSize)
        self.statusBar = StatusBar(groupSize: configuration.groupSize)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI Elements
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(HumanCell.self, forCellWithReuseIdentifier: HumanCell.identifier)
        return collectionView
    }()
    
    private lazy var stopButton: UIButton = {
        let button = UIButton()
        button.setTitle("STOP", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(stopSimulation), for: .touchUpInside)
        return button
    }()

    
    private let statusBar: StatusBar
    
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        startSimulation()
    }
}

// MARK: - Setup
private extension SimulatorViewController {
    func setup() {
        view.backgroundColor = .white
        setupLayout()
        setupPinchGestureRecognizer()
        setupLongPressGestureRecognizer()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func setupLayout() {
        [statusBar, collectionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        stopButton.translatesAutoresizingMaskIntoConstraints = false
        statusBar.addSubview(stopButton)
        
        NSLayoutConstraint.activate([
            stopButton.widthAnchor.constraint(equalToConstant: 64),
            stopButton.heightAnchor.constraint(equalToConstant: 32),
            stopButton.leadingAnchor.constraint(equalTo: statusBar.leadingAnchor, constant: 20),
            stopButton.bottomAnchor.constraint(equalTo: statusBar.bottomAnchor, constant: -16),
            
            statusBar.heightAnchor.constraint(equalToConstant: 120),
            statusBar.topAnchor.constraint(equalTo: view.topAnchor),
            statusBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statusBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: statusBar.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setupPinchGestureRecognizer() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        pinchGesture.delegate = self
        self.view.addGestureRecognizer(pinchGesture)
    }
    
    private func setupLongPressGestureRecognizer() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPressGesture.delegate = self
        collectionView.addGestureRecognizer(longPressGesture)
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
        simulationQueue.async {
            self.handleCellSelection(at: indexPath)
        }
    }
}

// MARK: - Simulation Methods
private extension SimulatorViewController {
    func startSimulation() {
        let timestampInSeconds = TimeInterval(configuration.timestamp)
        
        simulationTimer = DispatchSource.makeTimerSource(queue: simulationQueue)
        simulationTimer?.schedule(deadline: .now(), repeating: timestampInSeconds)
        simulationTimer?.setEventHandler { [weak self] in
            self?.concurrentUpdate()
        }
        simulationTimer?.resume()
    }
    
    func concurrentUpdate() {
        DispatchQueue.global().async {
            for infectedPosition in self.infectedHumanPositions {
                var infectionFactor = self.configuration.infectionFactor
                var availableNeighbors = infectedPosition.getAvailableNeighbors(bottomRightCorner: self.group.information.bottomRightCorner,
                                                                                residue: self.group.information.residue)

                
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
                            self.statusBar.clock()
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
    @objc func stopSimulation() {
        guard let navigationController = navigationController else { return }
        navigationController.popToRootViewController(animated: true)
    }
    
    @objc private func handleCellSelection(at indexPath: IndexPath) {
        let human = group.humans[indexPath.section][indexPath.item]
        human.setInfected()
        infectedHumanPositions.insert(human.position)
        
        DispatchQueue.main.async {
            self.collectionView.reloadItems(at: [indexPath])
            self.statusBar.clock()
        }
    }
    
    @objc private func handlePinchGesture(_ gestureRecognizer: UIPinchGestureRecognizer) {
        guard gestureRecognizer.view != nil else { return }
        
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            let scale = gestureRecognizer.scale * 1.0
            let scaledTransform = CGAffineTransform(scaleX: scale, y: scale)
            
            if scale <= 2.0, scale >= 0.8 {
                collectionView.transform = scaledTransform
            }
        } else if gestureRecognizer.state == .ended {
            let scaledTransform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
            UIView.animate(withDuration: 0.15) {
                self.collectionView.transform = scaledTransform
            }
        }
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            guard let indexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else { return }
            isSwipeMode = true
            highlightCell(at: indexPath)
            swipedIndexes.insert(indexPath)
        case .changed:
            guard let indexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else { return }
            isSwipeMode = true
            highlightCell(at: indexPath)
            swipedIndexes.insert(indexPath)
        default:
            collectionView.cancelInteractiveMovement()
            isSwipeMode = false
            resetCells(at: swipedIndexes)
            swipedIndexes.forEach { indexPath in
                simulationQueue.async {
                    self.handleCellSelection(at: indexPath)
                }
            }
            swipedIndexes.removeAll()
        }
    }
    
    private func highlightCell(at indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            UIView.animate(withDuration: 0.2) {
                cell.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                cell.contentView.backgroundColor = .red
            }
        }
    }
    
    private func resetCells(at indexPaths: Set<IndexPath>) {
        for indexPath in indexPaths {
            if let cell = collectionView.cellForItem(at: indexPath) {
                UIView.animate(withDuration: 0.2) {
                    cell.transform = .identity
                    cell.contentView.backgroundColor = .clear
                }
            }
        }
    }
}
