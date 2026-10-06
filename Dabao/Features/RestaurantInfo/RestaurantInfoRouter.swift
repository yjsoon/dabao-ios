import UIKit

@MainActor
final class RestaurantInfoRouter: RestaurantInfoRouterProtocol {

    weak var viewController: UIViewController?

    /// Builds the info sheet, already wrapped in a navigation controller so it has a title bar.
    static func createModule(restaurant: Restaurant) -> UIViewController {
        let view = RestaurantInfoViewController()
        let interactor = RestaurantInfoInteractor(restaurant: restaurant)
        let router = RestaurantInfoRouter()
        let presenter = RestaurantInfoPresenter(view: view, interactor: interactor, router: router)

        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view

        let navigation = UINavigationController(rootViewController: view)
        navigation.sheetPresentationController?.detents = [.medium(), .large()]
        return navigation
    }

    func close() {
        viewController?.dismiss(animated: true)
    }
}
