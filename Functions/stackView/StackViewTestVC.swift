//
//  StackViewTestVC.swift
//  Swift3.0 demo
//
//  Created by XiuXiu on 2017/6/15.
//  Copyright © 2017年 XiuXiu. All rights reserved.
//

import UIKit

@available(iOS 9.0, *)
class StackViewTestVC: UIViewController {

  let width: CGFloat = UIScreen.main.bounds.width
  let height: CGFloat = UIScreen.main.bounds.height
  
  var stack: UIStackView!
  var table: UITableView!
  var propertys: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
      title = "stackView"
      view.backgroundColor = UIColor.white
      btns()
      initTable()
      initStackView()
      propertys = [".horizontal",".vertical"]
    }

  func initTable() {
    let line1 = UIView(frame: CGRect(x: 0.0, y: 33.5, width: width, height: 0.5))
    let line2 = UIView(frame: CGRect(x: 0.0, y: 334, width: width, height: 0.5))
    line1.backgroundColor = UIColor.black
    line2.backgroundColor = UIColor.black
    view.addSubview(line1)
     view.addSubview(line2)
    table = UITableView(frame: CGRect(x:0.0,y: 34.0 , width:width, height: 300), style: .plain )
    table.dataSource = self
    table.delegate = self
    view.addSubview(table)
    table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
  }
  func initStackView() {
    stack = UIStackView(frame: CGRect(x: 0.0, y: 334.5, width: width, height: height - 334.5 - 64))
    stack.backgroundColor = UIColor.yellow
    stack.axis = .horizontal
//    stack.alignment = .center
    stack.spacing = 10
//    stack.distribution = .fillProportionally
    view.addSubview(stack)
    (0...3).forEach { (i) in
      let label = UILabel()
      let red: CGFloat = CGFloat(arc4random() % 255 + 1) / 255.0
      let green: CGFloat = CGFloat(arc4random() % 255 + 1) / 255
      let blue: CGFloat = CGFloat(arc4random() % 255 + 1) / 255
      label.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
      label.text = String(repeating: "6", count: Int(arc4random() % 6) + 1)
      stack.addArrangedSubview(label)
    }
  }
  
  
  func btns() {
    (0..<3).forEach { (i) in
      let btn = UIButton(type: .custom)
      let space = (width - (80 * 3)) / 4
      btn.center = CGPoint(x: space * CGFloat( i + 1) + 80.0 * ( CGFloat(i) + 0.5), y: 14)
      btn.bounds = CGRect(x: 0,y:0,width: 80,height: 40)
      btn.setTitle(["axis", "distribution","alignment"][i], for: .normal)
      btn.setTitleColor(UIColor.black, for: .normal)
      btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
      btn.tag = i + 10
      btn.addTarget(self, action: #selector(changeProperty(_:)), for: .touchUpInside)
      view.addSubview(btn)
    }
  }
  func changeProperty(_ btn: UIButton) {
    switch btn.tag {
    case 10:
      propertys = [".horizontal",".vertical"]
    case 11:
      propertys = [".fill",".fillEqually",".fillProportionally",".equalSpacing",".equalCentering"]
    case 12:
      propertys = [".fill",".leading / .top",".firstBaseline",".center",".trailing / .bottom",".lastBaseline"]
    default:
      break
    }
    table.reloadData()
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
@available(iOS 9.0, *)
extension StackViewTestVC: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   return propertys.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.text = propertys[indexPath.row]
    return cell
  }
}
@available(iOS 9.0, *)
extension StackViewTestVC: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch propertys.count {
    case 2:
      stack.axis = UILayoutConstraintAxis(rawValue: indexPath.row)!
    case 5:
      stack.distribution = UIStackViewDistribution(rawValue: indexPath.row)!
    case 6:
      stack.alignment = UIStackViewAlignment(rawValue: indexPath.row)!
    default:
      break
    }
  }
}

