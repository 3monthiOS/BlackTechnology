//
//  SecondViewController.swift
//  App
//
//  Created by 红军张 on 2016/12/16.
//  Copyright © 2016年 IndependentRegiment. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    override func viewWillAppear(animated: Bool) {
//        viewWillAppear(animated)
        self.view.backgroundColor = rgb(arc4random()%100,arc4random()%202,arc4random()%150)
        Log.info(arc4random()%100)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
