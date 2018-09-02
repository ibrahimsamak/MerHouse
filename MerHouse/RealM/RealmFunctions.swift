
//
//  RealmFunctions.swift
//  ADDY
//
//  Created by ibrahim M. samak on 4/13/17.
//  Copyright © 2017 RamezAdnan. All rights reserved.
//

import Foundation
import RealmSwift

class RealmFunctions
{
    static var shared = RealmFunctions()
    var lists : Results<RCart>!
    var lists2 : Results<RFav>!
    
    // Mark - Delete Cart Item
    func deleteCartItem(pk_i_id:String)
    {
        let object = GetCartItemDetails(pk_i_id: pk_i_id)
        try! uiRealm.write{
            uiRealm.delete(object)
        }
    }
    
    //Mark - Update i_ammount
    func UpdateAmmout(pk_i_id:String,i_ammount:Int)
    {
        let Predicate = NSPredicate(format: "pk_i_id == %@", pk_i_id)
        let user =  uiRealm.objects(RCart.self).filter(Predicate).first!
        try! uiRealm.write
        {
            user.i_amount = i_ammount
        }
    }
    
    // Mark - Get Cart Item Details
    func GetCartItemDetails(pk_i_id:String) -> RCart
    {
        let Predicate = NSPredicate(format: "pk_i_id == %@", pk_i_id)
        return uiRealm.objects(RCart.self).filter(Predicate).first!
    }
    
    func CheckCart(pk_i_id:String) -> Bool
    {
        let Predicate = NSPredicate(format: "pk_i_id == %@", pk_i_id)
        let query = uiRealm.objects(RCart.self).filter(Predicate)
        if(query.count>0)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    
    // Mark - Get Count of Carts
    func GetCountofCart() -> Int
    {
        lists = uiRealm.objects(RCart.self)
        return lists.count
    }
    
    // Mark - Add or Edit Cart user to Realm
    func AddUserToRealm(newCart:RCart)
    {
        try! uiRealm.write{
            uiRealm.add(newCart, update: true)
        }
    }
    
    //Get All Carts Items
    func GetMyCartItems(s_devicetoken:String , s_devicetoken2:String) -> Results<RCart>
    {
//        let Predicate = NSPredicate(format: "s_token == %@ OR s_token == %@ ", s_devicetoken , s_devicetoken2)
        lists = uiRealm.objects(RCart.self)
        return lists
    }
    
    // Mark - Delete All user to Realm
    func deleteAllRealm()
    {
        lists = uiRealm.objects(RCart.self)
        try! uiRealm.write
        {
            uiRealm.delete(lists)
        }
    }
    
    // Mark - Add to favourit
    func AddFavToRealm(newCart:RFav)
    {
        try! uiRealm.write
        {
            uiRealm.add(newCart, update: true)
        }
    }
    
    func GetMyFavItems(s_devicetoken:String,s_devicetoken2:String) -> Results<RFav>
    {
//        let Predicate = NSPredicate(format: "s_token == %@ OR s_token == %@", s_devicetoken,s_devicetoken2)
        lists2 = uiRealm.objects(RFav.self)
        return lists2
    }
    
    func GetCartFavetails(pk_i_id:String) -> RFav
    {
        let Predicate = NSPredicate(format: "pk_i_id == %@", pk_i_id)
        return uiRealm.objects(RFav.self).filter(Predicate).first!
    }
    
    func deleteFavItem(pk_i_id:String)
    {
        let object = GetCartFavetails(pk_i_id: pk_i_id)
        try! uiRealm.write
        {
            uiRealm.delete(object)
        }
    }
}

