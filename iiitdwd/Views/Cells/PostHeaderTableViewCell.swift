//
//  PostHeaderTableViewCell.swift
//  iiitdwd
//
//  Created by Souvik Das on 22/10/21.
//

import UIKit
import SDWebImage

class PostHeaderTableViewCellViewModel {
    let imageUrl: URL?
    var imageData: Data?

    init(imageUrl: URL?) {
        self.imageUrl = imageUrl
    }
}

class PostHeaderTableViewCell: UITableViewCell {
    static let identifier = "PostHeaderTableViewCell"

    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
//        imageView.backgroundColor = .separator
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(postImageView)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        postImageView.frame = contentView.bounds
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        postImageView.image = nil
    }

    func configure(with viewModel: PostHeaderTableViewCellViewModel) {
        DispatchQueue.main.async {
            self.postImageView.sd_setImage(with: viewModel.imageUrl, placeholderImage:UIImage(contentsOfFile:"launch-img"))

        }
        
    }
}
