//
//  NMapsViewController.swift
//  FloatingView
//
//  Created by youngjun goo on 2020/04/22.
//  Copyright © 2020 youngjun goo. All rights reserved.
//

import UIKit
import NMapsMap

class NMapsViewController: UIViewController {
    @IBOutlet weak var naverMapView: NMFNaverMapView?
    weak var mapView: NMFMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNaverMapView()
        mapView = naverMapView?.mapView
    }
    
    deinit {
        mapView = nil
    }
    
    private func setUpNaverMapView() {
        naverMapView?.positionMode = .disabled
        naverMapView?.mapView.zoomLevel = 15
        // naverMapView?.showLocationButton = false
        // naverMapView?.showIndoorLevelPicker = true
        // naverMapView?.mapView.mapType = .navi
        // naverMapView?.mapView.moveCamera(NMFCameraUpdate(position: DEFAULT_CAMERA_POSITION))
    }
    
    private func setUpLayout() {
        guard let mapView = naverMapView else { return }
        mapView.frame = self.view.bounds
        // self.view.addSubview(mapView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
