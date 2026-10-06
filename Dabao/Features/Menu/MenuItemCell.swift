import UIKit

final class MenuItemCell: UITableViewCell {

    static let reuseIdentifier = "MenuItemCell"

    var onAdd: (() -> Void)?
    var onRemove: (() -> Void)?

    private let nameLabel = UILabel()
    private let detailLabel = UILabel()
    private let priceLabel = UILabel()
    private let spicyIcon = UIImageView(image: UIImage(systemName: "flame.fill"))
    private let quantityLabel = UILabel()
    private let addButton = UIButton(type: .system)
    private let removeButton = UIButton(type: .system)
    private let nameRow = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        onAdd = nil
        onRemove = nil
    }

    private func setUpViews() {
        // Fix: Dynamic Type.
        nameLabel.font = .preferredFont(forTextStyle: .headline)
        detailLabel.font = .preferredFont(forTextStyle: .caption1)
        [nameLabel, detailLabel].forEach { $0.adjustsFontForContentSizeCategory = true }
        nameLabel.numberOfLines = 0
        detailLabel.textColor = .secondaryLabel
        detailLabel.numberOfLines = 2
        priceLabel.font = .systemFont(ofSize: 14, weight: .medium)
        quantityLabel.font = .systemFont(ofSize: 14, weight: .bold)
        quantityLabel.textColor = UIColor(named: "AccentColor")
        spicyIcon.tintColor = .systemRed
        spicyIcon.contentMode = .scaleAspectFit

        addButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        removeButton.setImage(UIImage(systemName: "minus.circle"), for: .normal)
        addButton.addAction(UIAction { [weak self] _ in self?.onAdd?() }, for: .touchUpInside)
        removeButton.addAction(UIAction { [weak self] _ in self?.onRemove?() }, for: .touchUpInside)

        nameRow.addArrangedSubview(nameLabel)
        nameRow.addArrangedSubview(spicyIcon)
        nameRow.isAccessibilityElement = true
        nameRow.spacing = 4
        nameRow.alignment = .center

        // The price is read out as part of nameRow, so hide the separate label from VoiceOver.
        priceLabel.isAccessibilityElement = false
        let textStack = UIStackView(arrangedSubviews: [nameRow, detailLabel, priceLabel])
        textStack.axis = .vertical
        textStack.spacing = 4
        textStack.alignment = .leading

        let buttons = UIStackView(arrangedSubviews: [removeButton, quantityLabel, addButton])
        buttons.spacing = 6
        buttons.alignment = .center

        [textStack, buttons].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            textStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            textStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            textStack.trailingAnchor.constraint(lessThanOrEqualTo: buttons.leadingAnchor, constant: -8),

            buttons.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            buttons.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            spicyIcon.widthAnchor.constraint(equalToConstant: 14),
            spicyIcon.heightAnchor.constraint(equalToConstant: 14),
            // Fix: Apple recommends tap targets of at least 44 x 44 points.
            addButton.widthAnchor.constraint(equalToConstant: 44),
            addButton.heightAnchor.constraint(equalToConstant: 44),
            removeButton.widthAnchor.constraint(equalToConstant: 44),
            removeButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    func configure(with row: MenuItemViewModel) {
        nameLabel.text = row.name
        detailLabel.text = row.detail
        priceLabel.text = row.priceText
        spicyIcon.isHidden = !row.isSpicy
        quantityLabel.text = row.quantityText
        quantityLabel.isHidden = row.quantityText == nil
        removeButton.isHidden = row.quantityText == nil

        // Sold-out dishes are greyed out.
        contentView.alpha = row.isSoldOut ? 0.4 : 1.0
        addButton.isEnabled = !row.isSoldOut

        // Fix: the + and - buttons were icons with no names, and "sold out" and "spicy"
        // were only shown with colour and an icon.
        addButton.accessibilityLabel = "Add \(row.name)"
        removeButton.accessibilityLabel = "Remove one \(row.name)"
        var description = [row.name, row.priceText]
        if row.isSpicy { description.append("Spicy") }
        if row.isSoldOut { description.append("Sold out") }
        if let quantity = row.quantityText { description.append("In cart: \(quantity.dropFirst())") }
        nameRow.accessibilityLabel = description.joined(separator: ", ")
        detailLabel.accessibilityLabel = row.detail
    }
}
