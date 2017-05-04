//
//  GifDetailController.swift
//  App
//
//  Created by 红军张 on 2017/5/3.
//  Copyright © 2017年 IndependentRegiment. All rights reserved.
//

import UIKit
import SwiftyGif

class GifDetailController: APPviewcontroller,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var giftableview: UITableView!
    var imageData :[String]?
    var imageDatas : [UIImage] = []
    let gifManager = SwiftyGifManager(memoryLimit:100)
    
    override func setup() {
        super.setup()
        bindData()
        self.title = "Gif展示"
        if imageData == nil {self.imageData = [""]}
        contentView?.addSubview(giftableview)
    }
    
    func bindData(){
        for (i,imagename) in imageData!.enumerated() {
            async {
                if !(imagename.isEmpty){
                    if let str = imagename.components(separatedBy: "/").last{
                        locationfileiscache(str, complate: { (callback) in
                            if !callback.isEmpty{
                                guard let Data = try? Data(contentsOf: URL(fileURLWithPath: callback)) else {return}
                                self.imageDatas.append(UIImage(gifData: Data, levelOfIntegrity: 1.0))
                                if i + 1 == self.imageData?.count{
                                    self.giftableview.reloadData()
                                }
                            }else{
                                if (imagename.hasPrefix("http://")) || (imagename.hasPrefix("https://")) {
                                    if Reachability.networkStatus != .notReachable {
                                        fileDownload([imagename], complate: { (isok, callbackData) in
                                            if isok{
                                                self.imageDatas.append(UIImage(gifData: callbackData[0], levelOfIntegrity: 1.0))
                                            }
                                            if i + 1 == self.imageData?.count{
                                                self.giftableview.reloadData()
                                            }
                                        })
                                    }
                                }
                            }
                        })
                    }
                }
            }
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - TableView Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = Bundle.main.loadNibNamed("GIFCell", owner: nil, options: nil)?.last as? GIFCell
        }
        if let cell = cell as? GIFCell{
            cell.gifImageView.setGifImage((imageDatas[indexPath.row]), manager: gifManager, loopCount: -1)
        }
        return cell!
    }
    
    // MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let VC = GifViewController()
        VC.gifName = imageDatas[indexPath.row]
        self.navigationController?.pushViewController(VC, animated: true)
    }
}
