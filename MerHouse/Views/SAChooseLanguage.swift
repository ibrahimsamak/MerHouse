//
//  SAChooseLanguage.swift
//  MerHouse
//
//  Created by ibrahim M. samak on 5/30/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class SAChooseLanguage: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "SETTINGS".localized
        setNavigationButton()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnArabic(_ sender: UIButton)
    {
        Language.setAppLanguage(lang: "ar")
        UIView.appearance().semanticContentAttribute = .forceRightToLeft
        self.rootnavigationController()
    }
    
    
    @IBAction func btnEn(_ sender: Any)
    {
        Language.setAppLanguage(lang: "en-US")
        UIView.appearance().semanticContentAttribute = .forceLeftToRight
        self.rootnavigationController()
    }
    
    func rootnavigationController()
    {
        guard let window = UIApplication.shared.keyWindow else {return}
        let vc : RootViewController = AppDelegate.storyboard.instanceVC()
        window.rootViewController = vc
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
    }
    
}
