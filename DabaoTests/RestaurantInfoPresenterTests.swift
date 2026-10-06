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

    private let facts = RestaurantFacts(name: "Kopi Corner", cuisine: "Coffee shop", rating: 4.8,
                                        deliveryMinutes: 15, deliveryFee: 1.99, isOpen: false,
                                        dishCount: 6, soldOutCount: 1, spicyCount: 1)

    func test_facts_becomeReadableRows() {
        let view = FakeView()
        let presenter = RestaurantInfoPresenter(view: view, interactor: FakeInteractor(), router: FakeRouter())

        presenter.didLoadFacts(facts)

        XCTAssertEqual(view.title, "Kopi Corner")
        XCTAssertTrue(view.rows.contains(InfoRowViewModel(title: "Status", value: "Closed")))
        XCTAssertTrue(view.rows.contains(InfoRowViewModel(title: "Menu", value: "6 dishes (1 sold out today)")))
    }

    func test_done_closesSheet() {
        let router = FakeRouter()
        let presenter = RestaurantInfoPresenter(view: FakeView(), interactor: FakeInteractor(), router: router)

        presenter.didTapDone()

        XCTAssertTrue(router.closed)
    }
}
