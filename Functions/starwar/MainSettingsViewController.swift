//
//  MainSettingsViewController.swift
//  App
//
//  Created by 红军张 on 2017/5/23.
//  Copyright © 2017年 IndependentRegiment. All rights reserved.
//

import UIKit
import StarWars

class MainSettingsViewController: UIViewController{
    
    @IBOutlet fileprivate weak var saveButton: UIButton!
    fileprivate var settingsViewController: SettingsViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let animator = StarWarsGLAnimator()
        animator.duration = 2
        animator.spriteWidth = 8
        transitioningDelegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let settings = segue.destination as? SettingsViewController {
            settingsViewController = settings
           
        }
    }
    
}
extension MainSettingsViewController: UIViewControllerTransitioningDelegate {
    
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return StarWarsGLAnimator()
    }
    
}
