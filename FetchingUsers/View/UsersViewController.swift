//
//  ViewController.swift
//  FetchingUsers
//
//  Created by Alex Murphy on 24.10.2022.
//
import UIKit

public final class UsersViewController: UIViewController {

	// MARK: - Properties
	var viewModel = UsersViewModel()
	var usersData: [Users] = []

	var searching = false
	var searchingUser: [Users] = []
	let searchController = UISearchController()

	// MARK: - Gradient
	private let primaryColor = UIColor(
		red: 76/255,
		green: 122/255,
		blue: 240/255,
		alpha: 1
	)

	private let secondaryColor = UIColor(
		red: 25/255,
		green: 42/255,
		blue: 90/255,
		alpha: 1
	)

	private lazy var tableView: UITableView = {
		let table = UITableView()
		table.backgroundColor = .clear
		table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
		table.translatesAutoresizingMaskIntoConstraints = false
		return table
	}()

	public override func viewDidLoad() {
		super.viewDidLoad()
		setupNavigationBar()
		view.addSubview(tableView)
		addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
		tableView.delegate = self
		tableView.dataSource = self
		addTableViewConstraints()
		navigationItem.searchController = searchController
		searchController.searchResultsUpdater = self
		definesPresentationContext = true
		tableView.refreshControl = UIRefreshControl()
		tableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)

		try? viewModel.fetchUsers { result in
//			print("Trying to fetch users")
			switch result {
			case .success(let users):
				self.usersData = users
//				print(users)
			case .failure(let error):
				print(error)
			}
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
		configureSearchController()
	}

	// MARK: - Refresh
	@objc
	private func didPullToRefresh() {
		// Re-fetch data here
		usersData.removeAll()
		try? viewModel.fetchUsers { result in
//			print("Trying to refresh users")
			switch result {
			case .success(let users):
				self.usersData = users
			case .failure(let error):
				print(error)
			}
			DispatchQueue.main.async {
				self.tableView.refreshControl?.endRefreshing()
				self.tableView.reloadData()
			}
		}
	}

	// MARK: - Constraints
		private func addTableViewConstraints() {
			NSLayoutConstraint.activate([
				tableView.topAnchor.constraint(equalTo: view.topAnchor),
				tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
				tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
				tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
			])
		}

	// MARK: - Setup Navigation Bar
	public func setupNavigationBar() {
		title = "Search"
		navigationController?.navigationBar.prefersLargeTitles = true
		let navBarAppearance = UINavigationBarAppearance()
		navBarAppearance.backgroundColor = UIColor(named: "default")
		navigationController?.navigationBar.tintColor = .white
		navigationController?.navigationBar.standardAppearance = navBarAppearance
		navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
	}

	// MARK: - Search Controller
	private func configureSearchController() {
		searchController.loadViewIfNeeded()
		searchController.searchResultsUpdater = self
		searchController.searchBar.delegate = self
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.enablesReturnKeyAutomatically = false
		searchController.searchBar.returnKeyType = UIReturnKeyType.done
		self.navigationItem.searchController = searchController
		self.navigationItem.hidesSearchBarWhenScrolling = false
		definesPresentationContext = true
		searchController.searchBar.placeholder = "Search"
	}
}

    // MARK: - Table View
	extension UsersViewController: UITableViewDelegate {

		public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
			tableView.deselectRow(at: indexPath, animated: true)
			let userName = searching ? searchingUser[indexPath.row] : usersData[indexPath.row]
			let detailVC = DetailContactViewController()
			detailVC.result = userName
			detailVC.title = userName.name
			navigationController?.pushViewController(detailVC, animated: true)
		}
	}
extension UsersViewController: UITableViewDataSource {

	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if searching {
			return searchingUser.count
		} else {
			return self.usersData.count
		}
	}

	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		var content = cell.defaultContentConfiguration()

		if searching {
			content.text = searchingUser[indexPath.row].name
		} else {
			content.text = usersData[indexPath.row].name
		}
		cell.contentConfiguration = content
		cell.backgroundColor = .clear
		return cell
	}
}

// MARK: - Background color
extension UsersViewController {
	func addVerticalGradientLayer(topColor: UIColor, bottomColor: UIColor) {
		let gradient = CAGradientLayer()
		gradient.frame = view.bounds
		gradient.colors = [topColor.cgColor, bottomColor.cgColor]
		gradient.locations = [0.0, 1.0]
		gradient.startPoint = CGPoint(x:0, y: 0)
		gradient.endPoint = CGPoint(x: 0, y: 1)
		view.layer.insertSublayer(gradient, at: 0)
	}
}

extension UsersViewController: UISearchBarDelegate {
	public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		searching = false
		searchingUser.removeAll()
		tableView.reloadData()
	}
}

extension UsersViewController: UISearchResultsUpdating {
	public func updateSearchResults(for searchController: UISearchController) {
				guard let text = searchController.searchBar.text else { return }
				if !text.isEmpty {
					searching = true
					searchingUser.removeAll()
					for filteredUser in usersData {
						if filteredUser.name.lowercased().contains(text.lowercased()) {
							searchingUser.append(filteredUser)
						}
					}
				} else {
				searching = false
				searchingUser.removeAll()
					searchingUser = usersData
			}
			tableView.reloadData()
	}
}
