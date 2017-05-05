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
        
        addText("黄色的树林里分出两条路，可惜我不能同时去涉足，我在那路口久久伫立，我向着一条路极目望去，直到它消失在丛林深处。但我却选了另外一条路，它荒草萋萋，十分幽寂，显得更诱人、更美丽，虽然在这两条小路上，都很少留下旅人的足迹，虽然那天清晨落叶满地，两条路都未经脚印污染。呵，留下一条路等改日再见！但我知道路径延绵无尽头，恐怕我难以再回返。也许多少年后在某个地方，我将轻声叹息把往事回顾，一片树林里分出两条路，而我选了人迹更少的一条，从此决定了我一生的道路。")
        
        addText("★タクシー代がなかったので、家まで歩いて帰った。★もし事故が発生した场所、このレバーを引いて列车を止めてください。（丁）为了清楚地表示出一个短语或句节，其后须标逗号。如：★この薬を、夜寝る前に一度、朝起きてからもう一度、饮んでください。★私は、空を飞ぶ鸟のように、自由に生きて行きたいと思った。*****为了清楚地表示词语与词语间的关系，须标逗号。标注位置不同，有时会使句子的意思发生变化。如：★その人は大きな音にびっくりして、横から飞び出した子供にぶつかった。★その人は、大きな音にびっくりして横から飞び出した子供に、ぶつかった。")
        
        addText("Two roads diverged in a yellow wood, And sorry I could not travel both And be one traveler, long I stood And looked down one as far as I could To where it bent in the undergrowth; Then took the other, as just as fair, And having perhaps the better claim, Because it was grassy and wanted wear; Though as for that the passing there Had worn them really about the same, And both that morning equally lay In leaves no step had trodden black. Oh, I kept the first for another day! Yet knowing how way leads on to way, I doubted if I should ever come back. I shall be telling this with a sigh Somewhere ages and ages hence: Two roads diverged in a wood, and I- I took the one less traveled by, And that has made all the difference.")
        
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
        let str = "第" + "\(section)" + "区"
        btn.setTitle(str, for: .normal)
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
        cell?.textLabel?.text = "这是第" + "\(indexPath.row)" + "行"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            dataType0[indexPath.row].isContraction = !dataType0[indexPath.row].isContraction
            let cell = tableView.cellForRow(at: indexPath) as! ShowtextModelCell
            cell.updateWithNewCellHeight(tableView, ShowText: dataType0[indexPath.row], animated: true)
            
            return
        }
        alert("坏淫好想你")
    }
    
    
}
