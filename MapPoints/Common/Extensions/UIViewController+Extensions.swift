//
//  UIViewController+Extensions.swift
//  MapPoints
//
//  Created by Artem on 28.12.2019.
//  Copyright © 2019 Artem. All rights reserved.
//

import UIKit
import Lottie

// Animation extensions
extension UIViewController {
    
    // MARK: - Properties
    private struct AssociatedKeys {
        static var kAnimationDoneView = "key_animationView"
        static var kAnimationLoaderView = "key_animationLoaderView"
        static var kAnimationSearchEmptyView = "key_animationSearchEmptyView"
    }
    
    // MARK: - Associated Keys
    
    private var animationDoneView: AnimationView {
        get {
            guard let view = objc_getAssociatedObject(self, &AssociatedKeys.kAnimationDoneView) as? AnimationView else {
                return initAnimationView()
            }
            
            return view
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.kAnimationDoneView, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    private var animationLoaderView: AnimationView {
        get {
            guard let view = objc_getAssociatedObject(self, &AssociatedKeys.kAnimationLoaderView) as? AnimationView else {
                return initAnimationLoaderView()
            }
            
            return view
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.kAnimationLoaderView, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    private var animationSearchEmptyView: AnimationView {
        get {
            guard let view = objc_getAssociatedObject(self, &AssociatedKeys.kAnimationSearchEmptyView) as? AnimationView else {
                return initAnimationSearchEmptyView()
            }
            
            return view
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.kAnimationSearchEmptyView, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    // MARK: - Init's
    
    func initAnimationView() -> AnimationView {
        let animationView = AnimationView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        let animation: Animation? = Animation.named(animationCheckDone)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .playOnce
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.animationSpeed = 0.5
        animationView.backgroundColor = .clear
        
        view.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        animationView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0.0).isActive = true
        animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0.0).isActive = true
        
        self.animationDoneView = animationView
        
        return animationView
    }
    
    func initAnimationLoaderView() -> AnimationView {
        let animationView = AnimationView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        let animation: Animation? = Animation.named(animationLoadingGoogle)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.animationSpeed = 1.0
        animationView.backgroundColor = .clear
        
        view.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        animationView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0.0).isActive = true
        animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0.0).isActive = true
        
        self.animationLoaderView = animationView
        
        return animationView
    }
    
    func initAnimationSearchEmptyView() -> AnimationView {
        let animationView = AnimationView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        let animation: Animation? = Animation.named(animationSearchEmpty)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.animationSpeed = 1.5
        animationView.backgroundColor = .clear
        
        view.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        animationView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0.0).isActive = true
        animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0.0).isActive = true
        
        let label =  UILabel.init(frame: CGRect(x: 0, y: 200, width: 200, height: 30))
        label.textAlignment = .center
        label.text = "No points."
        animationView.addSubview(label)
        animationView.clipsToBounds = false
        
        self.animationSearchEmptyView = animationView
        
        
        
        return animationView
    }
    
    // MARK: - Animations show / hide
    
    func showAnimatedDone() {
        animationDoneView.currentProgress = 0.0
        animationDoneView.isHidden = false
        
        animationDoneView.play { [weak self] (_) in
            self?.hideAnimatedDone()
        }
        
        if #available(iOS 13.0, *) {
            UIApplication.shared.windows.first?.isUserInteractionEnabled = false
        } else {
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
        
    }
    
    func hideAnimatedDone() {
        animationDoneView.stop()
        animationDoneView.isHidden = true
        
        if #available(iOS 13.0, *) {
            UIApplication.shared.windows.first?.isUserInteractionEnabled = true
        } else {
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    func showAnimatedLoader() {
        animationLoaderView.currentProgress = 0.0
        animationLoaderView.isHidden = false
        
        animationLoaderView.play()
        
        if #available(iOS 13.0, *) {
            UIApplication.shared.windows.first?.isUserInteractionEnabled = false
        } else {
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
        
    }
    
    func hideAnimatedLoader() {
        animationLoaderView.stop()
        animationLoaderView.isHidden = true
        
        if #available(iOS 13.0, *) {
            UIApplication.shared.windows.first?.isUserInteractionEnabled = true
        } else {
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    func showAnimatedSearchEmpty() {
        animationSearchEmptyView.currentProgress = 0.0
        animationSearchEmptyView.isHidden = false
        animationSearchEmptyView.play()
    }
    
    func hideAnimatedSearchEmpty() {
        animationSearchEmptyView.stop()
        animationSearchEmptyView.isHidden = true
    }
    
}
