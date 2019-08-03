//
//  ViewController.swift
//  TripToBankbook
//
//  Created by 박지은 on 24/07/2019.
//  Copyright © 2019 박지은. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, MTMapViewDelegate {

    var mapView: MTMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mapView = MTMapView(frame: self.view.bounds)
        
        if let mapView = mapView{
            mapView.delegate = self
            mapView.baseMapType = .standard
            self.view.addSubview(mapView)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        var items = [MTMapPOIItem]()
        items.append(poiItem(name: "하나", latitude: 37.4981688, longitude: 127.0484572))
        items.append(poiItem(name: "둘", latitude: 37.4987963, longitude: 127.0415946))
        items.append(poiItem(name: "셋", latitude: 37.5025612, longitude: 127.0415946))
        items.append(poiItem(name: "넷", latitude: 37.5037539, longitude: 127.0426469))
        //위 부분은 viewDidLoad()에서 수행해도 괜찮습니다
        
        mapView?.addPOIItems(items)
   
        mapView?.fitAreaToShowAllPOIItems()  // 모든 마커가 보이게 카메라 위치/줌 조정
        //var lines = MTMapPolyline()
        
        // lines.addPoints(polyLine(map: [[37.4,127.03],[37.5,127.04]]))
        //mapView?.addPolyline(lines)
        
        //mapView?.fitAreaToShowAllPolylines()
    }
    func poiItem(name: String, latitude: Double, longitude: Double) -> MTMapPOIItem {
        let item = MTMapPOIItem()
        item.itemName = name
        item.markerType = .redPin
        item.markerSelectedType = .redPin
        item.mapPoint = MTMapPoint(geoCoord: .init(latitude: latitude, longitude: longitude))
        item.showAnimationType = .noAnimation
        item.customImageAnchorPointOffset = .init(offsetX: 30, offsetY: 0)    // 마커 위치조정
        
        return item
    }
    /*
    MTMapPolyline * polyline = [MTMapPolyline polyLine];
    polyline.tag = 2000;
    polyline.lineColor = [UIColor colorWithRed:0.0f green:0.0f blue:1.0f alpha:0.8f];
    [polyline addPoints:[NSArray arrayWithObjects:
    [MTMapPoint mapPointWithWCONG:MTMapPointPlainMake(475334.0,1101210.0)],
    [MTMapPoint mapPointWithWCONG:MTMapPointPlainMake(474300.0,1104123.0)],
    ...
    [MTMapPoint mapPointWithWCONG:MTMapPointPlainMake(485016.0,1118034.0)],
    nil]];
    [_mapView addPolyline:polyline];
    [_mapView fitMapViewAreaToShowPolyline:polyline];*/
    
    func polyLine(map: [MTMapPoint] ) -> MTMapPolyline{
        let line = MTMapPolyline()
        for arr in map{
            print(arr)
           // line.mapPointList[arr] = MTMapPoint(wcong: .init(latitude: map[arr][0], longitude: map[arr][1]))
        }
        line.tag = 2000
        line.polylineColor = .red
        
        return line
    }


}

