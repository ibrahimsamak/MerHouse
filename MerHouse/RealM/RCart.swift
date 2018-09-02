//
//  RUser.swift
//  ADDY
//
//  Created by ibrahim M. samak on 4/13/17.
//  Copyright © 2017 RamezAdnan. All rights reserved.
//

import Foundation
import RealmSwift

class RCart: Object
{
    @objc dynamic var pk_i_id : String = ""
    @objc dynamic var seller_id : Int = 0
    @objc dynamic var s_token : String = ""
    @objc dynamic var s_name : String = ""
    @objc dynamic var s_desc : String = ""
    @objc dynamic var s_image : String = ""
    @objc dynamic var d_price : Float = 0.0
    @objc dynamic var d_total : Float = 0.0
    @objc dynamic var s_supplier : String = ""
    @objc dynamic var i_amount : Int = 0
    @objc dynamic var f_rate : Double = 0.0
    @objc dynamic var s_type : String = ""
    @objc dynamic var d_weight : String = ""

    override class func primaryKey() -> String?
    {
        return "pk_i_id"
    }
    
}
