//
//  SignInViewController.swift
//  MapPoints
//
//  Created by Artem on 26.12.2019.
//  Copyright © 2019 Artem. All rights reserved.
//

import UIKit
import Lottie
import GoogleSignIn

class SignInViewController: BaseController {
    
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    @IBOutlet weak var animationView: AnimationView!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Appearances
    
    override func prepareViews() {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        googleSignInButton.colorScheme = .dark
        googleSignInButton.style = .wide
        
        animate()
    }
    
    func animate() {
        let animation: Animation? = Animation.named(animationBuble)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .autoReverse
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.animationSpeed = 1.75
        animationView.play()
    }
    
    override func prepareNavigationBar() {
        navigationController?.navigationBar.largeContentTitle = "signin.welcome".localized()
    }
    
    override func setupAppearances() {
        view.backgroundColor = .firebaseLogoFrontColor
        animationView.backgroundColor = .clear
        googleSignInButton.backgroundColor = .clear
    }
    
    override func localize() {
        
    }
    

}
