//
//  SACartVC.swift
//  MerHouse
//
//  Created by ibrahim M. samak on 4/3/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import SDWebImage
class SACartVC: UIViewController, UITableViewDelegate  , UITableViewDataSource  {
    @IBOutlet weak var hintView: UIView!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var btl: UITableView!
    @IBOutlet weak var btnAction: UIButton!
    @IBOutlet weak var lblprice: UILabel!
    
    var total = 0.0
    var DataArray = [RCart]()
    var entries : NSDictionary!
    var Tcategory : NSArray = []
    var FilteredArray : NSArray = []
    var elements: NSMutableArray = []
    var pageSize : Int = 10
    var pageIndex : Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "MYCART".localized
        self.loadData()
        self.Total()
        self.btl.dataSource = self
        self.btl.delegate = self
        self.btl.reloadData()
        self.btl.tableFooterView = UIView()
    }
    
    func Total()
    {
        for index in 0..<self.DataArray.count
        {
            self.total = self.total+Double((self.DataArray[index].d_price))*Double((self.DataArray[index].i_amount))
        }
        let totalRoung = String(format: "%.2f", self.total)
        self.lblTotal.text = "Total".localized+" "+totalRoung+" "+"AED".localized
    }
    
    func TotalAfterDelete()
    {
        self.total = 0.0
        for index in 0..<self.DataArray.count
        {
            self.total = self.total+Double((self.DataArray[index].d_price))*Double((self.DataArray[index].i_amount))
        }
        let totalRoung = String(format: "%.2f", self.total)
        self.lblTotal.text = "Total".localized+" "+totalRoung+" "+"AED".localized
    }
    
    func loadData()
    {
        var myId = ""
        if ((UserDefaults.standard.object(forKey: "CurrentUser")) != nil)
        {
            myId = MyTools.tools.getMyId(pk_i_id: "pk_i_id")
        }
        else
        {
            myId =  UIDevice.current.identifierForVendor!.uuidString
        }
        
        self.DataArray = RealmFunctions.shared.GetMyCartItems(s_devicetoken: myId ,s_devicetoken2: "").toArray(ofType: RCart.self)
        if(self.DataArray.count>0)
        {
            self.hintView.isHidden = true
            self.btnAction.isHidden = false
        }
        else
        {
            self.hintView.isHidden = false
            self.btnAction.isHidden = true
        }
        
        self.btl.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.btl.register(UINib(nibName: "CartCell", bundle: nil), forCellReuseIdentifier: "CartCell")
        self.navigationController?.isNavigationBarHidden = false
        self.LoadDeliveryPrice()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.DataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
        cell.stepper.tag = indexPath.row
        cell.stepper.addTarget(self, action: #selector(SACartVC.stepperValueChanged), for: .valueChanged)
        cell.lblTitle.text = self.DataArray[indexPath.row].s_name
        let img = self.DataArray[indexPath.row].s_image as? String ?? ""
        if(img != "")
        {
            cell.img.sd_setImage(with: URL(string:MyApi.PhotoURL+img)!, placeholderImage: UIImage(named: "logo1")!, options: SDWebImageOptions.refreshCached)
        }
        else
        {
            cell.img.image = UIImage(named:"logo1")
        }
        
        cell.stepper.value = Double(self.DataArray[indexPath.row].i_amount)
                cell.btnDelete.tag = indexPath.row
                cell.btnDelete.addTarget(self, action: #selector(DeleteAction(sender:)), for: UIControlEvents.touchUpInside)
        //        cell.lblPrice.text  =  self.DataArray[indexPath.row].s_supplier
        cell.lblPrice.text = String(self.DataArray[indexPath.row].d_price)+" "+"AED".localized
        
        return cell
    }
    
    @objc func DeleteAction(sender:UIButton)
    {
        let index = sender.tag
        let indexpath = IndexPath(row: index, section: 0)
        RealmFunctions.shared.deleteCartItem(pk_i_id: self.DataArray[index].pk_i_id)
        self.DataArray.remove(at: index)
        self.btl.deleteRows(at: [indexpath], with: UITableViewRowAnimation.automatic)
        self.TotalAfterDelete()
        self.loadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 82.0
    }
    
    @IBAction func btnConfirm(_ sender: UIButton)
    {
        //check Time Request
        if((Double(self.total)) >= 50.00 )
        {
            if ((UserDefaults.standard.object(forKey: "CurrentUser")) != nil)
            {
                
                let vc:SAConfirmOrderVC = AppDelegate.storyboard.instanceVC()
                vc.total = String(self.total)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                //CartItem.s_token = UIDevice.current.identifierForVendor!.uuidString
                let vc: ViewController = AppDelegate.storyboard.instanceVC()
                vc.total = String(self.total)
                self.navigationController?.pushViewController(vc, animated: true)
                
                //            let appDelegate = UIApplication.shared.delegate
                //            let vc : rootNavigationViewController = AppDelegate.storyboard.instanceVC()
                //            appDelegate?.window??.rootViewController = vc
                //            appDelegate?.window??.makeKeyAndVisible()
            }
        }
        else
        {
            MyTools.tools.showErrorAlert(title: "Error".localized, body: "Sorry!! The minimum order is 50 AED".localized)
        }
    }
    
    
    @objc func stepperValueChanged(stepper: GMStepper)
    {
        self.total = 0.0
        let index = stepper.tag
        RealmFunctions.shared.UpdateAmmout(pk_i_id: self.DataArray[index].pk_i_id , i_ammount: Int(stepper.value))
        self.loadData()
        
        for index in 0..<self.DataArray.count
        {
            self.total = self.total+Double((self.DataArray[index].d_price))*Double((self.DataArray[index].i_amount))
        }
        let totalRoung = String(format: "%.2f", self.total)
        self.lblTotal.text = "Total".localized+" "+totalRoung+" "+"AED".localized

        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            let index = indexPath.row
            let indexpath = IndexPath(row: index, section: 0)
            RealmFunctions.shared.deleteCartItem(pk_i_id: self.DataArray[index].pk_i_id)
            self.DataArray.remove(at: index)
            self.btl.deleteRows(at: [indexpath], with: UITableViewRowAnimation.automatic)
            self.TotalAfterDelete()
            self.loadData()
        }
    }
    
    
    func LoadDeliveryPrice()
    {
        if MyTools.tools.connectedToNetwork()
        {
            MyTools.tools.showIndicator(view: self.view)
            MyApi.api.GetDelivryPrice() {(response, err) in
                if((err) == nil)
                {
                    if let JSON = response.result.value as? NSDictionary
                    {
                        self.entries = JSON["status"] as? NSDictionary
                        
                        if (self.entries != nil)
                        {
                            MyTools.tools.hideIndicator(view: self.view)
                            let msg = self.entries["message"] as! String
                            self.lblprice.text = "Delivery Charge:".localized+" "+msg+" "+"AED".localized
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
