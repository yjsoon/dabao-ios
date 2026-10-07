import UIKit

/// The View. It doesn't decide anything: it shows what the presenter tells it to,
/// and forwards taps to the presenter.
final class MenuViewController: UIViewController {

    var presenter: MenuPresenterProtocol!

    private var sections: [MenuSectionViewModel] = []

    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let spinner = UIActivityIndicatorView(style: .large)
    private let headerView = MenuHeaderView()
    private let cartBar = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        navigationItem.largeTitleDisplayMode = .never

        setUpTableView()
        setUpCartBar()
        setUpSpinner()

        presenter.viewDidLoad()
    }

    private func setUpTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.register(MenuItemCell.self, forCellReuseIdentifier: MenuItemCell.reuseIdentifier)
        tableView.allowsSelection = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setUpCartBar() {
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.baseBackgroundColor = UIColor(named: "AccentColor")
        cartBar.configuration = config
        cartBar.translatesAutoresizingMaskIntoConstraints = false
        cartBar.isHidden = true
        cartBar.addAction(UIAction { [weak self] _ in
            self?.presenter.didTapCartBar()
        }, for: .touchUpInside)
        view.addSubview(cartBar)

        NSLayoutConstraint.activate([
            cartBar.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            cartBar.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            cartBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            // Fix: let the cart bar grow with the text instead of clipping it.
            cartBar.heightAnchor.constraint(greaterThanOrEqualToConstant: 50)
        ])
    }

    private func setUpSpinner() {
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        view.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Leave room under the list for the cart bar, however tall it is.
        tableView.contentInset.bottom = cartBar.isHidden ? 0 : cartBar.bounds.height + 24
    }

    private func indexPath(forItemID id: String) -> IndexPath? {
        for (sectionIndex, section) in sections.enumerated() {
            if let rowIndex = section.rows.firstIndex(where: { $0.id == id }) {
                return IndexPath(row: rowIndex, section: sectionIndex)
            }
        }
        return nil
    }
}

// MARK: - MenuViewProtocol

extension MenuViewController: MenuViewProtocol {

    func showLoading(_ isLoading: Bool) {
        isLoading ? spinner.startAnimating() : spinner.stopAnimating()
    }

    func showHeader(_ header: MenuHeaderViewModel) {
        title = header.title
        headerView.configure(with: header)
        // Fix: fix the width and let the height grow, so the Closed banner can wrap.
        headerView.frame.size = headerView.systemLayoutSizeFitting(
            CGSize(width: view.bounds.width, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel)
        tableView.tableHeaderView = headerView
    }

    func showSections(_ sections: [MenuSectionViewModel]) {
        self.sections = sections
        tableView.reloadData()
    }

    func reloadRow(_ row: MenuItemViewModel) {
        guard let indexPath = indexPath(forItemID: row.id) else { return }
        var rows = sections[indexPath.section].rows
        rows[indexPath.row] = row
        sections[indexPath.section] = MenuSectionViewModel(title: sections[indexPath.section].title, rows: rows)
        tableView.reloadRows(at: [indexPath], with: .none)
    }

    func showCartBar(title: String?) {
        cartBar.isHidden = (title == nil)
        cartBar.configuration?.title = title
        view.setNeedsLayout()
    }

    func showMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Table view data source

extension MenuViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].title
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuItemCell.reuseIdentifier,
                                                 for: indexPath) as! MenuItemCell
        let row = sections[indexPath.section].rows[indexPath.row]
        cell.configure(with: row)
        cell.onAdd = { [weak self] in self?.presenter.didTapAdd(itemID: row.id) }
        cell.onRemove = { [weak self] in self?.presenter.didTapRemove(itemID: row.id) }
        return cell
    }
}

// MARK: - Header

final class MenuHeaderView: UIView {

    private let subtitleLabel = UILabel()
    private let closedLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        subtitleLabel.font = .systemFont(ofSize: 15)
        subtitleLabel.textColor = .secondaryLabel

        closedLabel.text = "Closed now. You can browse, but not order."
        // Fix: Dynamic Type, and a darker red so white text passes the 4.5:1 contrast check.
        closedLabel.font = .preferredFont(forTextStyle: .subheadline)
        closedLabel.adjustsFontForContentSizeCategory = true
        closedLabel.numberOfLines = 0
        closedLabel.textColor = .white
        closedLabel.backgroundColor = UIColor(red: 0.70, green: 0.07, blue: 0.07, alpha: 1)
        closedLabel.textAlignment = .center
        closedLabel.layer.cornerRadius = 8
        closedLabel.clipsToBounds = true

        let stack = UIStackView(arrangedSubviews: [subtitleLabel, closedLabel])
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            closedLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 32)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with header: MenuHeaderViewModel) {
        subtitleLabel.text = header.subtitle
        closedLabel.isHidden = header.isOpen
    }
}
