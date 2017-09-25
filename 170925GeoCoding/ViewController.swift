//
//  ViewController.swift
//  170925GeoCoding
//
//  Created by D7702_09 on 2017. 9. 25..
//  Copyright © 2017년 lyw. All rights reserved.
//

import UIKit
import MapKit
class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var myMapView: MKMapView!
    var lat: Double?
    var long: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locateToCenter()
        myMapView.delegate = self
        //// pList data 가져오기
        //번들-아이폰의 파일 시스템 main 기본
        let path = Bundle.main.path(forResource: "pinList", ofType: "plist")
        print("path = \(String(describing: path))")
        //NSArray -컬렉션 타입 배열안에 타입이 무엇이든지 들어가는것 다양한 내용의 객체를 담을수있다
        //딕셔너리
        //any타입을 사용하기위해 as anyobject를 적용
        let contents = NSArray(contentsOfFile: path!)
        //객체라서 스트링으로 캐스탱 해줘야함
        print("contents = \(String(describing: contents))")
        
        // pin point를 저장하기 위한 배열 선언 - 일반 array선언
        var annotations = [MKPointAnnotation]()
        
        if let myItems = contents {
            for item in myItems {
                //점 찍어서 나오려면 as anyobject 해줘야함
                let title = (item as AnyObject).value(forKey: "title")
                let address = (item as AnyObject).value(forKey: "address")
                
                let geoCoder2: CLGeocoder = CLGeocoder()
                geoCoder2.geocodeAddressString(address as! String, completionHandler: {
                    (placemarks, error) -> Void in
                    
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    if let myPlacemarks = placemarks {
                        let myPlacemark = myPlacemarks[0]
                        
                        print("placemark[0] = \(String(describing: myPlacemark.name))")
                        
                        let annotation = MKPointAnnotation()
                        annotation.title = title as? String
                        annotation.subtitle = address as? String
                        
                        if let myLocation = myPlacemark.location {
                            annotation.coordinate = myLocation.coordinate
                            annotations.append(annotation)
                        }
                        
                    }
                    print("annotations = \(annotations)")
                    self.myMapView.showAnnotations(annotations, animated: true)
                    self.myMapView.addAnnotations(annotations)
                })
                
            }
        }else{
            print("contents 는 nil!")
        }
        
        
    }
    func locateToCenter() {
        let center = CLLocationCoordinate2DMake(35.166197, 129.072594)
        //반경
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let resion = MKCoordinateRegionMake(center, span)
        myMapView.setRegion(resion, animated: true)
    }
    
    


}

