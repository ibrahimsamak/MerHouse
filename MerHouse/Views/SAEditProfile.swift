
//
//  SAEditProfile.swift
//  MerHouse
//
//  Created by ibrahim M. samak on 4/7/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import SDWebImage
import TextFieldEffects

class SAEditProfile: UIViewController  , UIActionSheetDelegate ,UIImagePickerControllerDelegate , UINavigationControllerDelegate
{
    
    @IBOutlet weak var txtName: HoshiTextField!
    @IBOutlet weak var btnUpload: UIButton!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var txtEmail: UITextField!
    //    var selectedImage = UIImage()!
    var isChangeImage = false
    var result: Int!
    var type = ""
    var api_Token: String!
    var isProvider = true
    var entries : NSDictionary!
    var Tcategory : NSArray = []
    var btnBarBadge : MJBadgeBarButton!

    
    
    @objc func onBagdeButtonClick()
    {
        print("button Clicked \(self.btnBarBadge.badgeValue)")
        let vc:SACartVC = AppDelegate.storyboard.instanceVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        title="PROFILE".localized

        let s_image = MyTools.tools.getMykey("s_image") 
        let s_name = MyTools.tools.getMykey("s_name")
        let s_email = MyTools.tools.getMykey("s_email")

        if(MyTools.tools.getMykey("s_image") != "")
        {
            let s_image = MyTools.tools.getMykey("s_image")
            img.sd_setImage(with: URL(string:MyApi.PhotoURL+s_image)!, placeholderImage: UIImage(named: "logo1")!, options: SDWebImageOptions.refreshCached)
        }
        else
        {
            img.image = UIImage(named:"logo1")
        }
        
        txtName.text = s_name
        txtEmail.text = s_email
        
        
        if(Language.currentLanguage().contains("ar"))
        {
            txtName.textAlignment = .right
            txtEmail.textAlignment = .right
        }
        else{
            txtName.textAlignment = .left
            txtEmail.textAlignment = .left
        }
    }
    override func viewWillAppear(_ animated: Bool)
    {
        setNavigationButton()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnSave(_ sender: Any)
    {
        if MyTools.tools.connectedToNetwork()
        {
            if (txtName.text?.characters.count==0)
            {
                MyTools.tools.showErrorAlert(title: "Error".localized, body: "Please Enter your username".localized)
            }
            else
            {
                MyTools.tools.showIndicator(view: self.view)
                let id = MyTools.tools.getMyId(pk_i_id: "pk_i_id")
                let imageData:NSData = UIImagePNGRepresentation(self.img.image!)! as NSData
                let strBase64 = imageData.base64EncodedString(options: .init(rawValue: 0))
                let s_img = "data:image/png;base64,"+strBase64
                MyApi.api.putEditProfile(pk_i_id: id, s_image: s_img, s_name: txtName.text! , withImage:self.isChangeImage)
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
                                   
                                    if(Language.currentLanguage().contains("ar"))
                                    {
                                        MyTools.tools.showSuccessAlert(title: "Success".localized, body: self.entries["message"] as! String)
                                    }
                                    else
                                    {
                                        MyTools.tools.showSuccessAlert(title: "Success".localized, body: self.entries["messageEn"] as! String)
                                    }
                                    
                                    let UserArray = JSON["TObject"] as! NSArray
                                    let firstUser = UserArray.firstObject as? NSDictionary
                                    
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
                                    
                                    NotificationCenter.default.post(name: NSNotification.Name("UpdateMenu"), object: nil)
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
    
    @IBAction func btnCHANGEPASSWORD(_ sender: Any)
    {
        let vc :SAChangePassword = AppDelegate.storyboard.instanceVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnUploadAction(_ sender: Any)
    {
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title:"Images".localized, message: "Please select the image source".localized, preferredStyle: .actionSheet)
        
        let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel".localized, style: .cancel) { action -> Void in
            print("الغاء")
        }
        let saveActionButton: UIAlertAction = UIAlertAction(title: "Photo Library".localized, style: .default)
        { action -> Void in
            //Todo Upload image from Library
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
            
            print("مكتبة الصورة")
        }
        let deleteActionButton: UIAlertAction = UIAlertAction(title: "Camera".localized, style: .default)
        { action -> Void in
            //ToDo Upload image From Camera
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = .camera
            self.present(picker, animated: true, completion: nil)
            
            print("Camera")
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        actionSheetControllerIOS8.addAction(saveActionButton)
        actionSheetControllerIOS8.addAction(deleteActionButton)
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad )
        {
            if let currentPopoverpresentioncontroller = actionSheetControllerIOS8.popoverPresentationController {
                actionSheetControllerIOS8.popoverPresentationController?.sourceView = self.view
                actionSheetControllerIOS8.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                actionSheetControllerIOS8.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
                
                self.present(actionSheetControllerIOS8, animated: true, completion: nil)
            }
        }
        else
        {
            self.present(actionSheetControllerIOS8, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let chosenImage = info[UIImagePickerControllerEditedImage]
        picker.dismiss(animated: true)
        {
            self.img!.image = chosenImage as! UIImage?
            self.img.contentMode = .scaleAspectFit
            self.isChangeImage = true
        }
        self.img!.image = chosenImage as! UIImage?
        self.img.contentMode = .scaleAspectFit
        self.isChangeImage = true
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
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
        
        self.btnBarBadge = MJBadgeBarButton()
        self.btnBarBadge.setup(customButton: basketButton)
        self.btnBarBadge.shouldAnimateBadge = true
        self.btnBarBadge.badgeValue = String(RealmFunctions.shared.GetCountofCart())
        self.btnBarBadge.badgeOriginX = 15.0
        self.btnBarBadge.badgeOriginY = 0
        self.btnBarBadge.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = self.btnBarBadge
        
        
        let search = UIImageView(image: #imageLiteral(resourceName: "Search"))
        search.frame = CGRect(x: CGFloat(2), y: CGFloat(0), width: CGFloat(20), height: CGFloat(20))
        let searchButton = UIButton(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(25), height: CGFloat(20)))
        searchButton.addSubview(search)
        searchButton.addTarget(self, action: #selector(self.Search(_:)), for: .touchUpInside)
        
        self.navigationItem.setRightBarButtonItems([self.btnBarBadge , UIBarButtonItem(customView: searchButton)], animated: true)
    }
    
    @objc func Search(_ sender: UIButton)
    {
        let vc:SASearchVC = AppDelegate.storyboard.instanceVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func Cart(_ sender: UIButton)
    {
        let vc:SACartVC = AppDelegate.storyboard.instanceVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


