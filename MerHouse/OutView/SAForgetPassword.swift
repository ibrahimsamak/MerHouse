//
//  SAForgetPassword.swift
//  Rasmah
//
//  Created by ibrahim M. samak on 12/9/17.
//  Copyright © 2017 ibrahim M. samak. All rights reserved.
//

import UIKit
import TextFieldEffects

class SAForgetPassword: UIViewController {

    @IBOutlet weak var txtEmail: HoshiTextField!
    var entries : NSDictionary!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        title = "FORGET PASSWORD".localized
        
        
        
        if(Language.currentLanguage().contains("ar"))
        {
            txtEmail.textAlignment = .right
            //self.btn.setImage(#imageLiteral(resourceName: "Back ChevronAr"), for: .normal)
        }
        else{
            txtEmail.textAlignment = .left
            //self.btn.setImage(#imageLiteral(resourceName: "Back Chevron"), for: .normal)
        }
    }

    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnForget(_ sender: Any)
    {
        if MyTools.tools.connectedToNetwork() {
            if !MyTools.tools.validateEmail(candidate: txtEmail.text!) || txtEmail.text?.characters.count==0{
                MyTools.tools.showErrorAlert(title: "Error".localized, body: "Please enter a valid email".localized)
            }
            else{
                MyTools.tools.showIndicator(view: self.view)
                MyApi.api.postForgetPasswprdWith(email: txtEmail.text!) { (response, err) in
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
                                else
                                {
                                    MyTools.tools.hideIndicator(view: self.view)
                                    
                                    if(Language.currentLanguage().contains("ar"))
                                    {
                                        MyTools.tools.showErrorAlert(title: "Error", body: self.entries["message"] as! String)
                                    }
                                    else
                                    {
                                        MyTools.tools.showErrorAlert(title: "Error", body: self.entries["messageEn"] as! String)
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
}
