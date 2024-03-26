import UIKit

protocol SimulatorViewProtocol: AnyObject {
    func start(with configuration: Configuration)
}

class SimulatorViewController: UIViewController {
    var presenter: SimulatorPresenterProtocol?

    // MARK: UI Elements

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewLoaded()
        initialize()
    }
}

// MARK: Module 
extension SimulatorViewController: SimulatorViewProtocol {
    func start(with configuration: Configuration) {
        print("DEBUG: Current configuration = ", configuration)
    }
}

// MARK: Setup
private extension SimulatorViewController {
    func initialize() {
        view.backgroundColor = .green
    }
}
