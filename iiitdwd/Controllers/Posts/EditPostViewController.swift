//
//  EditPostViewController.swift
//  iiitdwd
//
//  Created by Souvik Das on 26/10/21.
//

import UIKit
import SDWebImage

class EditPostViewController: UITabBarController {
    
    private let headerView = CreatePostHeaderView()
    
    private var post: BlogPost
    
    init(post: BlogPost) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // Title field
    private let titleField: UITextField = {
        let field = UITextField()
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.leftViewMode = .always
        field.placeholder = "Enter Title"
        field.autocapitalizationType = .none
        field.autocorrectionType = .yes
        field.keyboardType = .default
        field.backgroundColor = nil
        field.layer.masksToBounds = true
        return field
    }()
    
    private let tags: UITextField = {
        let field = UITextField()
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.leftViewMode = .always
        field.placeholder = "Enter Tags/Labels ex: Mental Health, Club, Science"
        field.autocapitalizationType = .none
        field.autocorrectionType = .yes
        field.keyboardType = .default
        field.backgroundColor = nil
        field.layer.masksToBounds = true
        return field
    }()
    
    // Image Header
    private let headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "text.below.photo", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .ultraLight))
        imageView.tintColor = .systemPink
        //        imageView.backgroundColor = .white
        return imageView
    }()
    
    // TextView for post
    private let textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        textView.isEditable = true
        textView.dataDetectorTypes = .all
        textView.autocorrectionType = .yes
        textView.font = .systemFont(ofSize: 15)
        return textView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.isHidden = true
        indicator.style = .large
        indicator.backgroundColor = .separator
        indicator.layer.cornerRadius = 30
        return indicator
    }()
    
    private var selectedHeaderImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        titleField.text = post.title
        tags.text = post.tags
        headerImageView.sd_setImage(with: post.headerImageUrl, placeholderImage:UIImage(contentsOfFile:"launch-img"))
        textView.text = post.text
        
        view.addSubview(headerView)
        view.addSubview(headerImageView)
        view.addSubview(textView)
        view.addSubview(tags)
        view.addSubview(titleField)
        view.addSubview(activityIndicator)
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(didTapHeader))
        headerImageView.addGestureRecognizer(tap)
        configureButtons()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        headerView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
        titleField.frame = CGRect(x: 10, y: view.safeAreaInsets.top, width: view.width - 20, height: 50)
        tags.frame = CGRect(x: 10, y: titleField.bottom + 5, width: view.width - 20, height: 50)
        headerImageView.frame = CGRect(x: 10, y: tags.bottom+5, width: view.width - 20, height: 160)
        textView.frame = CGRect(x: 10, y: headerImageView.bottom+10, width: view.width - 20, height: view.height-headerImageView.bottom)
        activityIndicator.frame = CGRect(x: view.width/2 - 30, y: view.height/2 - 30, width: 60, height: 60)
    }
    
    @objc private func didTapHeader() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    private func configureButtons() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Update",
            style: .done,
            target: self,
            action: #selector(didTapUpdate)
        )
        
        navigationItem.rightBarButtonItem?.tintColor = .systemPink
    }
    
    @objc private func didTapUpdate() {
        
        // Check data and post
        guard let title = titleField.text,
              let _ = tags.text,
              let body = textView.text,
              let headerImage = headerImageView.image,
              let email = UserDefaults.standard.string(forKey: "email"),
              !title.trimmingCharacters(in: .whitespaces).isEmpty,
              !body.trimmingCharacters(in: .whitespaces).isEmpty else {
                  
                  let alert = UIAlertController(title: "Enter Post Details",
                                                message: "Please enter a title, body, and select a image to continue.",
                                                preferredStyle: .alert)
                  alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                  present(alert, animated: true)
                  return
              }
        
        print("Starting post...")
        
        self.post.title = titleField.text!
        self.post.tags = tags.text!
        //updated header image url is done below
        self.post.text = textView.text!
        
        view.isUserInteractionEnabled = false
        navigationItem.rightBarButtonItem = nil
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        // Upload header Image
        StorageManager.shared.uploadBlogHeaderImage(
            email: email,
            image: headerImage,
            postId: post.identifier
        ) { success in
            guard success else {
                self.configureButtons()
                self.view.isUserInteractionEnabled = true
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                return
            }
            StorageManager.shared.downloadUrlForPostHeader(email: email, postId: self.post.identifier) { url in
                guard let headerUrl = url else {
                    DispatchQueue.main.async {
                        self.configureButtons()
                        self.view.isUserInteractionEnabled = true
                        self.activityIndicator.isHidden = true
                        self.activityIndicator.stopAnimating()
                        HapticsManager.shared.vibrate(for: .error)
                    }
                    return
                }
                
                self.post.headerImageUrl = headerUrl
                
                DatabaseManager.shared.updatePost(post: self.post, email: email){
                    success in
                    guard success else {
                        self.configureButtons()
                        self.view.isUserInteractionEnabled = true
                        self.activityIndicator.isHidden = true
                        self.activityIndicator.stopAnimating()
                        return
                    }
                    DispatchQueue.main.async {
                        self.configureButtons()
                        self.view.isUserInteractionEnabled = true
                        self.activityIndicator.isHidden = true
                        self.activityIndicator.stopAnimating()
                        HapticsManager.shared.vibrate(for: .success)
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                
                
                //                    }
            }
        }
    }
}


extension EditPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        selectedHeaderImage = image
        headerImageView.image = image
    }
}

