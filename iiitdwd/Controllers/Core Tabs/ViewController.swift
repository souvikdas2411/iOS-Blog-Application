//
//  ViewController.swift
//  iiitdwd
//
//  Created by Souvik Das on 21/10/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    private var posts: [BlogPost] = []
    
    private let headerView = ViewControllerHeaderView()
    
    private let refreshControl = UIRefreshControl()
    
    var filteredTableData = [BlogPost]()
    var resultSearchController = UISearchController()
    
    
    private let composeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .link
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
        tableView.keyboardDismissMode = .onDrag
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
//        view.backgroundColor = .systemBackground
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chart.line.uptrend.xyaxis"),
                                                            style: .done, target: self, action: #selector(trendTapped))
        navigationItem.rightBarButtonItem?.tintColor = .systemPink
        
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
        
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.obscuresBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.placeholder = "Anything!"
//            controller.searchBar.barStyle = .default
//            controller.searchBar.barTintColor = .white
            
            tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        
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
        
        activityIndicator.frame = CGRect(x: view.width/2 - 30, y: view.height/2 - 30, width: 60, height: 60)
    }
    
    @objc private func didTapCreate() {
        let vc = CreateNewPostViewController()
        vc.title = "Create Post"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
//        self.present(vc, animated: true, completion: nil)
    }
    
    @objc private func trendTapped() {
        
    }
    
    @objc private func didRefresh() {
        fetchAllPosts()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
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
        
        if  (resultSearchController.isActive) {
            return filteredTableData.count
        } else {
            return posts.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostPreviewTableViewCell.identifier, for: indexPath) as? PostPreviewTableViewCell else {
            fatalError()
        }
                
        if (resultSearchController.isActive) {
            cell.configure(with: .init(title: filteredTableData[indexPath.row].title, author: filteredTableData[indexPath.row].author, tags: filteredTableData[indexPath.row].tags, desc: filteredTableData[indexPath.row].text, imageUrl: filteredTableData[indexPath.row].headerImageUrl))
            return cell
        }
        else {
            cell.configure(with: .init(title: post.title, author: post.author, tags: post.tags, desc: post.text, imageUrl: post.headerImageUrl))
//            cell.backgroundColor = .blue
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (resultSearchController.isActive) {
            let vc = ViewPostViewController(post: filteredTableData[indexPath.row])
            vc.navigationItem.largeTitleDisplayMode = .never
            resultSearchController.searchBar.text = ""
            resultSearchController.dismiss(animated: true, completion: nil)
            navigationController?.pushViewController(vc, animated: true)
        }
        else {
            let vc = ViewPostViewController(post: posts[indexPath.row])
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ViewController {

func updateSearchResults(for searchController: UISearchController) {
    filteredTableData.removeAll(keepingCapacity: false)

    let array = posts.filter {
        $0.title.lowercased().contains(searchController.searchBar.text!.lowercased()) || $0.author.lowercased().contains(searchController.searchBar.text!.lowercased()) || $0.tags.lowercased().contains(searchController.searchBar.text!.lowercased())
        
    }
    filteredTableData = array

    self.tableView.reloadData()
}
}


