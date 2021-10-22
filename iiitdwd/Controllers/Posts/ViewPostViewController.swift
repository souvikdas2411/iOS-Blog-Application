//
//  ViewPostViewController.swift
//  iiitdwd
//
//  Created by Souvik Das on 21/10/21.
//

import UIKit

class ViewPostViewController: UITabBarController, UITableViewDataSource, UITableViewDelegate {

    private let headerView = ViewerHeaderView()
    
    private let post: BlogPost
//    private let isOwnedByCurrentUser: Bool

    init(post: BlogPost) {
        self.post = post
//        self.isOwnedByCurrentUser = isOwnedByCurrentUser
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self,
                       forCellReuseIdentifier: "cell")
        table.register(PostHeaderTableViewCell.self,
                       forCellReuseIdentifier: PostHeaderTableViewCell.identifier)
        table.backgroundColor = nil
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(headerView)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self

//        if !isOwnedByCurrentUser {
//            IAPManager.shared.logPostViewed()
//        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
        tableView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.height - (view.safeAreaInsets.bottom + (self.tabBarController?.tabBar.frame.height)!))
    }

    // Table
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 // title, iamge, text
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        switch index {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.selectionStyle = .none
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.font = .systemFont(ofSize: 25, weight: .bold)
            cell.textLabel?.text = post.title
            cell.backgroundColor = .separator
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PostHeaderTableViewCell.identifier,
                                                           for: indexPath) as? PostHeaderTableViewCell else {
                fatalError()
            }
            cell.selectionStyle = .none
            cell.configure(with: .init(imageUrl: post.headerImageUrl))
            cell.backgroundColor = .separator
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.selectionStyle = .none
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = post.text
            cell.backgroundColor = .separator
            return cell
        default:
            fatalError()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let index = indexPath.row
        switch index {
        case 0:
            return UITableView.automaticDimension
        case 1:
            return 250
        case 2:
            return UITableView.automaticDimension
        default:
            return UITableView.automaticDimension
        }
    }
}
