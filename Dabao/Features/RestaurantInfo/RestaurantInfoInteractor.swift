import Foundation

@MainActor
final class RestaurantInfoInteractor: RestaurantInfoInteractorInputProtocol {

    weak var output: RestaurantInfoInteractorOutputProtocol?
    private let restaurant: Restaurant

    init(restaurant: Restaurant) {
        self.restaurant = restaurant
    }

    func loadFacts() {
        // TODO 2: Work out the facts about `restaurant`, put them in a `RestaurantFacts`,
        // and send them to the presenter through `output`.
        // Hint: `filter` and `count` will help with the sold-out and spicy counts.
    }
}
