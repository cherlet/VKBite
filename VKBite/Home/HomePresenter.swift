protocol HomePresenterProtocol: AnyObject {
    func didSetting(with configuration: Configuration)
}

class HomePresenter {
    weak var view: HomeViewProtocol?
    var router: HomeRouterProtocol

    init(router: HomeRouterProtocol) {
        self.router = router
    }
}

extension HomePresenter: HomePresenterProtocol {
    func didSetting(with configuration: Configuration) {
        router.openSimulator(with: configuration)
    }
}
