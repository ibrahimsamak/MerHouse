//
//  SAProductDetailsVC.swift
//  MerHouse
//
//  Created by ibrahim M. samak on 4/3/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import SDWebImage

class SAProductDetailsVC: UIViewController {

    @IBOutlet weak var visaView: UIView!
    @IBOutlet weak var cashView: UIView!
    @IBOutlet weak var stack: UIView!
    @IBOutlet weak var viewCoent: UIView!
    @IBOutlet weak var ing: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var stepper: GMStepper!
    
    var s_image = ""
    var s_name = ""
    var s_desc = ""
    var price:Float = 0.0
    var Pk_i_id =  0
    var Qty = 1
    var weight = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.viewCoent.layer.borderWidth = 1
        //self.viewCoent.layer.borderColor = MyTools.tools.colorWithHexString("DFDFDF").cgColor
        
        self.stack.layer.borderWidth = 1
        self.stack.layer.borderColor = MyTools.tools.colorWithHexString("DFDFDF").cgColor
        lblTitle.text = s_name
        lblWeight.text  = weight
        lblDesc.text = s_desc.html2String
        lblPrice.text = String(self.price)+" "+"AED".localized
        ing.sd_setImage(with: URL(string:MyApi.PhotoURL+self.s_image)!, placeholderImage: UIImage(named: "logo1")!, options: SDWebImageOptions.refreshCached)
        
        
        if(Language.currentLanguage().contains("ar")){
            lblDesc.textAlignment = .right

        }
        else{
            lblDesc.textAlignment = .left
        }
        
        
        
        stepper.addTarget(self, action: #selector(SACartVC.stepperValueChanged), for: .valueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func btnFAv(_ sender: UIButton)
    {
        //UIDevice.current.identifierForVendor!.uuidString
        let CartItem = RFav()
        CartItem.d_price = Float(self.price)
        CartItem.d_total = (Float(self.Qty)*Float(self.price))
        CartItem.f_rate = 1.0
        CartItem.i_amount = Int(self.Qty)
        CartItem.s_image = self.s_image
        CartItem.d_weight = self.weight

        if ((UserDefaults.standard.object(forKey: "CurrentUser")) != nil)
        {
            CartItem.s_token = MyTools.tools.getMyId(pk_i_id: "pk_i_id")
        }
        else
        {
            CartItem.s_token = UIDevice.current.identifierForVendor!.uuidString
        }
        CartItem.pk_i_id = String(self.Pk_i_id)
        CartItem.s_name = lblTitle.text!
        CartItem.s_desc = lblDesc.text!
        
        RealmFunctions.shared.AddFavToRealm(newCart: CartItem)
        MyTools.tools.showSuccessAlert(title: "Success".localized, body: "Added to Favorite Successfully".localized)
    }
    
    @IBAction func btnClose(_ sender: UIButton)
    {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnAddToCart(_ sender: UIButton)
    {
        let CartItem = RCart()
        CartItem.d_price = Float(self.price)
        CartItem.d_total = (Float(self.Qty)*Float(self.price))
        CartItem.f_rate = 1.0
        CartItem.i_amount = Int(self.Qty)
        CartItem.s_image = self.s_image
        CartItem.d_weight = self.weight

        if ((UserDefaults.standard.object(forKey: "CurrentUser")) != nil)
        {
            CartItem.s_token = MyTools.tools.getMyId(pk_i_id: "pk_i_id")
        }
        else
        {
            CartItem.s_token = UIDevice.current.identifierForVendor!.uuidString
        }
        CartItem.pk_i_id = String(self.Pk_i_id)
        CartItem.s_name = lblTitle.text!
        CartItem.s_desc = lblDesc.text!
        
        RealmFunctions.shared.AddUserToRealm(newCart: CartItem)
        MyTools.tools.showSuccessAlert(title: "Success".localized, body: "Added to Cart Successfully".localized)
    }
    
    @IBAction func btnDoneOrder(_ sender: UIButton)
    {
        
        let vc: SACartVC = AppDelegate.storyboard.instanceVC()
        self.parent?.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc func stepperValueChanged(stepper: GMStepper)
    {
       self.Qty = Int(stepper.value)
       print(self.Qty)
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
}

extension SAProductDetailsVC : MIBlurPopupDelegate {
    
    var popupView: UIView {
        return self.view
    }
    
    var blurEffectStyle: UIBlurEffectStyle {
        return .dark
    }
    
    var initialScaleAmmount: CGFloat {
        return 3
    }
    
    var animationDuration: TimeInterval {
        return 0.5
    }
    
}

