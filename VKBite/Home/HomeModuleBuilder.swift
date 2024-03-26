import UIKit

class HomeModuleBuilder {
    static func build() -> HomeViewController {
        let router = HomeRouter()
        let presenter = HomePresenter(router: router)
        let viewController = HomeViewController()

        presenter.view  = viewController
        viewController.presenter = presenter
        router.viewController = viewController

        return viewController
    }
}
