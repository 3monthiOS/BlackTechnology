////
////  BaiduMapViewController.swift
////  App
////
////  Created by 红军张 on 16/9/26.
////  Copyright © 2016年 IndependentRegiment. All rights reserved.
////
//
//import UIKit
////import Swiften
//
//class BaiduMapViewController: UIViewController, BMKMapViewDelegate {
//
//    var mapView: BMKMapView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        mapView = BMKMapView(frame: self.view.frame)
//        self.view = mapView
//        mapView.userTrackingMode = BMKUserTrackingModeFollow
//        mapView.centerCoordinate = session.location.coordinate
//        mapView.zoomLevel = 20
//        mapView.showMapScaleBar = true
//        mapView.gesturesEnabled = true
//        mapView.isBuildingsEnabled = true
//        mapView.isTrafficEnabled = false //路况图
//        CreateSpreadSubutton()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        mapView.viewWillAppear()
//        mapView.delegate = self  // 此处记得不用的时候需要置nil，否则影响内存的释放
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        mapView.viewWillDisappear()
//        mapView.delegate = nil  // 不用时，置nil
//    }
//    
//    /**
//     创建侧边BTN
//     */
//    func CreateSpreadSubutton(){
//        let spreadButton = SpreadButton(image: UIImage(named: "powerButton"),
//                                        highlightImage: UIImage(named: "powerButton_highlight"),
//                                        position: CGPoint(x: 40, y: App_height - 154))
//        let btn1 = SpreadSubButton(backgroundImage: UIImage(named: "clock"),
//                                   highlightImage: UIImage(named: "clock_highlight")) { (index, sender) -> Void in
//                                    print("first button be clicked!!!")
//        }
//        
//        let btn2 = SpreadSubButton(backgroundImage: UIImage(named: "pencil"),
//                                   highlightImage: UIImage(named: "pencil_highlight")) { (index, sender) -> Void in
//                                    print("second button be clicked!!!")
//        }
//        spreadButton?.setSubButtons([nil,btn1, btn2, nil])
//        spreadButton?.mode = SpreadMode.spreadModeSickleSpread
//        spreadButton?.direction = SpreadDirection.spreadDirectionRightUp
//        spreadButton?.positionMode = SpreadPositionMode.spreadPositionModeFixed
//        
//        /*  and you can assign a newValue to change the default
//         spreadButton?.animationDuring = 0.2
//         spreadButton?.animationDuringClose = 0.25
//         spreadButton?.radius = 180
//         spreadButton?.coverAlpha = 0.3
//         spreadButton?.coverColor = UIColor.yellowColor()
//         spreadButton?.touchBorderMargin = 10.0
//         */
//        spreadButton?.buttonWillSpreadBlock = { print(" 111111 \($0.frame.maxY)") }
//        spreadButton?.buttonDidSpreadBlock = { _ in print("222222did spread") }
//        spreadButton?.buttonWillCloseBlock = { _ in print("333333333 will closed") }
//        spreadButton?.buttonDidCloseBlock = { _ in print("444444444  did closed") }
//        
//        if spreadButton != nil {
//            mapView?.addSubview(spreadButton!)
//        }
//    }
//
//}
