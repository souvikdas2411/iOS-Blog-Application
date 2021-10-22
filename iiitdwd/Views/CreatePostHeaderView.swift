//
//  CreatePostHeaderView.swift
//  iiitdwd
//
//  Created by Souvik Das on 22/10/21.
//

import UIKit

class CreatePostHeaderView: UIView {

    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "launch-img"))
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .systemBackground
        return imageView
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true

        addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        let size: CGFloat = width/4
//        label.frame = CGRect(x: 0, y: 10, width: width - 10, height: height/4)
        imageView.frame = CGRect(x: 0, y: 0, width: width, height: height)

    }
    
}
