//
//  wavesAnimationController.swift
//  App
//
//  Created by 红军张 on 2017/5/11.
//  Copyright © 2017年 IndependentRegiment. All rights reserved.
//

import UIKit

class wavesAnimationController: UIViewController {

    @IBOutlet weak var waveView: waveViewDrawrect!
    @IBOutlet weak var zhjtable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        waveView.layer.cornerRadius = 0
        //  label.present = 0.01;
        waveView.layer.masksToBounds = true
        //给图层添加一个有色边框
        
        waveView.layer.borderWidth = 2
        
        waveView.layer.borderColor = UIColor(colorLiteralRed: 0.52, green: 0.09, blue: 0.07, alpha: 1.0).cgColor
    }

}
//MARK:------- UITableViewDataSource
extension wavesAnimationController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil{
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = "第\(indexPath.row)行"
        return cell!
    }
}
//MARK:------- UITableViewDelegate
extension wavesAnimationController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {//选中哪一行
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        Log.info("开始滑动\(y)")
        waveView.bigNumber = Double(y)
        waveView.direction = .top
        waveView.setNeedsDisplay()
    }
    
}
