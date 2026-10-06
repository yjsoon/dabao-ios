import UIKit

final class RestaurantInfoViewController: UITableViewController {

    var presenter: RestaurantInfoPresenterProtocol!
    private var rows: [InfoRowViewModel] = []

    init() {
        super.init(style: .insetGrouped)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "InfoCell")
        tableView.allowsSelection = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            systemItem: .done,
            primaryAction: UIAction { [weak self] _ in self?.presenter.didTapDone() })
        presenter.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath)
        var content = UIListContentConfiguration.valueCell()
        content.text = rows[indexPath.row].title
        content.secondaryText = rows[indexPath.row].value
        cell.contentConfiguration = content
        return cell
    }
}

extension RestaurantInfoViewController: RestaurantInfoViewProtocol {

    func showTitle(_ title: String) {
        self.title = title
    }

    func showRows(_ rows: [InfoRowViewModel]) {
        self.rows = rows
        tableView.reloadData()
    }
}
