import Foundation

/// Anything that can give us restaurants. The real app talks to a server;
/// ours reads a JSON file bundled with the app, so it works offline in class.
protocol RestaurantServicing {
    func fetchRestaurants(completion: @escaping (Result<[Restaurant], Error>) -> Void)
}

final class RestaurantService: RestaurantServicing {

    enum ServiceError: Error {
        case fileNotFound
    }

    private let bundle: Bundle
    private let simulatedDelay: TimeInterval

    init(bundle: Bundle = .main, simulatedDelay: TimeInterval = 0.4) {
        self.bundle = bundle
        self.simulatedDelay = simulatedDelay
    }

    func fetchRestaurants(completion: @escaping (Result<[Restaurant], Error>) -> Void) {
        // Pretend we're on a slow network, so we can see loading states.
        DispatchQueue.main.asyncAfter(deadline: .now() + simulatedDelay) { [bundle] in
            guard let url = bundle.url(forResource: "restaurants", withExtension: "json") else {
                completion(.failure(ServiceError.fileNotFound))
                return
            }
            do {
                let data = try Data(contentsOf: url)
                let restaurants = try JSONDecoder().decode([Restaurant].self, from: data)
                completion(.success(restaurants))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
