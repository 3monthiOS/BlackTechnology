//
//  BaiduMapViewController.swift
//  App
//
//  Created by 红军张 on 16/9/26.
//  Copyright © 2016年 IndependentRegiment. All rights reserved.
//

import UIKit
import Swiften

class BaiduMapViewController: UIViewController, BMKMapViewDelegate {

    var mapView: BMKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView = BMKMapView(frame: self.view.frame)
        self.view = mapView
        mapView.userTrackingMode = BMKUserTrackingModeFollow
        mapView.centerCoordinate = session.location.coordinate
        mapView.zoomLevel = 20
        mapView.showMapScaleBar = true
        mapView.gesturesEnabled = true
        mapView.buildingsEnabled = true
        mapView.trafficEnabled = false //路况图
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        mapView.viewWillAppear()
        mapView.delegate = self  // 此处记得不用的时候需要置nil，否则影响内存的释放
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        mapView.viewWillDisappear()
        mapView.delegate = nil  // 不用时，置nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
