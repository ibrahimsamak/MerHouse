//
//  SARegister.swift
//  Rasmah
//
//  Created by ibrahim M. samak on 12/9/17.
//  Copyright © 2017 ibrahim M. samak. All rights reserved.
//

import UIKit
import TextFieldEffects
import Firebase

class SARegister: UIViewController {
    
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var txtConfirmPassword: HoshiTextField!
    @IBOutlet weak var txtPassword: HoshiTextField!
    @IBOutlet weak var txtEmail: HoshiTextField!
    @IBOutlet weak var txtName: HoshiTextField!
    var entries : NSDictionary!
    var total = ""

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if(Language.currentLanguage().contains("ar"))
        {
            txtConfirmPassword.textAlignment = .right
            txtPassword.textAlignment = .right
            txtEmail.textAlignment = .right
            txtName.textAlignment = .right
            self.btn.setImage(#imageLiteral(resourceName: "Back ChevronAr"), for: .normal)

        }
        else
        {
            txtConfirmPassword.textAlignment = .left
            txtPassword.textAlignment = .left
            txtEmail.textAlignment = .left
            txtName.textAlignment = .left
            self.btn.setImage(#imageLiteral(resourceName: "Back Chevron"), for: .normal)
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func btnRegister(_ sender: Any)
    {
        if MyTools.tools.connectedToNetwork()
        {
            if !MyTools.tools.validateEmail(candidate: txtEmail.text!) || txtEmail.text?.characters.count==0
            {
                MyTools.tools.showErrorAlert(title: "Error".localized, body: "Please enter a valid email".localized)
            }
            else if (txtPassword.text?.characters.count)! == 0
            {
                MyTools.tools.showErrorAlert(title: "Error".localized, body: "Please enter your password".localized)
            }
            else if (txtName.text?.characters.count)! == 0
            {
                MyTools.tools.showErrorAlert(title: "Error".localized, body: "Please enter Your Name".localized)
            }
            else
            {
                MyTools.tools.showIndicator(view: self.view)
                var deviceToken = MyTools.tools.getDeviceToken()
                if deviceToken == nil
                {
                    deviceToken = InstanceID.instanceID().token()!
                }
                
                MyApi.api.PostNewUserWith(s_name: txtName.text!,s_email:txtEmail.text!,s_password: txtPassword.text!, s_devicetoken: deviceToken!) { (response, err) in
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
                                    let UserArray = JSON["TObject"] as? NSArray
                                    let firstUser = UserArray?.firstObject as? NSDictionary
                                    MyTools.tools.hideIndicator(view: self.view)
                             
                                    
                                    if(Language.currentLanguage().contains("ar"))
                                    {
                                        MyTools.tools.showSuccessAlert(title: "Success".localized, body: self.entries["message"] as! String)
                                    }
                                    else
                                    {
                                        MyTools.tools.showSuccessAlert(title: "Success".localized, body: self.entries["messageEn"] as! String)
                                    }
                                    
                                    
                                    let ns = UserDefaults.standard
                                  
                                    let CurrentUser:NSDictionary =
                                        [
                                            "s_email":firstUser?.value(forKey: "s_email") as! String , "pk_i_id":firstUser?.value(forKey: "pk_i_id") as! NSNumber, "s_name":firstUser?.value(forKey: "s_name") as! String ,
                                            "s_image": firstUser?.value(forKey: "s_image") as? String ?? ""  ,
                                            "s_name":firstUser?.value(forKey: "s_name") as! String ,
                                            "s_device_token":firstUser?.value(forKey: "s_devicetoken" ) as! String
                                        ]
                                    
                                    ns.setValue(CurrentUser, forKey: "CurrentUser")
                                    ns.synchronize()
                                    
                                    NotificationCenter.default.post(name: NSNotification.Name("UpdateMenuAfterLogin"), object: nil)
                                    let vc : SAConfirmOrderVC = AppDelegate.storyboard.instanceVC()
                                    vc.total = self.total
                                    self.navigationController?.pushViewController(vc, animated: true)
//                                    let appDelegate = UIApplication.shared.delegate
//                                    appDelegate?.window??.rootViewController = vc
//                                    appDelegate?.window??.makeKeyAndVisible()
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
    
    @IBAction func btnClose(_ sender: UIButton) {
     self.navigationController?.pop(animated: true)
    }
}
