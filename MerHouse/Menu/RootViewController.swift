//
//  RootViewController.swift
//  Virtual Grocery
//
//  Created by Mostafa on 12/4/17.
//  Copyright © 2017 com. All rights reserved.
//

import UIKit
import AKSideMenu


class RootViewController: AKSideMenu, AKSideMenuDelegate
{
    override public func awakeFromNib()
    {
        super.awakeFromNib()
        
        //let nav = UINavigationController(rootViewController: vc)
        self.contentViewController = self.storyboard!.instantiateViewController(withIdentifier: "contentViewController")
      
        if(Language.currentLanguage().contains("ar"))
        {
            self.rightMenuViewController = AppDelegate.storyboard.instantiateViewController(withIdentifier: "MEMenuVC")

        }
        else
        {
            self.leftMenuViewController = AppDelegate.storyboard.instantiateViewController(withIdentifier: "MEMenuVC")
        }
            
        self.panGestureLeftEnabled = false
        self.panGestureRightEnabled = false
        self.panGestureEnabled = false
        self.parallaxEnabled = false
        
        self.delegate = self
        
    }
    
    
    override public func viewDidLoad()
    {
        super.viewDidLoad()
    
    }
    
    
}
