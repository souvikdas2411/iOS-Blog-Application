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
        label.font = .systemFont(ofSize: 25, weight: .light)
        label.backgroundColor = nil
        label.textAlignment = .center
        label.isEditable = false
        label.isSelectable = true
        label.sizeToFit()
        label.isScrollEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.dataDetectorTypes = .all
        return label
    }()
    
    private let postDesc: UITextView = {
        let label = UITextView()
        label.font = .systemFont(ofSize: 15, weight: .light)
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
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = nil
        return imageView
    }()
    
    private let moreAboutTheAuthor: UIButton = {
        let button = UIButton()
//        button.setTitle("More from the " + post.author + "!", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(headerView)
        
        postTitle.text = post.title
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
        
        contentView.addSubview(postImageView)
        postImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        postImageView.topAnchor.constraint(equalTo: postTitle.bottomAnchor, constant: 5).isActive = true
        postImageView.widthAnchor.constraint(equalToConstant: view.width).isActive = true
        postImageView.heightAnchor.constraint(equalToConstant: view.width).isActive = true
        
        contentView.addSubview(postDesc)
        postDesc.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        postDesc.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 5).isActive = true
        postDesc.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
//        postDesc.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        contentView.addSubview(moreAboutTheAuthor)
        
        moreAboutTheAuthor.topAnchor.constraint(equalTo: postDesc.bottomAnchor, constant: 5).isActive = true
//        moreAboutTheAuthor.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: contentView.width - 100).isActive = true
        moreAboutTheAuthor.widthAnchor.constraint(equalToConstant: view.width).isActive = true
        moreAboutTheAuthor.heightAnchor.constraint(equalToConstant: 50).isActive = true
        moreAboutTheAuthor.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
        
        
        
    }
    
    @objc private func didTapMore(){
        let vc = SearchProfileViewController(currentEmail: UserDefaults.standard.value(forKey: "email") as! String)
        vc.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.pushViewController(vc, animated: true)
        print("USER FOUND")
    }
}
