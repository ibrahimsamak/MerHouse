//
//  CustomeView2.swift
//  WifiMart
//
//  Created by ibrahim M. samak on 11/8/17.
//  Copyright © 2017 ibrahim M. samak. All rights reserved.
//

import Foundation
import UIKit

class CustomeView2: UIView
{
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = MyTools.tools.colorWithHexString("ff4d4d").cgColor
    }
}

