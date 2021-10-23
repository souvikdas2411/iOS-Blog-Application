//
//  SearchProfileViewController.swift
//  iiitdwd
//
//  Created by Souvik Das on 23/10/21.
//

//
//  ProfileViewController.swift
//  iiitdwd
//
//  Created by Souvik Das on 21/10/21.
//

import UIKit

class SearchProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    let currentEmail: String
    
    private var user: User?
    
    private let headerView = ProfileHeaderView()
    
    private let refreshControl = UIRefreshControl()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
        tableView.backgroundColor = nil
        tableView.register(PostPreviewTableViewCell.self,
                           forCellReuseIdentifier: PostPreviewTableViewCell.identifier)
        return tableView
    }()
    
    init(currentEmail: String){
        self.currentEmail = currentEmail
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(headerView)
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchPosts()
        setUpTableHeader()
        fetchProfileData()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        headerView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
        tableView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.height)
        
    }
    
    private func setUpTableHeader(profilePhotoRef: String? = nil, name: String? = nil){
        let headerView = UIView(frame: CGRect(x: 0, y: 20, width: view.width, height: view.width))
        headerView.clipsToBounds = true
        headerView.isUserInteractionEnabled = true
        tableView.tableHeaderView = headerView
        
        let profilePhoto = UIImageView()
        profilePhoto.isUserInteractionEnabled = true
        profilePhoto.tintColor = .white
        profilePhoto.backgroundColor = .white
        profilePhoto.contentMode = .scaleAspectFit
        profilePhoto.layer.masksToBounds = true
        profilePhoto.layer.cornerRadius = 30
        profilePhoto.frame = CGRect(x: view.width/2 - 50,
                                    y: headerView.height/2 - 50,
                                    width: 100,
                                    height: 100)
        
        let activityIndicator: UIActivityIndicatorView = {
            let indicator = UIActivityIndicatorView()
            indicator.isHidden = false
            indicator.startAnimating()
            indicator.style = .large
            indicator.backgroundColor = .separator
            indicator.layer.cornerRadius = 30
            indicator.frame = CGRect(x: view.width/2 - 30, y: headerView.height/2 - 30, width: 60, height: 60)
            return indicator
        }()
        
        let emailLabel = UILabel(frame: CGRect(x: 0,
                                               y: profilePhoto.bottom + 10,
                                               width: view.width,
                                               height: 100))
        
        emailLabel.text = currentEmail
        emailLabel.textAlignment = .center
        emailLabel.font = .systemFont(ofSize: 25, weight: .light)
        
        if let name = name {
            title = name
        }
        
        if let ref = profilePhotoRef {
            StorageManager.shared.downloadUrlForProfilePicture(path: ref) { url in
                guard let url = url else {
                    return
                }
                activityIndicator.isHidden = false
                activityIndicator.startAnimating()
                let task = URLSession.shared.dataTask(with: url) { data, _, _ in
                    guard let data = data else {
                        //                        ivityIndicator.isHidden = true
                        //                        activityIndicator.startAnimating()
                        return
                    }
                    DispatchQueue.main.async {
                        activityIndicator.isHidden = true
                        activityIndicator.stopAnimating()
                        profilePhoto.image = UIImage(data: data)
                    }
                }
                
                task.resume()
            }
        }
        
        headerView.addSubview(emailLabel)
        headerView.addSubview(profilePhoto)
        headerView.addSubview(activityIndicator)
        
    }
    
    private func fetchProfileData() {
        DatabaseManager.shared.getUser(email: currentEmail) { [weak self] user in
            guard let user = user else {
                return
            }
            self?.user = user
            
            DispatchQueue.main.async {
                self?.setUpTableHeader(
                    profilePhotoRef: user.profilePictureRef,
                    name: user.name
                )
            }
        }
    }
    
    // TableView
    private var posts: [BlogPost] = []
    
    private func fetchPosts() {
        print("Fetching posts...")
        
        DatabaseManager.shared.getPosts(for: currentEmail) { [weak self] posts in
            self?.posts = posts
            print("Found \(posts.count) posts")
            DispatchQueue.main.async {
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
        
        
        
        // Our post
        let vc = ViewPostViewController(
            post: posts[indexPath.row]
        )
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = "Post"
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
}


