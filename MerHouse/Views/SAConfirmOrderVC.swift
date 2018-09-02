//
//  SAConfirmOrderVC.swift
//  MerHouse
//
//  Created by ibrahim M. samak on 4/7/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import GoogleMaps
//import GooglePlaces
import MapKit
import Alamofire

class SAConfirmOrderVC: UIViewController, GMSMapViewDelegate , CLLocationManagerDelegate
{
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        target = nil
        GPS.removeFromSuperview()
        GPS.delegate = nil
        GPS = nil
        AppDelegate.locationManager.delegate = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("error description:\(error.localizedDescription)")
    }
    
    
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtJawwal: UITextField!
    @IBOutlet weak var txtNote: UITextField!
    @IBOutlet weak var GPS: GMSMapView!
    @IBOutlet weak var visaView: UIView!
    @IBOutlet weak var cashView: UIView!
    
    let locationManag = CLLocationManager()
    var Latitude : Double = 0
    var Longitude : Double = 0
    let marker = GMSMarker()
    var target: CLLocationCoordinate2D?
    var DataArray = [RCart]()
    var total = ""
    var long = 0.0
    var lat = 0.0
    var result: Int!
    var entries : NSDictionary!
    var arr:[Any] = []

    func func_initLocation()
    {
        if (CLLocationManager.locationServicesEnabled())
        {
            switch(CLLocationManager.authorizationStatus())
            {
            case .notDetermined, .restricted, .denied:
                AppDelegate.locationManager.requestWhenInUseAuthorization()
                AppDelegate.locationManager.requestAlwaysAuthorization()
                
            case .authorizedAlways, .authorizedWhenInUse:
                AppDelegate.locationManager.delegate = self
                AppDelegate.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
                AppDelegate.locationManager.startUpdatingLocation()
                
                self.Latitude = (AppDelegate.locationManager.location?.coordinate.latitude)!
                self.Longitude = (AppDelegate.locationManager.location?.coordinate.longitude)!
            }
        }
        else
        {
            AppDelegate.locationManager.requestWhenInUseAuthorization()
            AppDelegate.locationManager.requestAlwaysAuthorization()
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false

        self.func_initLocation()
//        MyTools.tools.showInfoAlert(title: "Information", body: "The minimum order is 50 AED and the delivery price is 20 AED")


        GPS.isMyLocationEnabled = true
        GPS.settings.myLocationButton = false
        GPS.settings.zoomGestures = true
        GPS.settings.scrollGestures = true
        GPS.mapType = .normal
        GPS.delegate = self
        
        //        let target = CLLocationCoordinate2D(latitude: self.Latitude, longitude: self.Longitude)
        //        GPS.camera = GMSCameraPosition.camera(withTarget: target, zoom: 12)
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(self.Latitude,self.Longitude)
        let x: Float = Float(CGFloat (GPS.frame.size.width /  2))
        let y: Float = Float(CGFloat(GPS.frame.size.height / 2))
        let markerImg = UIImageView(frame: CGRect(x: CGFloat(x - 20), y: CGFloat(y - 32), width: CGFloat(30), height: CGFloat(30)))
        markerImg.image = UIImage(named: "placeholder-filled-point")
        
        GPS.addSubview(markerImg)
        
        delay(seconds:0.5) { () -> () in
            self.delay(seconds: 0.5, closure: { () -> () in
                let vancouver = CLLocationCoordinate2DMake(self.Latitude,self.Longitude)
                var vancouverCam = GMSCameraUpdate.setTarget(vancouver)
                self.GPS.animate(toLocation: vancouver)
                
                self.delay(seconds: 0.5, closure: { () -> () in
                    let zoomIn = GMSCameraUpdate.zoom(to: 15)
                    self.GPS.animate(with: zoomIn)
                    
                })
            })
        }
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        title = "CONFIRMATION".localized
        loadData()

        self.cashView.backgroundColor = MyTools.tools.colorWithHexString("DFDFDF")
        self.visaView.backgroundColor = UIColor.white
        
        self.CheckOnlineOfline()

        if(Language.currentLanguage().contains("ar"))
        {
            txtNote.textAlignment = .right
            txtJawwal.textAlignment = .right
            txtAddress.textAlignment = .right
        }
        else{
            txtNote.textAlignment = .left
            txtJawwal.textAlignment = .left
            txtAddress.textAlignment = .left
        }
        
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition)
    {
        let coordinate = position.target
        let lat = coordinate.latitude
        let lon = coordinate.longitude
        self.lat = coordinate.latitude
        self.long = coordinate.longitude
        print(lat,lon)
    }
    
    //self.delegate?.sendFilter(InformationID: self.Category , Value:self.Class,addyId: self.addyId)
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func loadData()
    {
        let MyID = MyTools.tools.getMyId(pk_i_id: "pk_i_id")
        let myDeviceUDID = UIDevice.current.identifierForVendor!.uuidString
        self.DataArray = RealmFunctions.shared.GetMyCartItems(s_devicetoken:MyID ,s_devicetoken2:myDeviceUDID).toArray(ofType: RCart.self)
        
    }
    
    @IBAction func btnAdd(_ sender: UIButton)
    {
        if(self.long != 0.0 && self.lat != 0.0)
        {
            var myArray : [NSString] = []
            let MyID = MyTools.tools.getMyId(pk_i_id: "pk_i_id")
            for index in 0..<self.DataArray.count
            {
                arr.append(["i_amount":Int(self.DataArray[index].i_amount),"fk_product_id":Int(self.DataArray[index].pk_i_id)!,"fk_user_id":Int(MyID)!])
            }
            
            if MyTools.tools.connectedToNetwork()
            {
                if  txtAddress.text?.characters.count==0
                {
                    MyTools.tools.showErrorAlert(title: "Error".localized, body: "Please enter your Address".localized)
                    
                }
                else if (txtJawwal.text?.characters.count)! == 0
                {
                    MyTools.tools.showErrorAlert(title: "Error".localized, body: "Please enter your phone number".localized)
                }
                else
                {
                    MyTools.tools.showIndicator(view: self.view)
                    MyApi.api.PostCart(Carts: arr)
                    { (response, err) in
                        if((err) == nil)
                        {
                            if let JSON = response.result.value as? NSDictionary
                            {
                                self.entries = JSON["status"] as? NSDictionary
                                
                                if (self.entries != nil)
                                {
                                    let success = self.entries.value(forKey: "success") as! Bool
                                    if  (success == true)
                                    {
                                        MyApi.api.AddOrder(fk_user_id: Int(MyID)!, d_lat: self.lat, d_long: self.long, s_details: self.txtNote.text!, d_total: Double(self.total)!, s_jawwal: self.txtJawwal.text!, s_street: self.txtAddress.text!)
                                        { (response, err) in
                                            if((err) == nil)
                                            {
                                                if let JSON = response.result.value as? NSDictionary
                                                {
                                                    self.entries = JSON["status"] as? NSDictionary
                                                    
                                                    if (self.entries != nil)
                                                    {
                                                        let success = self.entries.value(forKey: "success") as! Bool
                                                        if  (success == true)
                                                        {
                                                            RealmFunctions.shared.deleteAllRealm()
                                                            MyTools.tools.hideIndicator(view: self.view)
                                                           
                                                            if(Language.currentLanguage().contains("ar"))
                                                            {
                                                                MyTools.tools.showSuccessAlert(title: "Success".localized, body: self.entries["message"] as! String)
                                                            }
                                                            else
                                                            {
                                                                MyTools.tools.showSuccessAlert(title: "Success".localized, body: self.entries["messageEn"] as! String)
                                                            }
                                                            self.navigationController?.popToRoot(animated: true)
                                                        }
                                                        else
                                                        {
                                                            MyTools.tools.hideIndicator(view: self.view)
                                                            if(Language.currentLanguage().contains("ar"))
                                                            {
                                                                MyTools.tools.showSuccessAlert(title: "Success".localized, body: self.entries["message"] as! String)
                                                            }
                                                            else
                                                            {
                                                                MyTools.tools.showSuccessAlert(title: "Success".localized, body: self.entries["messageEn"] as! String)
                                                            }
                                                            
                                                        }
                                                    }
                                                    else{
                                                        MyTools.tools.hideIndicator(view: self.view)
                                                        MyTools.tools.showErrorAlert(title: "Error".localized, body: "An Error occurred".localized)
                                                    }
                                                }
                                                else{
                                                    MyTools.tools.hideIndicator(view: self.view)
                                                    MyTools.tools.showErrorAlert(title: "Error".localized, body: "An Error occurred".localized)
                                                }
                                            }
                                            else{
                                                MyTools.tools.hideIndicator(view: self.view)
                                                MyTools.tools.showErrorAlert(title: "Error".localized, body: "An Error occurred".localized)
                                            }
                                        }
                                    }
                                    else
                                    {
                                        MyTools.tools.hideIndicator(view: self.view)
                                        MyTools.tools.showErrorAlert(title: "Error".localized, body: "An Error occurred".localized)
                                    }
                                }
                                else
                                {
                                    MyTools.tools.hideIndicator(view: self.view)
                                    MyTools.tools.showErrorAlert(title: "Error".localized, body: "An Error occurred".localized)
                                }
                            }
                        }
                        else
                        {
                            MyTools.tools.hideIndicator(view: self.view)
                            MyTools.tools.showErrorAlert(title: "Error".localized, body: "An Error occurred".localized)
                            
                        }
                    }
                }
            }
            else
            {
                MyTools.tools.showErrorAlert(title: "Error".localized, body: "No Internet Connection".localized)
            }
        }
        else
        {
            MyTools.tools.showErrorAlert(title: "Error".localized, body: "Please Turn on your Location".localized)
        }
    }
    
    
    func delay(seconds: Double, closure: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            closure()
        }
    }
    
    @IBAction func btnCredit(_ sender: Any)
    {
        self.visaView.backgroundColor = MyTools.tools.colorWithHexString("DFDFDF")
        self.cashView.backgroundColor = UIColor.white
    }
    
    @IBAction func btnCash(_ sender: Any)
    {
        self.cashView.backgroundColor = MyTools.tools.colorWithHexString("DFDFDF")
        self.visaView.backgroundColor = UIColor.white
    }
    
    
    func CheckOnlineOfline()
    {
        if MyTools.tools.connectedToNetwork()
        {
            MyTools.tools.showIndicator(view: self.view)
            MyApi.api.CheckOnlineOffline(){(response, err) in
                if((err) == nil)
                {
                    if let JSON = response.result.value as? NSDictionary
                    {
                        self.entries = JSON["status"] as? NSDictionary
                        if (self.entries != nil)
                        {
                            let success = self.entries.value(forKey: "success") as! Bool
                            if  (success != true)
                            {
                                MyTools.tools.hideIndicator(view: self.view)
                                
                                if(Language.currentLanguage().contains("ar"))
                                {
                                    MyTools.tools.showInfoAlert(title: "Warning".localized, body: self.entries["message"] as! String)
                                }
                                else
                                {
                                    MyTools.tools.showInfoAlert(title: "Warning".localized, body: self.entries["messageEn"] as! String)
                                }
                            }
                            else
                            {
                                MyTools.tools.hideIndicator(view: self.view)
                            }
                        }
                        else
                        {
                            MyTools.tools.hideIndicator(view: self.view)
                            MyTools.tools.showErrorAlert(title: "Error".localized, body: "An Error occurred".localized)
                        }
                    }
                    else
                    {
                        MyTools.tools.hideIndicator(view: self.view)
                        MyTools.tools.showErrorAlert(title: "Error".localized, body: "An Error occurred".localized)
                    }
                }
                else
                {
                    MyTools.tools.hideIndicator(view: self.view)
                    MyTools.tools.showErrorAlert(title: "Error".localized, body: "An Error occurred".localized)
                }
            }
        }
        else
        {
            MyTools.tools.showErrorAlert(title: "Error".localized, body: "No Internet Connection".localized)
        }
    }
}
