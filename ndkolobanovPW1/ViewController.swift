//
//  ViewController.swift
//  ndkolobanovPW1
//
//  Created by Никита Колобанов on 9/16/25.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var button: UIButton!
    var isDay: Bool = true;
    @IBOutlet weak var sunView: UIView!
    @IBOutlet weak var groundView: UIView!
    @IBOutlet weak var grassView: UIView!
    @IBOutlet weak var skyView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sunView.layer.cornerRadius = sunView.frame.width / 3
        updateButtonTitle()
    }
    
    // Mark: Button title
    private func updateButtonTitle() {
       let title = isDay ? "/time set night" : "/time set day"
       button.setTitle(title, for: .normal)
       button.setTitle(title, for: .disabled)
    }
    
    
    // Mark: - Private
    private func changeDayNight() {
        let animations = {
            if self.isDay {
                self.sunView.backgroundColor = .systemGray5
                self.skyView.backgroundColor = .systemIndigo
                self.grassView.backgroundColor = UIColor(named: "NightGrass") ?? .systemGreen
                self.groundView.backgroundColor = UIColor(named: "NightGround") ?? .systemBrown
                self.sunView.layer.cornerRadius = self.sunView.bounds.width / 3

            } else {
                self.sunView.backgroundColor = .systemYellow
                self.skyView.backgroundColor = .systemCyan
                self.grassView.backgroundColor = .systemGreen
                self.groundView.backgroundColor = .systemBrown
                self.sunView.layer.cornerRadius = self.sunView.bounds.width / 3
            }
        }

        UIView.animate(withDuration: 3.5, animations: animations) { [weak self] _ in
            self?.isDay.toggle()
            self?.updateButtonTitle()
            self?.button.isEnabled = true
        }
    }
    
    // Makr: - Actions
    @IBAction func buttonWasPressed(_ sender: Any) {
        button.isEnabled = false
        changeDayNight()
    }
    
    

}

