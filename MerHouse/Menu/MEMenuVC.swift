//
//  MEMenuVC.swift
//  MyStory
//
//  Created by Maher on 1/16/18.
//  Copyright © 2018 iosMaher. All rights reserved.
//

import UIKit
import SDWebImage
import AKSideMenu

class MEMenuVC: UIViewController , UITableViewDelegate , UITableViewDataSource
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lbllogout: UILabel!
    @IBOutlet weak var inglogout: UIImageView!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        if Language.currentLanguage().contains("ar") {
            lblName.textAlignment = .right
            lblEmail.textAlignment = .right
        }else {
            lblName.textAlignment = .left
            lblEmail.textAlignment = .left
        }
        
        if ((UserDefaults.standard.object(forKey: "CurrentUser")) != nil)
        {
            let s_image = MyTools.tools.getMykey("s_image")
            let s_name =  MyTools.tools.getMykey("s_name")
            let s_email = MyTools.tools.getMykey("s_email")
            
            
            lblEmail.text = s_email
            lblName.text = s_name
            img.sd_setImage(with: URL(string:MyApi.PhotoURL+s_image)!, placeholderImage: UIImage(named: "logo1")!, options: SDWebImageOptions.refreshCached)
            
            lbllogout.isHidden = false
            inglogout.isHidden = false
            
        }
        else
        {
            lblEmail.text = "MerHouse".localized
            lblName.text = "MerHouse".localized
            img.image = #imageLiteral(resourceName: "logo1")
            lbllogout.isHidden = true
            inglogout.isHidden = true
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(UpdateMenu), name: NSNotification.Name("UpdateMenu"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(UpdateMenuAfterLogin), name: NSNotification.Name("UpdateMenuAfterLogin"), object: nil)
        
//UpdateMenuLanguage
        
        self.tableView.reloadData()
    }
    
    
    @objc func UpdateMenuAfterLogin()
    {
        
        let s_image = MyTools.tools.getMykey("s_image")
        let s_name =  MyTools.tools.getMykey("s_name")
        let s_email = MyTools.tools.getMykey("s_email")
        
        
        lblEmail.text = s_email
        lblName.text = s_name
        img.sd_setImage(with: URL(string:MyApi.PhotoURL+s_image)!, placeholderImage: UIImage(named: "logo1")!, options: SDWebImageOptions.refreshCached)
        
        lbllogout.isHidden = false
        inglogout.isHidden = false
        
        self.tableView.reloadData()
    }
    
    @objc func UpdateMenu()
    {
        let s_image = MyTools.tools.getMykey("s_image")
        let s_name =  MyTools.tools.getMykey("s_name")
        let s_email = MyTools.tools.getMykey("s_email")
        
        
        lblEmail.text = s_email
        lblName.text = s_name
        img.sd_setImage(with: URL(string:MyApi.PhotoURL+s_image)!, placeholderImage: UIImage(named: "logo1")!, options: SDWebImageOptions.refreshCached)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return 5

//        if ((UserDefaults.standard.object(forKey: "CurrentUser")) != nil)
//        {
//            return 5
//        }
//        else
//        {
//        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MEMenuCell", for: indexPath) as! MEMenuCell
        
        if(indexPath.row == 0)
        {
            cell.img.image = UIImage(named: "home icon")
            cell.lblTitle.text = "HOME".localized
        }
        if(indexPath.row == 1)
        {
            cell.img.image = UIImage(named: "star icon")
            cell.lblTitle.text = "FAVORITE".localized
        }
        if(indexPath.row == 2)
        {
            cell.img.image = UIImage(named: "notification icon")
            cell.lblTitle.text = "NOTIFICATIONS".localized
        }
        if(indexPath.row == 3)
        {
            cell.img.image = UIImage(named: "list")
            cell.lblTitle.text = "MY ORDERS".localized
        }
        if(indexPath.row == 4)
        {
            cell.img.image = UIImage(named: "settings icon")
            cell.lblTitle.text = "SETTINGS".localized
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        if(indexPath.row == 0)
        {
            self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "SAMainCategory")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()
        }
        else if(indexPath.row == 1)
        {
            self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "SAFavVC")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()
        }
        else if(indexPath.row == 2)
        {
            self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "SANotificationVC")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()
        }
        else if(indexPath.row == 3)
        {
            self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "SAOrdersVC")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()
        }
        else if(indexPath.row == 4)
        {
            self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "SAChooseLanguage")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()
        }
    }
    
    
    @IBAction func btn_logout(_ sender: UIButton)
    {
        print("logout")
        if ((UserDefaults.standard.object(forKey: "CurrentUser")) != nil)
        { UserDefaults.standard.removeObject(forKey: "CurrentUser")
            let appDelegate = UIApplication.shared.delegate
            let vc : RootViewController = AppDelegate.storyboard.instanceVC()
            appDelegate?.window??.rootViewController = vc
            appDelegate?.window??.makeKeyAndVisible()
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if ((UserDefaults.standard.object(forKey: "CurrentUser")) != nil)
        {
            return 60.0
        }
        else
        {
            if indexPath.row == 2 || indexPath.row == 3
            {
                return 0.0
            }
            else
            {
                return 60.0
            }
        }
    }
    @IBAction func btnEditProfile(_ sender: UIButton)
    {
        if ((UserDefaults.standard.object(forKey: "CurrentUser")) != nil)
        {
            self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "SAEditProfile")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()
        }
    }
    
    //    func PushViewController(_ vc:UIViewController)
    //    {
    //        let nav = UINavigationController(rootViewController: vc)
    //        self.sideMenuViewController!.setContentViewController(nav, animated: true)
    //        self.sideMenuViewController!.hideMenuViewController()
    //    }
}
