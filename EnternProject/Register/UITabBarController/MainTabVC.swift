//
//  MainTabVC.swift
//  EnternProject
//
//  Created by Мухтарпаша on 31.05.2020.
//  Copyright © 2020 Magomed Inc. All rights reserved.
//

import UIKit
import Firebase
class MainTabVC: UITabBarController, UITabBarControllerDelegate {
    
    
    
    
    //MARK:ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        //цвет шрифта
        tabBar.tintColor = .black
        
        self.delegate = self
            
        

        
        let feed = createNavController(viewController: TableViewController(), title: "Feed ", selectedImage: #imageLiteral(resourceName: "home_selected"), unselectedImagee: #imageLiteral(resourceName: "home_unselected"))
        
        let search = createNavController(viewController: TablController(), title: "Search", selectedImage: #imageLiteral(resourceName: "search_selected"), unselectedImagee: #imageLiteral(resourceName: "search_selected"))
        

        viewControllers = [feed,search]
        
        
        ifuserLogedIn()
    }
    
    

    
    fileprivate func ifuserLogedIn() {
        
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let loginVC = LoginViewController()
                let navController = UINavigationController(rootViewController: loginVC)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
            }
            return
        }
    }
    
    
    
    fileprivate func createNavController (viewController: UIViewController, title: String, selectedImage: UIImage, unselectedImagee:UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: viewController)
        //это название бара , который будет снизу
        navController.tabBarItem.title = title
        //название нав бара, который будет сверху
        viewController.navigationItem.title = title
        
        
        navController.tabBarItem.image = unselectedImagee
        navController.tabBarItem.selectedImage = selectedImage
        
        viewController.view.backgroundColor = .white
        
        
        return navController
    }
    
    
    
    

}
