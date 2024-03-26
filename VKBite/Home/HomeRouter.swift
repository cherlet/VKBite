protocol HomeRouterProtocol {
    func openSimulator(with configuration: Configuration)
}

class HomeRouter: HomeRouterProtocol {
    weak var viewController: HomeViewController?
    
    func openSimulator(with configuration: Configuration) {
        guard let navigationController = viewController?.navigationController else { return }
        let simulatorController = SimulatorModuleBuilder.build(with: configuration)
        navigationController.pushViewController(simulatorController, animated: true)
    }
}
