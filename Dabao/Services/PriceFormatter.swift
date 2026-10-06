import Foundation

/// Turns a Decimal into "$4.50". Shared by every screen that shows prices.
enum PriceFormatter {

    private static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "SGD"
        formatter.currencySymbol = "$"
        formatter.locale = Locale(identifier: "en_SG")
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    static func string(from amount: Decimal) -> String {
        formatter.string(from: amount as NSDecimalNumber) ?? "$0.00"
    }
}
