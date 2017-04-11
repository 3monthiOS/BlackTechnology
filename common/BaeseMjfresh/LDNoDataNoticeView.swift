//
//  LDNoDataNoticeView.swift
//  grapefruit
//
//  Created by Cator Vee on 3/17/16.
//  Copyright © 2016 Ledong. All rights reserved.
//

import Foundation

class LDNoDataNoticeView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageYOffset: NSLayoutConstraint!
    
    static func viewWithTitle(_ title: String, frame: CGRect, imageYOffset: CGFloat = 100,KindS: Int) -> LDNoDataNoticeView {
        let view = Bundle.main.loadNibNamed("LDNoDataNoticeView", owner: nil, options: nil)![KindS] as! LDNoDataNoticeView
        view.frame = frame
        view.titleLabel.text = title
        view.tag = 12545
        view.imageYOffset.constant = imageYOffset
        view.layoutIfNeeded()
        return view
    }
    @IBAction func JumpCotroller(_ sender: AnyObject) {
//        if let _ = Utils.getUser() {
//            let storyboard = UIStoryboard(name: "AhaAlbumEditer", bundle: NSBundle.mainBundle())
//            let controller = storyboard.instantiateViewControllerWithIdentifier("LDNewQdanViewController")
//            UIViewController.showViewController(controller, animated: true)
//        }else{
//            let userStoryBoard = UIStoryboard(name: "User", bundle: nil)
//            let userLoingViewCtrl = userStoryBoard.instantiateViewControllerWithIdentifier("UserLoginNavController")
//            
//            userLoingViewCtrl.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
//            UIViewController.topViewController?.presentViewController(userLoingViewCtrl, animated: true, completion: nil)
//        }
    }
}
