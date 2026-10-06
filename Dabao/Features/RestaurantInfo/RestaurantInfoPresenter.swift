import Foundation

@MainActor
final class RestaurantInfoPresenter: RestaurantInfoPresenterProtocol, RestaurantInfoInteractorOutputProtocol {

    weak var view: RestaurantInfoViewProtocol?
    private let interactor: RestaurantInfoInteractorInputProtocol
    private let router: RestaurantInfoRouterProtocol

    init(view: RestaurantInfoViewProtocol,
         interactor: RestaurantInfoInteractorInputProtocol,
         router: RestaurantInfoRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    func viewDidLoad() {
        interactor.loadFacts()
    }

    func didTapDone() {
        router.close()
    }

    func didLoadFacts(_ facts: RestaurantFacts) {
        view?.showTitle(facts.name)
        view?.showRows(makeRows(from: facts))
    }

    func makeRows(from facts: RestaurantFacts) -> [InfoRowViewModel] {
        let dishes = facts.dishCount == 1 ? "1 dish" : "\(facts.dishCount) dishes"
        let soldOut = facts.soldOutCount == 0 ? "" : " (\(facts.soldOutCount) sold out today)"
        return [
            InfoRowViewModel(title: "Cuisine", value: facts.cuisine),
            InfoRowViewModel(title: "Rating", value: "★ " + String(format: "%.1f", facts.rating)),
            InfoRowViewModel(title: "Delivery time", value: "About \(facts.deliveryMinutes) min"),
            InfoRowViewModel(title: "Delivery fee", value: PriceFormatter.string(from: facts.deliveryFee)),
            InfoRowViewModel(title: "Status", value: facts.isOpen ? "Open now" : "Closed"),
            InfoRowViewModel(title: "Menu", value: dishes + soldOut),
            InfoRowViewModel(title: "Spicy dishes", value: "\(facts.spicyCount)")
        ]
    }
}
