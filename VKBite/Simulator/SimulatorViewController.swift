import UIKit

protocol SimulatorViewProtocol: AnyObject {
    func start(with configuration: Configuration)
}

class SimulatorViewController: UIViewController {
    var presenter: SimulatorPresenterProtocol?
    var group: [[Human]] = [[]]

    // MARK: UI Elements
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
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
        print("DEBUG: Current configuration = ", configuration)
    }
}

// MARK: - Setup
private extension SimulatorViewController {
    func initialize() {
        view.backgroundColor = .green
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

// MARK: - CollectionView
extension SimulatorViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HumanCell.identifier, for: indexPath) as? HumanCell else {
            fatalError("DEBUG: Failed with custom cell bug")
        }
        
        let human = group[indexPath.section][indexPath.item]
        cell.configure(with: human)
        
        return cell
    }
}
