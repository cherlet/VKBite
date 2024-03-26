protocol HomePresenterProtocol: AnyObject {
}

class HomePresenter {
    weak var view: HomeViewProtocol?
    var router: HomeRouterProtocol

    init(router: HomeRouterProtocol) {
        self.router = router
    }
}

extension HomePresenter: HomePresenterProtocol {
}
