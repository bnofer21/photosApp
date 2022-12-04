//
//  SearchViewController.swift
//  photosApp
//
//  Created by Юрий on 04.12.2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    var currentUser: User
    var users = [User]()
    var searchResults = [User]()
    let searchView = SearchView()
    
    init(currentUser: User) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = searchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setTableDelegates()
        fetchAllUsers()
        searchFieldDelegateTarget()
    }
    
    private func fetchAllUsers() {
        UserService.shared.fetchUsers { results in
            self.users = results
            self.searchResults = results
            self.searchView.tableView.reloadData()
        }
    }
    
    private func setupView() {
        navigationItem.title = "Search"
        view.backgroundColor = .systemBackground
    }
    
    private func setTableDelegates() {
        searchView.tableView.delegate = self
        searchView.tableView.dataSource = self
    }
    
    private func searchFieldDelegateTarget() {
        searchView.searchField.delegate = self
        searchView.setFieldDelegateTarget(target: self, action: #selector(updateSearchResults(sender:)))
    }

}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.cellId, for: indexPath) as? UserCell else { return UITableViewCell() }
        cell.viewModel = UserCellViewModel(user: searchResults[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ProfileViewController(user: users[indexPath.row], currentUser: currentUser)
//        searchView.searchField.isHidden = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension SearchViewController: UITextFieldDelegate {
    
    @objc func updateSearchResults(sender: UITextField) {
        guard let text = sender.text, text != "" else {
            searchResults = users
            searchView.tableView.reloadData()
            return
        }
        searchResults = searchResults.filter { user in
            user.name.contains(text)
        }
        searchView.tableView.reloadData()
    }
    
}
