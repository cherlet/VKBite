import UIKit

protocol SimulatorViewProtocol: AnyObject {
    func start(with configuration: Configuration)
}

class SimulatorViewController: UIViewController {
    var presenter: SimulatorPresenterProtocol?
    var group = Group(size: 0)
    
    private var currentScale: CGFloat = 1.0
    
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
        group = Group(size: configuration.groupSize)
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
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
        cell.configure(with: human)
        
        return cell
    }
}

// MARK: - Actions
extension SimulatorViewController: UIGestureRecognizerDelegate {
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
