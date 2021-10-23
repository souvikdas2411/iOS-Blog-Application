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
        label.backgroundColor = .separator
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
        label.backgroundColor = .separator
        return label
    }()
    
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .separator
        return imageView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(headerView)
        
        postTitle.text = post.title
        postImageView.sd_setImage(with: post.headerImageUrl, placeholderImage:UIImage(contentsOfFile:"launch-img"))
        postDesc.text = post.text
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
        postDesc.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
}
