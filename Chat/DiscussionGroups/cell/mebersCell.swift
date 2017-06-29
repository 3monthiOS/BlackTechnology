//
//  mebersCell.swift
//  App
//
//  Created by 红军张 on 2017/6/29.
//  Copyright © 2017年 IndependentRegiment. All rights reserved.
//

import UIKit

enum TableViewTapAnimationCellState : Int {
    
    case kNormalState, kSelectedState
}
class mebersCell: UITableViewCell {
    
    @IBOutlet weak var TXimage: UIImageView!
    @IBOutlet weak var biankuang: UIView!
    @IBOutlet weak var selectimage: UIImageView!
    @IBOutlet weak var name: UILabel!
    fileprivate var lineView   : UIView!
    var userData: User?
    var cellselectet = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        biankuang.layer.masksToBounds = true
        biankuang.layer.borderWidth = 1
        biankuang.layer.borderColor = UIColor.gray.cgColor
        
        let nametitle = ["张三","李四","王五","小二","二狗子"]
        name.font      = UIFont.Avenir(20)
        name.textColor = UIColor.gray
        name.text = nametitle[Int(arc4random()%4)]
        
        lineView                 = UIView(frame: CGRect(x: 30, y: 42, width: 0, height: 2))
        lineView.alpha           = 0
        lineView.backgroundColor = UIColor.red
        self.addSubview(lineView)
        
    }

    func loadContent(data: User,selectet: Bool) {
        userData = data
        if selectet{
            changeToState(.kSelectedState, animated: false)
        } else {
            changeToState(.kNormalState, animated: false)
        }
    }

    func selectedEvent() {
        cellselectet = !cellselectet
        showSelectedAnimation()
        
        if cellselectet {
            changeToState(.kSelectedState, animated: true)
        } else {
            changeToState(.kNormalState, animated: true)
        }
    }
    
    // MARK: Private func.
    
    fileprivate func changeToState(_ state : TableViewTapAnimationCellState, animated : Bool) {
        
        switch state {
            
        case .kNormalState:
            
            UIView.animate(withDuration: animated == false ? 0 : 0.5, delay: 0, usingSpringWithDamping: 7, initialSpringVelocity: 4, options: UIViewAnimationOptions(), animations: {
                
                if animated == true {
                    
                    self.selectimage.transform = CGAffineTransform(a: 0.5, b: 0, c: 0, d: 0.5, tx: 0, ty: 0)
                }
                
                self.selectimage.alpha   = 0
                self.lineView.alpha   = 0
                self.lineView.frame   = CGRect(x: 30, y: 42, width: 0, height: 2)
                
                self.biankuang.layer.borderColor  = UIColor.gray.cgColor
                self.biankuang.transform          = CGAffineTransform(a: 1, b: 0, c: 0, d: 1, tx: 0, ty: 0)
                self.biankuang.layer.cornerRadius = 0
                
            }, completion: nil)
            
        case .kSelectedState:
            
            if animated == true {
                
                self.selectimage.transform = CGAffineTransform(a: 2, b: 0, c: 0, d: 2, tx: 0, ty: 0)
            }
            
            UIView.animate(withDuration: animated == false ? 0 : 0.5, delay: 0, usingSpringWithDamping: 7, initialSpringVelocity: 4, options: UIViewAnimationOptions(), animations: {
                
                self.selectimage.transform = CGAffineTransform(a: 1, b: 0, c: 0, d: 1, tx: 0, ty: 0)
                self.selectimage.alpha     = 1
                self.lineView.alpha     = 1
                self.lineView.frame     = CGRect(x: 30, y: 42, width: 200, height: 2)
                
                self.biankuang.layer.borderColor  = UIColor.red.cgColor
                self.biankuang.transform          = CGAffineTransform(a: 0.8, b: 0, c: 0, d: 0.8, tx: 0, ty: 0)
                self.biankuang.layer.cornerRadius = 4
                
            }, completion: nil)
        }
    }
    
    fileprivate func showSelectedAnimation() {
        
        let tempView             = UIView(frame: CGRect(x: 0, y: 0, width: Width(), height: 43))
        tempView.backgroundColor = UIColor.cyan.alpha(0.2)
        tempView.alpha           = 0
        self.addSubview(tempView)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            
            tempView.alpha = 0.8
            
        }) { (finished) in
            
            UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveEaseOut, animations: {
                
                tempView.alpha = 0
                
            }, completion: { (finished) in
                
                tempView.removeFromSuperview()
            })
        }
    }

    
}
