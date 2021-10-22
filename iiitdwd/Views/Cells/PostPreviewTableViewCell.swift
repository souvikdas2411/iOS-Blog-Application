//
//  PostPreviewTableViewCell.swift
//  iiitdwd
//
//  Created by Souvik Das on 22/10/21.
//

import UIKit
import SDWebImage

class PostPreviewTableViewCellViewModel {
    let title: String
    let imageUrl: URL?
    var imageData: Data?

    init(title: String, imageUrl: URL?) {
        self.title = title
        self.imageUrl = imageUrl
    }
}

class PostPreviewTableViewCell: UITableViewCell {
    static let identifier = "PostPreviewTableViewCell"

    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
//        imageView.layer.cornerRadius = 8
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = nil
        return imageView
    }()

    private let postTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15, weight: .light)
        return label
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.isHidden = false
        indicator.startAnimating()
        indicator.style = .large
        indicator.backgroundColor = .separator
//        indicator.layer.cornerRadius = 30
        return indicator
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(postImageView)
        contentView.addSubview(activityIndicator)
        contentView.addSubview(postTitleLabel)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        postImageView.frame = CGRect(
            x: separatorInset.left,
            y: 5,
            width: contentView.height-10,
            height: contentView.height-10
        )
        postImageView.layer.cornerRadius = (contentView.height-10)/2
        activityIndicator.frame = CGRect(x: separatorInset.left,
                                         y: 5,
                                         width: contentView.height-10,
                                         height: contentView.height-10)
        activityIndicator.layer.cornerRadius = (contentView.height-10)/2
        postTitleLabel.frame = CGRect(
            x: postImageView.right+5,
            y: 5,
            width: contentView.width-5-separatorInset.left-postImageView.width,
            height: contentView.height-10
        )
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        postTitleLabel.text = nil
        postImageView.image = nil
    }

    func configure(with viewModel: PostPreviewTableViewCellViewModel) {
        postTitleLabel.text = viewModel.title
        
 
        DispatchQueue.main.async {
            self.postImageView.sd_setImage(with: viewModel.imageUrl, placeholderImage:UIImage(contentsOfFile:"launch-img"))
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
        }
    }
}
