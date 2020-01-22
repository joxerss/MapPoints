//
//  AppDelegate+Extensions.swift
//  MapPoints
//
//  Created by Artem on 27.12.2019.
//  Copyright © 2019 Artem. All rights reserved.
//

import Foundation
import Firebase
import GoogleSignIn
import GoogleMaps

extension AppDelegate: GIDSignInDelegate {
    
    func configurateFirebase() {
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GMSServices.provideAPIKey("AIzaSyAaR1d8kS9np4SK0BKUDApyE8cyFiPlkbY")
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
      -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let error = error {
            
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        let firebaseAuth = Auth.auth()
        firebaseAuth.signIn(with: credential) { (authResult, error) in
            if let error = error {
                
                return
            }
            // User is signed in
            // ...
            MainCoordinator.shared.GSignIn()
        }
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        
        
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
    
}
