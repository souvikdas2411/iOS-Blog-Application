//
//  PostDescViewCell.swift
//  iiitdwd
//
//  Created by Souvik Das on 23/10/21.
//

import UIKit

class PostDescTableViewCellViewModel {
    let desc: String

    init(desc: String) {
        self.desc = desc
    }
}

class PostDescTableViewCell: UITableViewCell {
    static let identifier = "PostDescTableViewCell"


    private let postDesc: UITextView = {
        let label = UITextView()
//        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15, weight: .light)
        label.isEditable = false
        label.isSelectable = true
//        label.isScrollEnabled = falsek
        label.sizeToFit()
        label.dataDetectorTypes = .all
        label.backgroundColor = nil
        return label
    }()
    
//    let test: UILabel = {
//        let label = UILabel()
//        label.is
//    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(postDesc)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        postDesc.frame = CGRect(
            x: 0,
            y: 0,
            width: contentView.width,
            height: contentView.height
        )
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        postDesc.text = nil
    }

    func configure(with viewModel: PostDescTableViewCellViewModel) {
        postDesc.text = viewModel.desc
    }
}

