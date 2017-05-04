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
    fileprivate var TypeArray = [false,false]
    fileprivate var RowArray = [6,6]
    fileprivate var isContraction = false
    fileprivate var sectionFirstLoad : Bool = false
    
    override func setup() {
        super.setup()
        self.title = "TableView动画展示"
        table = UITableView(frame: CGRect(x: 0, y: 0, width: App_width, height: App_height - 64), style: .plain)
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 44
        table.separatorStyle = .none
        table.sectionHeaderHeight = 44
        contentView?.addSubview(table)

        // DispatchQueue delay.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            
            self.sectionFirstLoad = true
            self.table.insertSections(IndexSet(integersIn: NSMakeRange(0, self.TypeArray.count).toRange()!), with: .fade)
        })

    }
    
    func panGesture(section :UIButton){
        
        if !TypeArray[section.tag] {
            var indexPaths = [IndexPath]()
            let index      = RowArray[section.tag]
            for i in 0 ..< index {
                indexPaths.append(IndexPath(item: i, section: section.tag))
            }
            RowArray[section.tag] = 0
            table.deleteRows(at: indexPaths, with: .fade)
        }else{
            RowArray[section.tag] = 6
            var indexPaths = [IndexPath]()
            let index      = RowArray[section.tag]
            for i in 0 ..< index {
                indexPaths.append(IndexPath(item: i, section: section.tag))
            }
            self.table.insertRows(at: indexPaths, with: .fade)
        }
          TypeArray[section.tag] = !TypeArray[section.tag]
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
        return sectionFirstLoad ? RowArray[section] : 0
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
        let identifile = "cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifile)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: identifile)
        }
        cell?.textLabel?.text = "这是第" + "\(indexPath.row)" + "行"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        alert("坏淫好想你")
    }
    
    
}
