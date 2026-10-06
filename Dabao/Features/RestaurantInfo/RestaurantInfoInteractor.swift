import Foundation

@MainActor
final class RestaurantInfoInteractor: RestaurantInfoInteractorInputProtocol {

    weak var output: RestaurantInfoInteractorOutputProtocol?
    private let restaurant: Restaurant

    init(restaurant: Restaurant) {
        self.restaurant = restaurant
    }

    func loadFacts() {
        let facts = RestaurantFacts(
            name: restaurant.name,
            cuisine: restaurant.cuisine,
            rating: restaurant.rating,
            deliveryMinutes: restaurant.deliveryMinutes,
            deliveryFee: restaurant.deliveryFee,
            isOpen: restaurant.isOpen,
            dishCount: restaurant.menu.count,
            soldOutCount: restaurant.menu.filter(\.isSoldOut).count,
            spicyCount: restaurant.menu.filter(\.isSpicy).count
        )
        output?.didLoadFacts(facts)
    }
}
