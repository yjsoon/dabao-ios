import XCTest
@testable import Dabao

@MainActor
final class RestaurantInfoPresenterTests: XCTestCase {

    final class FakeView: RestaurantInfoViewProtocol {
        var title: String?
        var rows: [InfoRowViewModel] = []
        func showTitle(_ title: String) { self.title = title }
        func showRows(_ rows: [InfoRowViewModel]) { self.rows = rows }
    }
    final class FakeInteractor: RestaurantInfoInteractorInputProtocol {
        func loadFacts() {}
    }
    final class FakeRouter: RestaurantInfoRouterProtocol {
        var closed = false
        func close() { closed = true }
    }

    // These match Green Bowl and Ah Seng Chicken Rice in restaurants.json,
    // so you can compare the test with what you see in the Simulator.
    private let greenBowl = RestaurantFacts(name: "Green Bowl", cuisine: "Salads", rating: 4.1,
                                            deliveryMinutes: 30, deliveryFee: 3.99, isOpen: false,
                                            dishCount: 3, soldOutCount: 0, spicyCount: 0)
    private let ahSeng = RestaurantFacts(name: "Ah Seng Chicken Rice", cuisine: "Hawker", rating: 4.6,
                                         deliveryMinutes: 25, deliveryFee: 2.99, isOpen: true,
                                         dishCount: 8, soldOutCount: 1, spicyCount: 1)

    func test_closedRestaurant_showsClosedAndDishCount() {
        let view = FakeView()
        let presenter = RestaurantInfoPresenter(view: view, interactor: FakeInteractor(), router: FakeRouter())

        presenter.didLoadFacts(greenBowl)

        XCTAssertEqual(view.title, "Green Bowl")
        XCTAssertTrue(view.rows.contains(InfoRowViewModel(title: "Status", value: "Closed")))
        XCTAssertTrue(view.rows.contains(InfoRowViewModel(title: "Menu", value: "3 dishes")))
    }

    func test_openRestaurant_showsSoldOutCount() {
        let view = FakeView()
        let presenter = RestaurantInfoPresenter(view: view, interactor: FakeInteractor(), router: FakeRouter())

        presenter.didLoadFacts(ahSeng)

        XCTAssertTrue(view.rows.contains(InfoRowViewModel(title: "Status", value: "Open now")))
        XCTAssertTrue(view.rows.contains(InfoRowViewModel(title: "Menu", value: "8 dishes (1 sold out today)")))
    }

    func test_done_closesSheet() {
        let router = FakeRouter()
        let presenter = RestaurantInfoPresenter(view: FakeView(), interactor: FakeInteractor(), router: router)

        presenter.didTapDone()

        XCTAssertTrue(router.closed)
    }
}
