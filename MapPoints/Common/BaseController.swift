//
//  LocalizedController.swift
//  GeniusFinance
//
//  Created by Artem on 6/24/19.
//  Copyright © 2019 Artem. All rights reserved.
//

import UIKit

class BaseController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBar()
        prepareViews()
        setupAppearances()
        localize()
        NotificationCenter.default.addObserver(self, selector: #selector(self.localize), name: .kLanguageChanged, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.removeObservers()
    }

    @objc func localize() -> Void // override for localize
    {}
    
    @objc func setupAppearances() -> Void // override for configurate collor scheme
    {}
    
    @objc func prepareViews() -> Void // override for configurate view schemes at start (show or hide)
    {}
    
    @objc func prepareNavigationBar() -> Void // override for configurate navigation bar schemes at start
    {}
    
    @objc func setupObservers() -> Void // override for configurate observers, use it only together with removeObservers()
    {}
    
    @objc func removeObservers() -> Void // override,  use it only  it together with setupObservers()
    {}
}
