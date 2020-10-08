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
import GooglePlaces

extension AppDelegate: GIDSignInDelegate {
    
    func configurateFirebase() {
        // Use Firebase library to configure APIs
        GMSServices.provideAPIKey("AIzaSyAaR1d8kS9np4SK0BKUDApyE8cyFiPlkbY")
        GMSPlacesClient.provideAPIKey("AIzaSyAaR1d8kS9np4SK0BKUDApyE8cyFiPlkbY")
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
      -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if error != nil {
            print("❌ Google didSignInFor error:\(error!.localizedDescription)")
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        let firebaseAuth = Auth.auth()
        firebaseAuth.signIn(with: credential) { (authResult, error) in
            if error != nil {
                
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
