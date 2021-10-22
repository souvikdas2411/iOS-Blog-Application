//
//  ViewController.swift
//  iiitdwd
//
//  Created by Souvik Das on 21/10/21.
//

import UIKit

class ViewController: UIViewController {

//    private let createButton: UIButton = {
//        let button = UIButton()
//        button.layer.masksToBounds = true
//        button.layer.cornerRadius = 30
//        button.backgroundColor = .white
//
//        return button
//    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
//        DispatchQueue.main.asyncAfter(deadline: .now()+3){
//            if !IAPManager.shared.isPremium() {
//                let vc = PayWallViewController()
//                self.present(vc, animated: true, completion: nil)
//            }
//        }
        
//        view.addSubview(createButton)
        
//        self.tabBarController!.tabBar.backgroundColor = .white
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        createButton.frame = CGRect(x: view.frame.width - 60 - 8, y: (self.tabBarController?.tabBar.height)!, width: 60, height: 60)
    }


}

