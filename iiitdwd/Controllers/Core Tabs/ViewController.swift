//
//  ViewController.swift
//  iiitdwd
//
//  Created by Souvik Das on 21/10/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let headerView = ViewControllerHeaderView()
    
    private let refreshControl = UIRefreshControl()
    
    private let composeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.setImage(UIImage(systemName: "square.and.pencil",
                                withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium)),
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(headerView)
        view.addSubview(tableView)
        view.addSubview(composeButton)
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
        tableView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.height - (view.safeAreaInsets.bottom + (self.tabBarController?.tabBar.frame.height)!))
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
    
    private var posts: [BlogPost] = []
    
    private func fetchAllPosts() {
        print("Fetching home feed...")
        
        DatabaseManager.shared.getAllPosts { [weak self] posts in
            self?.posts = posts
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
//                self?.activityIndicatorView.stopAnimating()
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
    
}
