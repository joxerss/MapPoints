//
//  CrationPointViewController.swift
//  MapPoints
//
//  Created by Artem on 03.01.2020.
//  Copyright © 2020 Artem. All rights reserved.
//

import UIKit

class CreationPointViewController: UIViewController {

    @IBOutlet weak var locationName: UITextField!
    var point: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationName.resignFirstResponder()
    }
    
    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createAction(_ sender: Any) {
        guard let `point` = point, let name = locationName.text,
            locationName.text != " " else {
            return
        }
        
        let location = Location.init(name: name, location: point)
        FirebaseDatastore.shared.addPoint(json: location.toJson())
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
