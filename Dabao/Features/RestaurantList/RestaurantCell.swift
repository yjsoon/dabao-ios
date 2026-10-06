import UIKit

final class RestaurantCell: UITableViewCell {

    static let reuseIdentifier = "RestaurantCell"

    private let photoView = UIImageView()
    private let nameLabel = UILabel()
    private let detailLabel = UILabel()
    private let starsStack = UIStackView()
    private let statusDot = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpViews() {
        photoView.contentMode = .scaleAspectFit
        photoView.tintColor = UIColor(named: "AccentColor")
        photoView.backgroundColor = .secondarySystemBackground
        photoView.layer.cornerRadius = 12
        photoView.clipsToBounds = true

        // Fix: use text styles so the fonts follow the user's text size (Dynamic Type).
        nameLabel.font = .preferredFont(forTextStyle: .headline)
        nameLabel.adjustsFontForContentSizeCategory = true
        nameLabel.numberOfLines = 0
        detailLabel.font = .preferredFont(forTextStyle: .footnote)
        detailLabel.adjustsFontForContentSizeCategory = true
        detailLabel.numberOfLines = 0
        // Fix: .lightGray on white is too low contrast. .secondaryLabel adapts to dark mode too.
        detailLabel.textColor = .secondaryLabel

        starsStack.axis = .horizontal
        starsStack.spacing = 2

        statusDot.layer.cornerRadius = 5

        let textStack = UIStackView(arrangedSubviews: [nameLabel, detailLabel, starsStack])
        textStack.axis = .vertical
        textStack.spacing = 4
        textStack.alignment = .leading

        [photoView, textStack, statusDot].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            photoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            photoView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            photoView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 12),
            photoView.widthAnchor.constraint(equalToConstant: 64),
            photoView.heightAnchor.constraint(equalToConstant: 64),

            textStack.leadingAnchor.constraint(equalTo: photoView.trailingAnchor, constant: 12),
            textStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            textStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            textStack.trailingAnchor.constraint(lessThanOrEqualTo: statusDot.leadingAnchor, constant: -8),

            statusDot.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            statusDot.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            statusDot.widthAnchor.constraint(equalToConstant: 10),
            statusDot.heightAnchor.constraint(equalToConstant: 10)
        ])
    }

    func configure(with restaurant: Restaurant) {
        photoView.image = UIImage(systemName: restaurant.imageName)
        nameLabel.text = restaurant.name
        detailLabel.text = "\(restaurant.cuisine) · \(restaurant.deliveryMinutes) min · \(PriceFormatter.string(from: restaurant.deliveryFee)) delivery"

        starsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let fullStars = Int(restaurant.rating.rounded())
        for index in 0..<5 {
            let star = UIImageView(image: UIImage(systemName: index < fullStars ? "star.fill" : "star"))
            star.tintColor = .systemOrange
            starsStack.addArrangedSubview(star)
        }

        statusDot.backgroundColor = restaurant.isOpen ? .systemGreen : .systemRed
        // Fix: don't rely on colour alone. Say "Closed" in words as well.
        if !restaurant.isOpen {
            detailLabel.text = "Closed now · " + (detailLabel.text ?? "")
        }

        // Fix: read the whole cell as one item, with the stars and the open/closed dot
        // described in words (they were images and colour only).
        isAccessibilityElement = true
        accessibilityLabel = [
            restaurant.name,
            restaurant.cuisine,
            String(format: "Rated %.1f out of 5", restaurant.rating),
            "\(restaurant.deliveryMinutes) minutes",
            "\(PriceFormatter.string(from: restaurant.deliveryFee)) delivery",
            restaurant.isOpen ? "Open" : "Closed"
        ].joined(separator: ", ")
        accessibilityTraits = .button
    }
}
