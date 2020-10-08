//
//  Material.swift
//  GeniusFinance
//
//  Created by Artem on 6/24/19.
//  Copyright © 2019 Artem. All rights reserved.
//

import UIKit

import MaterialComponents.MaterialDialogs
import MaterialComponents.MaterialTextFields

/// This class contains method and static sizes for custom allerts. All allerts of this class will display in MaterialIO style. They will look and behave like in Android OS.
class Material: NSObject {
//    @property(nonatomic) MDCDialogTransitionController *dialogTransitionController;
    
    /// Previous presented CustomeViewController
    static weak var popViewController : UIViewController?
    static public var popupSize: CGSize? = popupSizeDefault //CGSize(width: 340, height: 380)
    
    static public var popupSizeDefault : CGSize {
        get{
            return CGSize(width: 340, height: 380)
        }
    }
    
    static public var popupSizeTheSmallest : CGSize {
        get{
            return CGSize(width: 340, height: 260)
        }
    }
    
    static public var popupSizeSmaller : CGSize {
        get{
            return CGSize(width: 340, height: 300)
        }
    }
    
    static public var popupSizeSmall : CGSize {
        get{
            return CGSize(width: 340, height: 340)
        }
    }
    
    static public var popupSizeMedium : CGSize {
        get{
            return CGSize(width: 340, height: 380)
        }
    }
    
    static public var popupSizeLarge : CGSize {
        get{
            return CGSize(width: 340, height: 420)
        }
    }
    
    static public var popupSizeLarger : CGSize {
        get{
            return CGSize(width: 340, height: 460)
        }
    }
    
    static public var popupSizeTheLargest : CGSize {
        get{
            return CGSize(width: 340, height: 500)
        }
    }
    
    // MARK: - Snackbar
    
    /// Use this method for notification user about something if message isn't priority.
    ///
    /// - Parameters:
    ///   - message: Message for displaing inside of  snackBar.
    ///   - duration: How long may show snackBar.
    static func showSnackBar(message: String, duration: Double){
        let snackBar = MDCSnackbarMessage()
        snackBar.text = message
        snackBar.duration = duration
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            MDCSnackbarManager.default.show(snackBar)
            
        }// DispatchQueue
    }
    
    static func showSnackBar(message: String, duration: Double, action: MDCSnackbarMessageAction ){
        let snackBar = MDCSnackbarMessage()
        snackBar.text = message
        snackBar.duration = duration
        snackBar.action = action
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            MDCSnackbarManager.default.show(snackBar)
        }// DispatchQueue
    }
    
    // MARK: - Alerts
    
    /// Use this method for display custom alert popup's.
    ///
    /// - Parameters:
    ///   - title: Title will be display in the top of view.
    ///   - message: Message - it's your cussome message.
    static func showMaterialAlert(title: String, message: String){
        guard let rootViewController = Material.getRootViewController() else {
            return
        }
        
        let visibleController = getVisibleViewController(rootViewController)
        
        // Present a modal alert
        let alertController = MDCAlertController(title: title, message: message)
        let action = MDCAlertAction(title:"alert.ok".localized()) { (action) in /*print("alert.ok".localized())*/ }
        alertController.addAction(action)
        
        visibleController?.present(alertController, animated:true, completion:nil)
    }
    
    
    /// Use this method for display custom alert popup's with actions.
    ///
    /// - Parameters:
    ///   - title: Title will be display in the top of view.
    ///   - message: It's your cussome message.
    ///   - buttons: Add array of custom MDCAlertAction for displaing in popup. This may be nil.
    ///   - shouldAddDefaultButton: If it will be true button 'Ok' will be added to end of custom buttons.
    static func showMaterialAlert(title: String, message: String, buttons:[MDCAlertAction], shouldAddDefaultButton: Bool){
        guard let rootViewController = Material.getRootViewController() else {
            return
        }
        
        let visibleController = getVisibleViewController(rootViewController)
        
        // Present a modal alert
        let alertController = MDCAlertController(title: title, message: message)
        buttons.forEach { (action) in
            alertController.addAction(action)
        }
        
        if (shouldAddDefaultButton == true) {
            let action = MDCAlertAction(title:"alert.ok".localized()) { (action) in /*print("alert.ok".localized())*/ }
            alertController.addAction(action)
        }
        
        visibleController?.present(alertController, animated:true, completion:nil)
    }
    
    
    /// Use this method for display custom UIViewController as MaterialIO alert.
    ///
    /// - Parameters:
    ///   - contentViewController: ContentViewController - it maust be your custom UIViewController for displaing inside of alert.
    ///   - animated: Animated if it will true alert will show with animation.
    ///   - authoSize: AuthoSize if it will be true your custom UIViewController will display with minimal indentation to the edges of the screen. For set cusom size to allert, set popupSize before call this method.
    static func showMaterialDialog(contentViewController: UIViewController, animated: Bool, authoSize: Bool){
        
        if(popViewController != nil){
            popViewController?.view.endEditing(false)
            popViewController?.dismiss(animated: false, completion:{
                popViewController = nil
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                popViewController = nil
                self.showMaterialDialog(contentViewController: contentViewController, animated: animated, authoSize: authoSize)
            }
        } else {
            guard let rootViewController = Material.getRootViewController() else {
                return
            }
            
            let visibleController = getVisibleViewController(rootViewController)
            visibleController?.view.endEditing(true)
            
            let dialogTransitionController: MDCDialogTransitionController = MDCDialogTransitionController()
            contentViewController.modalPresentationStyle = UIModalPresentationStyle.custom
            contentViewController.transitioningDelegate = dialogTransitionController
            
            if authoSize == false {
                contentViewController.preferredContentSize = popupSize ?? self.popupSizeDefault
            }
            
            popViewController = contentViewController
            visibleController?.navigationController?.present(contentViewController, animated: animated, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                popupSize = popupSizeDefault
            }   // DispatchQueue.main.asyncAfter
        }   // else
    }
    
    // MARK: - Helpers
    
    static func getRootViewController() -> UIViewController? {
        var rootViewController: UIViewController?
        if #available(iOS 13.0, *) {
            // iOS 13 (or newer) Swift code
            rootViewController = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
        } else {
            // iOS older code
            rootViewController = UIApplication.shared.keyWindow?.rootViewController
        }
        
        return rootViewController
    }
    
    /// Use this method for hidding last displayed Material allert.
    static func hideMaterialPopUp(){
        if popViewController == nil { return }
        popViewController?.view.endEditing(true)
        popViewController?.dismiss(animated: true, completion:{ popViewController = nil })
    }
    
    /// Use this method for getting current visable UIViewController
    ///
    /// - Parameters:
    ///   - rootViewController: RootViewController current root UIViewController.
    /// - Returns: It will return current visable UIViewController of root UIViewController.
    public static func getVisibleViewController(_ rootViewController: UIViewController) -> UIViewController? {
        
        if let presentedViewController = rootViewController.presentedViewController {
            return getVisibleViewController(presentedViewController)
        }
        
        if let navigationController = rootViewController as? UINavigationController {
            return navigationController.visibleViewController
        }
        
        if let tabBarController = rootViewController as? UITabBarController {
            return tabBarController.selectedViewController
        }
        
        return rootViewController
    }
}
