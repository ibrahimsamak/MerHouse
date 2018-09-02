//
//  rootNavigationViewController.swift
//  مجالس
//
//  Created by ibra on 11/24/16.
//  Copyright © 2016 ibra. All rights reserved.
//

import UIKit

class rootNavigationViewController: UINavigationController {
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if #available(iOS 10.0, *)
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.mainRootNav = self
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
