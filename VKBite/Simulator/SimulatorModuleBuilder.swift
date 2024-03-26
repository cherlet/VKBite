import UIKit

class SimulatorModuleBuilder {
    static func build(with configuration: Configuration) -> SimulatorViewController {
        let router = SimulatorRouter()
        let presenter = SimulatorPresenter(router: router, configuration: configuration)
        let viewController = SimulatorViewController()

        presenter.view  = viewController
        viewController.presenter = presenter
        router.viewController = viewController

        return viewController
    }
}
