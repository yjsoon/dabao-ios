import Foundation

// MARK: - The Restaurant Info module (VIPER)
//
// A small sheet that shows facts about a restaurant: rating, delivery time,
// whether it's open, and how many dishes are on the menu.
//
// View        RestaurantInfoViewController
// Interactor  RestaurantInfoInteractor   Works out the facts (counts, open or closed)
// Presenter   RestaurantInfoPresenter    Turns the facts into rows of text
// Entity      Restaurant, RestaurantFacts
// Router      RestaurantInfoRouter       Builds the module, and closes the sheet

@MainActor
protocol RestaurantInfoViewProtocol: AnyObject {
    func showTitle(_ title: String)
    func showRows(_ rows: [InfoRowViewModel])
}

@MainActor
protocol RestaurantInfoPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapDone()
}

@MainActor
protocol RestaurantInfoInteractorInputProtocol: AnyObject {
    func loadFacts()
}

@MainActor
protocol RestaurantInfoInteractorOutputProtocol: AnyObject {
    func didLoadFacts(_ facts: RestaurantFacts)
}

@MainActor
protocol RestaurantInfoRouterProtocol: AnyObject {
    func close()
}

/// The facts the interactor works out about a restaurant.
struct RestaurantFacts: Equatable {
    let name: String
    let cuisine: String
    let rating: Double
    let deliveryMinutes: Int
    let deliveryFee: Decimal
    let isOpen: Bool
    let dishCount: Int
    let soldOutCount: Int
    let spicyCount: Int
}

/// One row on the info sheet, e.g. "Rating" / "★ 4.6".
struct InfoRowViewModel: Equatable {
    let title: String
    let value: String
}
