//
//  ViewPostViewController.swift
//  iiitdwd
//
//  Created by Souvik Das on 21/10/21.
//

import UIKit
import SDWebImage
import WebKit

class ViewPostViewController: UITabBarController {
    
    private let headerView = ViewerHeaderView()
    
    private let post: BlogPost
    
    init(post: BlogPost) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.backgroundColor = nil
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = nil
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let postTitle: UITextView = {
        let label = UITextView()
        label.font = .systemFont(ofSize: 25, weight: .semibold)
        label.textColor = .black
//        label.numberOfLines = 0
        label.isSelectable = true
        label.isEditable = true
        label.backgroundColor = .white
        label.textAlignment = .center
        label.isScrollEnabled = false
        label.sizeToFit()
        label.dataDetectorTypes = .all
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let postDetails: UITextView = {
        let label = UITextView()
        label.font = .systemFont(ofSize: 13, weight: .light)
        label.textColor = .lightGray
        label.isSelectable = true
        label.isEditable = true
//        label.numberOfLines = 0
        label.backgroundColor = .white
        label.textAlignment = .center
        label.isScrollEnabled = false
        label.sizeToFit()
        label.dataDetectorTypes = .all
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let postDesc: UITextView = {
        let label = UITextView()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.isEditable = false
        label.isSelectable = true
        label.sizeToFit()
        label.isScrollEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.dataDetectorTypes = .all
        label.backgroundColor = nil
        return label
    }()
    
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .separator
        return imageView
    }()
    
    private let moreAboutTheAuthor: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        view.addSubview(headerView)
        postImageView.layer.cornerRadius = view.width/5
        postTitle.text = post.title
        postDetails.text = "BY " + post.author.uppercased() + " ON " + post.timestamp
        postImageView.sd_setImage(with: post.headerImageUrl, placeholderImage:UIImage(contentsOfFile:"launch-img"))
        postDesc.text = post.text
        moreAboutTheAuthor.setTitle("More from " + post.author + "!", for: .normal)
        moreAboutTheAuthor.addTarget(self, action: #selector(didTapMore), for: .touchUpInside)
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        headerView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
        
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.safeAreaInsets.bottom + 5).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        contentView.addSubview(postTitle)
        postTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        postTitle.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        postTitle.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        
        contentView.addSubview(postDetails)
        postDetails.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        postDetails.topAnchor.constraint(equalTo: postTitle.bottomAnchor, constant: 5).isActive = true
        postDetails.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        
        contentView.addSubview(postImageView)
        postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        postImageView.topAnchor.constraint(equalTo: postDetails.bottomAnchor, constant: 5).isActive = true
        postImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        postImageView.widthAnchor.constraint(equalToConstant: view.width).isActive = true
        postImageView.heightAnchor.constraint(equalToConstant: view.width).isActive = true
        
        contentView.addSubview(postDesc)
        postDesc.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        postDesc.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 5).isActive = true
        postDesc.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
//        postDesc.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
//                postDesc.bottomAnchor.constraint(equalTo: moreAboutTheAuthor.topAnchor).isActive = true
        
        contentView.addSubview(moreAboutTheAuthor)
//        moreAboutTheAuthor.topAnchor.constraint(equalTo: postDesc.bottomAnchor, constant: 5).isActive = true
        moreAboutTheAuthor.topAnchor.constraint(equalTo: postDesc.bottomAnchor, constant: 5).isActive = true
        moreAboutTheAuthor.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        moreAboutTheAuthor.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        moreAboutTheAuthor.widthAnchor.constraint(equalToConstant: view.width).isActive = true
        moreAboutTheAuthor.heightAnchor.constraint(equalToConstant: 50).isActive = true
        moreAboutTheAuthor.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc private func didTapMore(){
        let vc = SearchProfileViewController(currentEmail: UserDefaults.standard.value(forKey: "email") as! String)
        vc.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.pushViewController(vc, animated: true)
        print("USER FOUND")
    }
}
