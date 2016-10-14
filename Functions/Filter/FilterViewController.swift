//
//  FilterViewController.swift
//  App
//
//  Created by XiuXiu on 9/23/16.
//  Copyright © 2016 IndependentRegiment. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {

    @IBOutlet weak var _collection: UICollectionView!

  @IBOutlet weak var baseImgView: UIImageView!
    
    var filters = [String]()
  lazy var originalImage: UIImage = {
    return UIImage(named: "xiong.png")!
  }()
  lazy var context: CIContext = {
    return CIContext(options: nil)
  }()
    override func viewDidLoad() {
        super.viewDidLoad()
     configureImgView()
      showFiltersInConsole()
    }

  private func configureImgView(){
    baseImgView.layer.shadowOpacity = 0.8
    baseImgView.layer.shadowColor = UIColor.blackColor().CGColor
    baseImgView.layer.shadowOffset = CGSize(width: 1, height: 1)
    baseImgView.image = originalImage
  }
  private func autoAdjust(){
    var inputImage = CIImage(image: originalImage)
    let filters = inputImage!.autoAdjustmentFiltersWithOptions(nil)
    for filter: CIFilter in filters {
      filter.setValue(inputImage, forKey: kCIInputImageKey)
      inputImage = filter.outputImage
    }
    let cgImage = context.createCGImage(inputImage!, fromRect: inputImage!.extent)
    baseImgView.image = UIImage(CGImage: cgImage!)
  }
    private func  outputImg(filter: CIFilter){
        let inputImg = CIImage(image: originalImage)
        filter.setValue(inputImg, forKey: kCIInputImageKey)
        let outputImg = filter.outputImage
        guard let _ = outputImg else{ alert("这个滤镜可能需要参数") ;return }
        let outputCGImg = context.createCGImage(outputImg!, fromRect: outputImg!.extent)
        baseImgView.image = UIImage(CGImage: outputCGImg!)
    }
  func showFiltersInConsole() {
    
    let filterNames = CIFilter.filterNamesInCategory(kCICategoryBuiltIn)
    filters = filterNames.filter({$0.containsString("Photo") || $0.containsString("Color") })
    filters.append("CIGaussianBlur")
    print(filterNames.count)
    
    print(filterNames)
    
  }
  @IBAction func autoAdjustClick(sender: UIButton) {
    autoAdjust()
  }
  @IBAction func originalClick(sender: UIButton) {
    baseImgView.image = originalImage
  }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
 // MARK: - UICollectionViewDataSource
extension FilterViewController: UICollectionViewDataSource{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("filter", forIndexPath: indexPath)
        let  filterName = cell.contentView.viewWithTag(10)as! UILabel
        let name = ["CIPhotoEffectInstant":"怀旧",
                    "CIPhotoEffectNoir":"黑白",
                    "CIPhotoEffectTonal":"色调",
                    "CIPhotoEffectTransfer":"岁月",
                    "CIPhotoEffectMono":"单色",
                    "CIPhotoEffectFade":"褪色",
                    "CIPhotoEffectProcess":"冲印",
                    "CIPhotoEffectChrome":"落黄",
                    "CIGaussianBlur":"高斯模糊"]
        let zhen =  filters[indexPath.item]
        if let aa = name[zhen]{
            filterName.text = aa
        }else{
            filterName.text =  zhen
        }
        
        return cell
    }
}
 // MARK: - UICollectionViewDelegate
extension FilterViewController: UICollectionViewDelegate{
    func  collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let name = filters[indexPath.item]
        outputImg(CIFilter(name: name)!)
    }
}

