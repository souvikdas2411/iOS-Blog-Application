//
//  SignInHeaderView.swift
//  iiitdwd
//
//  Created by Souvik Das on 22/10/21.
//

import UIKit

class ProfileHeaderView: UIView {

    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "bg-view"))
        imageView.contentMode = .scaleToFill
//        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .light)
        label.text = "Welcome to the world of IIIT-DWD"
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true

        addSubview(imageView)
        addSubview(label)
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
