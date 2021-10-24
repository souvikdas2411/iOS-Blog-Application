//
//  ViewController.swift
//  iiitdwd
//
//  Created by Souvik Das on 21/10/21.
//

import UIKit

class resultsVC: UIViewController {
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Please type the full email address and hit search!"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.backgroundColor = .separator
        view.addSubview(label)
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        label.topAnchor.constraint(equalTo: view.topAnchor, constant: view.safeAreaInsets.top).isActive = true
        label.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20).isActive = true
    }
    
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    private let headerView = ViewControllerHeaderView()
    
    private let refreshControl = UIRefreshControl()
    
    private let searchController = UISearchController(searchResultsController: resultsVC())
    
    
    private let composeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.setImage(UIImage(systemName: "square.and.pencil",
                                withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .ultraLight)),
                        for: .normal)
        button.layer.cornerRadius = 30
        button.layer.shadowColor = UIColor.label.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowRadius = 10
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
        tableView.register(PostPreviewTableViewCell.self,
                           forCellReuseIdentifier: PostPreviewTableViewCell.identifier)
        tableView.backgroundColor = nil
        return tableView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.isHidden = true
        indicator.style = .large
        indicator.backgroundColor = .separator
        indicator.layer.cornerRadius = 30
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        searchController.searchBar.delegate = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.placeholder = "Search Users"
        searchController.searchBar.tintColor = .white
        searchController.searchBar.keyboardType = .emailAddress
        navigationItem.searchController = searchController
        
        view.addSubview(headerView)
        view.addSubview(tableView)
        view.addSubview(composeButton)
        view.addSubview(activityIndicator)
        composeButton.addTarget(self, action: #selector(didTapCreate), for: .touchUpInside)
        tableView.delegate = self
        tableView.dataSource = self
        
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(didRefresh), for: .valueChanged)
        fetchAllPosts()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
        composeButton.frame = CGRect(
            x: view.frame.width - 70,
            y: view.frame.height - 80 - view.safeAreaInsets.bottom,
            width: 60,
            height: 60
        )
        
//        tableView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.height - (view.safeAreaInsets.bottom + (self.tabBarController?.tabBar.frame.height)!) - 100)
        tableView.frame = CGRect(x: 0,
                                 y: view.safeAreaInsets.top,
                                 width: view.width,
                                 height: view.height - (view.safeAreaInsets.bottom + (self.tabBarController?.tabBar.frame.height)! + self.searchController.searchBar.frame.height))
        activityIndicator.frame = CGRect(x: view.width/2 - 30, y: view.height/2 - 30, width: 60, height: 60)
    }
    
    @objc private func didTapCreate() {
        let vc = CreateNewPostViewController()
        vc.title = "Create Post"
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
    
    @objc private func didRefresh() {
        fetchAllPosts()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private var posts: [BlogPost] = []
    
    private func fetchAllPosts() {
        print("Fetching home feed...")
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()

        DatabaseManager.shared.getAllPosts { [weak self] posts in
            
            self?.posts = posts.sorted(by: {$0.timestamp > $1.timestamp})
            

            DispatchQueue.main.async {
                self?.activityIndicator.isHidden = true
                self?.activityIndicator.stopAnimating()
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostPreviewTableViewCell.identifier, for: indexPath) as? PostPreviewTableViewCell else {
            fatalError()
        }
        cell.configure(with: .init(title: post.title, author: post.author, imageUrl: post.headerImageUrl))
        cell.backgroundColor = .separator
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        HapticsManager.shared.vibrateForSelection()
        
        let vc = ViewPostViewController(post: posts[indexPath.row])
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = "Post"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        DatabaseManager.shared.getUser(email: searchBar.text?.lowercased() ?? "none") { [weak self] user in
            guard let _ = user else {
                let dialogMessage = UIAlertController(title: "Alert", message: "User not found! Please check the email address entered!", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Try again", style: .default, handler: { (action) -> Void in
//                    searchBar.text = ""
                })
                dialogMessage.addAction(ok)
                self?.present(dialogMessage, animated: true, completion: nil)
                return
            }
            
            let vc = SearchProfileViewController(currentEmail: searchBar.text?.lowercased() ?? "none")
            vc.navigationItem.largeTitleDisplayMode = .never
            self?.navigationController?.pushViewController(vc, animated: true)
            print("USER FOUND")
        }
    }
}


