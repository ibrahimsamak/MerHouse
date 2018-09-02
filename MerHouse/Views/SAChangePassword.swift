//
//  SACHANGE PASSWORD.swift
//  MerHouse
//
//  Created by ibrahim M. samak on 4/7/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import TextFieldEffects

class SAChangePassword:  UIViewController  {
    
    
    @IBOutlet weak var txtPassword: HoshiTextField!
    @IBOutlet weak var txtConfirmPassword: HoshiTextField!
    
    var result : Int!
    var msg : String!
    var isProvider = true
    var entries : NSDictionary!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        title = "CHANGE PASSWORD".localized
        
        
        
        if(Language.currentLanguage().contains("ar"))
        {
            txtPassword.textAlignment = .right
            txtConfirmPassword.textAlignment = .right
        }
        else{
            txtPassword.textAlignment = .left
            txtConfirmPassword.textAlignment = .left
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnSend(_ sender: Any)
    {
        if (txtPassword.text?.characters.count)! == 0
        {
            MyTools.tools.showErrorAlert(title: "Error".localized, body: "Please Enter Password".localized)
        }
        else if  (txtPassword.text! != txtConfirmPassword.text!)
        {
            MyTools.tools.showErrorAlert(title: "Error".localized, body: "Password didn't match".localized)
        }
        else
        {
            MyTools.tools.showIndicator(view: self.view)
            let id = MyTools.tools.getMyId(pk_i_id: "pk_i_id")
            MyApi.api.PostCHANGEPASSWORD(pk_i_id: id, NewPassword: txtPassword.text!)
            {(response, err) in
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
                                MyTools.tools.hideIndicator(view: self.view)
                                MyTools.tools.showSuccessAlert(title: "Success".localized, body: self.entries["messageEn"] as! String)
                                
                                if(Language.currentLanguage().contains("ar"))
                                {
                                    MyTools.tools.showSuccessAlert(title: "Success".localized, body: self.entries["message"] as! String)
                                }
                                else
                                {
                                    MyTools.tools.showSuccessAlert(title: "Success".localized, body: self.entries["messageEn"] as! String)
                                }
                            }
                            else
                            {
                                MyTools.tools.hideIndicator(view: self.view)

                                if(Language.currentLanguage().contains("ar"))
                                {
                                    MyTools.tools.showErrorAlert(title: "Error".localized, body: self.entries["message"] as! String)
                                }
                                else
                                {
                                    MyTools.tools.showErrorAlert(title: "Error".localized, body: self.entries["messageEn"] as! String)
                                }
                            }
                        }
                        else
                        {
                            MyTools.tools.hideIndicator(view: self.view)
                            
                            if(Language.currentLanguage().contains("ar"))
                            {
                                MyTools.tools.showErrorAlert(title: "Error".localized, body: self.entries["message"] as! String)
                            }
                            else
                            {
                                MyTools.tools.showErrorAlert(title: "Error".localized, body: self.entries["messageEn"] as! String)
                            }
                        }
                    }
                }
                else
                {
                    MyTools.tools.hideIndicator(view: self.view)
                    if(Language.currentLanguage().contains("ar"))
                    {
                        MyTools.tools.showErrorAlert(title: "Error".localized, body: self.entries["message"] as! String)
                    }
                    else
                    {
                        MyTools.tools.showErrorAlert(title: "Error".localized, body: self.entries["messageEn"] as! String)
                    }
                }
            }
        }
    }
    
    func setNavigationButton()
    {
        let menuIcon = UIImageView(image: #imageLiteral(resourceName: "menu"))
        menuIcon.frame = CGRect(x: CGFloat(5), y: CGFloat(0), width: CGFloat(20), height: CGFloat(20))
        let menuBtn = UIButton(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(25), height: CGFloat(20)))
        menuBtn.addSubview(menuIcon)
        
        if(Language.currentLanguage().contains("ar"))
        {
            menuBtn.addTarget(self, action: #selector(presentRightMenuViewController(_:)), for: .touchUpInside)
            
        }
        else
        {
            menuBtn.addTarget(self, action: #selector(presentLeftMenuViewController(_:)), for: .touchUpInside)
        }

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: menuBtn)
        //self.navigationItem.setRightBarButtonItems([UIBarButtonItem(customView: menuBtn)], animated: true)
        
        let basket = UIImageView(image:#imageLiteral(resourceName: "shopping-cart"))
        basket.frame = CGRect(x: CGFloat(5), y: CGFloat(0), width: CGFloat(20), height: CGFloat(20))
        let basketButton = UIButton(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(25), height: CGFloat(20)))
        basketButton.addSubview(basket)
        //  basketButton.backgroundColor = UIColor.white
        basketButton.addTarget(self, action: #selector(self.Cart(_:)), for: .touchUpInside)
        self.navigationItem.setRightBarButtonItems([UIBarButtonItem(customView: basketButton)], animated: true)
    }
    
    @objc func Cart(_ sender: UIButton)
    {
        let vc:SACartVC = AppDelegate.storyboard.instanceVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


