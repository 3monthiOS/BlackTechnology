//
//  IntroViewController.swift
//  App
//
//  Created by 红军张 on 2017/5/23.
//  Copyright © 2017年 IndependentRegiment. All rights reserved.
//

import UIKit
import StarWars

class IntroViewController: UIViewController {
    
    
    
    @IBAction func backToIntroViewContoller(_ segue: UIStoryboardSegue) {
    
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let destination = segue.destination
//        destination.transitioningDelegate = self
    }
}

extension IntroViewController: UIViewControllerTransitioningDelegate {
    
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return StarWarsGLAnimator()
    }
    
}

