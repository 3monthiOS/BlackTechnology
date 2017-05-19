//
//  TableviewCoustom.swift
//  App
//
//  Created by 红军张 on 2017/5/3.
//  Copyright © 2017年 IndependentRegiment. All rights reserved.
//

import UIKit

class TableviewCoustom: APPviewcontroller {

    fileprivate var table : UITableView!
    var dataType0 = [ShowTextModel]()
    fileprivate var TypeArray = [false,true] //区头个数 bool 代表了是否收缩
    fileprivate var RowArray = [6,6] // 每个区的行数
    fileprivate var sectionFirstLoad : Bool = false // 第一次不加载 table
    
    override func setup() {
        super.setup()
        self.title = "TableView动画展示"
        table = UITableView(frame: CGRect(x: 0, y: 0, width: App_width, height: App_height - 64), style: .plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.sectionHeaderHeight = 44
        contentView?.addSubview(table)
        ShowText()
        RowArray[0] = dataType0.count
        // DispatchQueue delay.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            self.sectionFirstLoad = true
            self.table.insertSections(IndexSet(integersIn: NSMakeRange(0, self.TypeArray.count).toRange()!), with: .fade)
        })
    }
    

    func ShowText(){
        func addText(_ string : String) {
            let model = ShowTextModel(string)
            dataType0.append(model)
        }
        
        addText("AFNetworking is a delightful networking library for iOS and Mac OS X. It's built on top of the Foundation URL Loading System, extending the powerful high-level networking abstractions built into Cocoa. It has a modular architecture with well-designed, feature-rich APIs that are a joy to use. Perhaps the most important feature of all, however, is the amazing community of developers who use and contribute to AFNetworking every day. AFNetworking powers some of the most popular and critically-acclaimed apps on the iPhone, iPad, and Mac. Choose AFNetworking for your next project, or migrate over your existing projects—you'll be happy you did!")
        
        addText("★タクシー代がなかったので、家まで歩いて帰った。★もし事故が発生した场所、このレバーを引いて列车を止めてください。（丁）为了清楚地表示出一个短语或句节，其后须标逗号。如：★この薬を、夜寝る前に一度、朝起きてからもう一度、饮んでください。★私は、空を飞ぶ鸟のように、自由に生きて行きたいと思った。*****为了清楚地表示词语与词语间的关系，须标逗号。标注位置不同，有时会使句子的意思发生变化。如：★その人は大きな音にびっくりして、横から飞び出した子供にぶつかった。★その人は、大きな音にびっくりして横から飞び出した子供に、ぶつかった。")
    }
    func panGesture(section :UIButton){
        if !TypeArray[section.tag] {
            var indexPaths = [IndexPath]()
            let index      = RowArray[section.tag]
            for i in 0 ..< index {
                indexPaths.append(IndexPath(item: i, section: section.tag))
            }
            TypeArray[section.tag] = true
            table.deleteRows(at: indexPaths, with: .fade)
        }else{
            TypeArray[section.tag] = false
            var indexPaths = [IndexPath]()
            let index      = RowArray[section.tag]
            for i in 0 ..< index {
                indexPaths.append(IndexPath(item: i, section: section.tag))
            }
            self.table.insertRows(at: indexPaths, with: .fade)
        }
    }
    
    

    
    // MARK: Overwrite system methods.
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        enableInteractivePopGestureRecognizer = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        enableInteractivePopGestureRecognizer = true
    }
}
extension TableviewCoustom : UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionFirstLoad ? TypeArray.count : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionFirstLoad ? !TypeArray[section] ? RowArray[section] : 0 : 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            if dataType0.count > 0 {
                if dataType0[indexPath.row].isContraction{
                    return dataType0[0].normalStringHeight!
                }
                return dataType0[0].expendStringHeight!
            }
        }
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 0, y: 0, width: App_width, height: 44)
        btn.tag = section
        let titleArray = ["cell展开收缩动画","其他动画"]
//        let str = "第" + "\(section)" + "区"
        btn.setTitle(titleArray[section], for: .normal)
        btn.backgroundColor = UIColor.gray.alpha(0.6)
        btn.addTarget(self, action: #selector(panGesture(section:)), for: .touchUpInside)
        return btn
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "ShowTextModel") as? ShowtextModelCell
            if cell == nil{
                cell = Bundle.main.loadNibNamed("ShowtextModelCell", owner: nil, options: nil)?.last as? ShowtextModelCell
                cell?.selectionStyle = .none
            }
            if let cell = cell{
                if dataType0.count > 0 {
                    cell.label.text = dataType0[indexPath.row].inputString
                }
            }
            return cell!
        }
        let identifile = "cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifile)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: identifile)
            cell?.selectionStyle = .none
        }
        let titleArray = ["UIScrollView视差效果动画","图片碎片化mask动画","绘制波浪动画"]
        if indexPath.row <= titleArray.count - 1 {
            cell?.textLabel?.text = titleArray[indexPath.row]
        }else{
             cell?.textLabel?.text = "这是第" + "\(indexPath.row)" + "行"
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            dataType0[indexPath.row].isContraction = !dataType0[indexPath.row].isContraction
            let cell = tableView.cellForRow(at: indexPath) as! ShowtextModelCell
            cell.updateWithNewCellHeight(tableView, ShowText: dataType0[indexPath.row], animated: true)
            
            return
        }
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                self.navigationController?.setNavigationBarHidden(true, animated: true)
                let vc = FullTitleVisualEffectViewController()
                self.navigationController?.pushViewController(vc, animated: false)
                return
            case 1:
                self.navigationController?.setNavigationBarHidden(true, animated: true)
                let vc = TransformFadeViewController()
                self.navigationController?.pushViewController(vc, animated: false)
                return
            case 2:
                let vc = wavesAnimationController()
                self.navigationController?.pushViewController(vc, animated: false)
                return
                
            default:
                alert("坏淫好想你😘 (＠。ε。＠)")
            }
        }
        
        alert("坏淫好想你😘 (＠。ε。＠)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
}
