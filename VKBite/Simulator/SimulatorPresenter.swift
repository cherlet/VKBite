protocol SimulatorPresenterProtocol: AnyObject {
    func viewLoaded()
}

class SimulatorPresenter {
    weak var view: SimulatorViewProtocol?
    var router: SimulatorRouterProtocol
    let configuration: Configuration

    init(router: SimulatorRouterProtocol, configuration: Configuration) {
        self.router = router
        self.configuration = configuration
    }
}

extension SimulatorPresenter: SimulatorPresenterProtocol {
    func viewLoaded() {
        view?.start(with: configuration)
    }
}
