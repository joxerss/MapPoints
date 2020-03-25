//
//  MainCoordinator.swift
//  MapPoints
//
//  Created by Artem on 27.12.2019.
//  Copyright © 2019 Artem. All rights reserved.
//

import UIKit
import GoogleSignIn
import CoreLocation

extension UIViewController {
    static func initContoller(_ storyboard: String, identifier: String) -> UIViewController {
        let storyboard = UIStoryboard.init(name: storyboard, bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: identifier)
        
        return controller
    }
}

class MainCoordinator: NSObject {

    static let shared: MainCoordinator = MainCoordinator()
    
    private var mainTabBarController: UITabBarController?
    
    private override init() {
        super.init()
    }
    
    public func navigateToSignInControoler() {
        setRootViewController(UIViewController.initContoller(UIStoryboard.main, identifier: UINavigationController.signInNavigationController), complition: nil)
    }
    
    func setRootViewController(_ viewController: UIViewController, complition: (()->())? ) -> Void {
        var window: UIWindow? = nil
        if #available(iOS 13.0, *) {
            // iOS 13 (or newer) Swift code
            window = UIApplication.shared.windows.first
        } else {
            // iOS older code
            window = UIApplication.shared.keyWindow
        }
        
        guard let curWindow = window else {
            fatalError("🚀❌ window can't be nil!!")
        }
        
        viewController.modalPresentationStyle = .fullScreen
        curWindow.rootViewController = viewController
        curWindow.makeKeyAndVisible()
        
        UIView.transition(with: curWindow, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: { _ in
            if let complition = complition {
                complition()
            }
        })
    }
    
    func generateWindow(windowScene: UIWindowScene) -> UIWindow {
        mainTabBarController = nil
        
        // Validate on Controller here
        let contentController: UIViewController!
        if (UserManager.shared.isAuthorized) {
            UserManager.shared.restorePreviousGSignIn()
            contentController = UIViewController.initContoller(UIStoryboard.main, identifier: UITabBarController.mainTabBarViewController)
            
            if let tabbar = contentController as? UITabBarController {
                mainTabBarController = tabbar
            }
        } else {
            contentController = UIViewController.initContoller(UIStoryboard.main, identifier: UINavigationController.signInNavigationController)
        }
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = contentController
        window.makeKeyAndVisible()
        return window
    }
    
    func GSignIn() {
        if UserManager.shared.isAuthorized && !UserManager.shared.profileRestoring {
            let contentController = UIViewController.initContoller(UIStoryboard.main, identifier: UITabBarController.mainTabBarViewController)
            setRootViewController(contentController, complition: nil)
            
            if let tabbar = contentController as? UITabBarController {
                mainTabBarController = tabbar
            }
        } else if UserManager.shared.profileRestoring {
            UserManager.shared.profileRestoring = false
        }
    }
    
    func GSignOut() {
        UserManager.shared.googleSignOut()
        if !UserManager.shared.isAuthorized {
            setRootViewController(UIViewController.initContoller(UIStoryboard.main, identifier: UINavigationController.signInNavigationController), complition: nil)
            mainTabBarController = nil
        }
    }
    
    func navigateToMapPoint(_ location: Location) {
        guard let tabBarController = mainTabBarController as? MainTabBarViewController else {
            return
        }
        
        var selectIndex = 0
        tabBarController.viewControllers?.forEach({ (controller) in
            if let nav = controller as? UINavigationController,
                let vc = nav.viewControllers.first as? MapViewController {
                vc.loadViewIfNeeded()
                tabBarController.selectedIndex = selectIndex
                vc.scrollToLocation(location)
                return
            }
            selectIndex += 1
        })
    }
    
    func presentCrationPoint(in controller: UIViewController, point: CLLocationCoordinate2D) {
        let contentController = UIViewController.initContoller(UIStoryboard.main, identifier: UIViewController.creationPointViewController) as! CreationPointViewController
        contentController.loadViewIfNeeded()
        
        contentController.modalPresentationStyle = .custom
        contentController.modalTransitionStyle = .crossDissolve
        
        contentController.point = point
        controller.present(contentController, animated: true, completion: nil)
        
    }
}
