//
//  ProfileViewContrller.swift
//  MapPoints
//
//  Created by Artem on 27.12.2019.
//  Copyright © 2019 Artem. All rights reserved.
//

import UIKit

class ProfileViewContrller: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func googleSignOut(_ sender: Any) {
        MainCoordinator.shared.GSignOut()
    }

}
