//
//  PointTableViewCell.swift
//  MapPoints
//
//  Created by Artem on 02.01.2020.
//  Copyright © 2020 Artem. All rights reserved.
//

import UIKit
import Lottie

class PointTableViewCell: UITableViewCell {
    
    static let kPointTableViewCell = "PointTableViewCell"

    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var lat: UILabel!
    @IBOutlet weak var long: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupAppearances()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        name.text = nil
        lat.text = nil
        long.text = nil
        
        animationView.stop()
        animationView.currentProgress = 0.0
        animationView.play()
    }

    
    func setupAppearances() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        let animation: Animation? = Animation.named(animationLocation)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.animationSpeed = 1.0
        animationView.backgroundColor = .clear
        animationView.play()
    }
}
