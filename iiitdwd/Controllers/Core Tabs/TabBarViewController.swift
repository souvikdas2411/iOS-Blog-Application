//
//  TabBarViewController.swift
//  iiitdwd
//
//  Created by Souvik Das on 21/10/21.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpControllers()
    }
    

    private func setUpControllers() {
        guard let currentUserEmail = UserDefaults.standard.string(forKey: "email") else {
            return
        }
        let home = ViewController()
        home.title = "Home"
        let profile = ProfileViewController(currentEmail: currentUserEmail)
        profile.title = "Profile"
        
        home.navigationItem.largeTitleDisplayMode = .always
        profile.navigationItem.largeTitleDisplayMode = .always
        
        let nav1 = UINavigationController(rootViewController: home)
        let nav2 = UINavigationController(rootViewController: profile)
        
        nav1.navigationBar.prefersLargeTitles = true
        nav2.navigationBar.prefersLargeTitles = true
        
        nav1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle.fill"), tag: 2)
        
        tabBar.backgroundColor = .white
        tabBar.tintColor = .systemPink
//        tabBar.layer.opacity = 0.8
        
        
        
        setViewControllers([nav1, nav2], animated: true)
    }

}
