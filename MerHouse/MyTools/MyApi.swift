//
//  MyApi.swift
//  مجالس
//
//  Created by ibra on 10/12/16.
//  Copyright © 2016 ibra. All rights reserved.
//

import Foundation
import Alamofire

class MyApi
{
    static public var apiMainURL = "http://merhousemarket.com/api/" as String
    static public var PhotoURL = "http://merhousemarket.com/img/" as String
    
    static let api = MyApi()

    func putEditProfile(pk_i_id:String , s_image:String , s_name: String , withImage:Bool , completion:((DataResponse<Any>,Error?)->Void)!)
    {
        if(withImage)
        {
            Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"TUsers?pk_i_id="+pk_i_id), method: .post, parameters:["s_name":s_name , "s_image" :s_image],encoding: JSONEncoding.default).responseJSON { response in
                if(response.result.isSuccess)
                {
                    completion(response,nil)
                }
                else
                {
                    completion(response,response.result.error)
                }
            }
        }
        else
        {
            Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"TUsers?pk_i_id="+pk_i_id), method: .post, parameters:["s_name":s_name],encoding: JSONEncoding.default).responseJSON { response in
                if(response.result.isSuccess)
                {
                    completion(response,nil)
                }
                else
                {
                    completion(response,response.result.error)
                }
            }
        }
    }
    
    func RefreshDeviceTokenWith(pk_i_id:Int , DeviceToken:String ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"TUsers?pk_i_id="+String(pk_i_id)+"&s_notification_id="+DeviceToken+"&Device_os=IOS"), method: .post,encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func GetDelivryPrice(completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"TCarts"), method: .get,encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
        
    }
    
    func GetCategoriesForUser(completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"TCategories"), method: .get,encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
        
    }
    
    func GetSubCategory(fk_category_id:Int,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"TCategories?fk_category_id="+String(fk_category_id)), method: .get,encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
        
    }
    
    func GetOrders(fk_user_id:Int,PageSize: Int , PageIndex: Int ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"TOrders?fk_user_id="+String(fk_user_id)+"&pageSize="+String(PageSize)+"&pageIndex="+String(PageIndex)), method: .get,encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func GetOrderDetails(fk_order_id:Int ,fk_user_id:Int ,PageSize: Int , PageIndex: Int ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"TCarts?fk_order_id="+String(fk_order_id)+"&pageSize="+String(PageSize)+"&pageIndex="+String(PageIndex)+"&fk_user_id="+String(fk_user_id)), method: .get,encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    func GetNotifications(to_user_id:Int,PageSize: Int , PageIndex: Int ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"TNotifications?to_user_id="+String(to_user_id)+"&pageSize="+String(PageSize)+"&pageIndex="+String(PageIndex)), method: .get,encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func CheckOnlineOffline(completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"TCarts"), method: .post,encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    func GetProductsBySearch(s_name:String,PageSize: Int , PageIndex: Int ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"TProducts?s_name="+String(s_name)+"&pageSize="+String(PageSize)+"&pageIndex="+String(PageIndex)), method: .get,encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func GetProductsByMinCategoryId(fk_Category_id:Int,PageSize: Int , PageIndex: Int ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"TProducts?fk_main_Category_id="+String(fk_Category_id)+"&pageSize="+String(PageSize)+"&pageIndex="+String(PageIndex)), method: .get,encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    func GetProductsByCategoryId(fk_Category_id:Int,PageSize: Int , PageIndex: Int ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"TProducts?fk_Category_id="+String(fk_Category_id)+"&pageSize="+String(PageSize)+"&pageIndex="+String(PageIndex)), method: .get,encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    func GethomeVcForClient(completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"getCatItems"), method: .get,encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func GetDeliveryInfo(completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request("http://mnbayt.tenderssite.com/mnbaytgit/Api/GetDeliveryAbout.php", method: .get,encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func GetStaticPage(completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request("http://mnbayt.tenderssite.com/mnbaytgit/Api/GetAboutApp.php", method: .get,encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    
    func GetServiceProfile(pk_i_id:Int,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"getSeller?id="+String(pk_i_id)), method: .get,encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func GetProviderProfile(pk_i_id:Int,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"getSeller?id="+String(pk_i_id)), method: .get,encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    func showAService(pk_i_id:Int,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"showAService?id="+String(pk_i_id)), method: .get,encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    func showAProduct(pk_i_id:Int,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"showAProduct?id="+String(pk_i_id)), method: .get,encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    //http://mnbayt.tenderssite.com/mnbaytgit/public/api/getCatItemsByType?type=product
    func GetServiceCategories(completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"getCatItemsByType?type=service"), method: .get,encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func GetAllCategories(completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"getCatItems"), method: .get,encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    
    func GetItemsBySearch(key:String,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"searchAProducts?name="+key), method: .get,encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    //
    func completeServiceTransaction(token:String , target_id:Int,notes:String , created_by:Int,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"completeServiceTransaction"), method: .post,parameters:["token":token , "target_id":target_id ,"notes":notes , "created_by":created_by ],encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    func SellerRate(token:String , target_type:String , target_id:Int,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"myRating"), method: .post,parameters:["token":token , "target_type":target_type , "target_id":target_id],encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func requestDetails(id:String,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"requestDetails?id="+id), method: .get,encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    func myServiceRequests(token:String,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"myServiceRequests"), method: .post,parameters:["token":token],encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    func sellerRequests(token:String,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"sellerRequests"), method: .post,parameters:["token":token],encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    func buyerRequests(token:String,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"buyerRequests"), method: .post,parameters:["token":token],encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
//
    
    func getSubCatByMainId(category_id:String,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"getSubCatByMainId?cat_id="+category_id), method: .get,encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    func itemsByCategory(category_id:String,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"itemsByCategory?category_id="+category_id), method: .get,encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    func productProviders(completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"productProviders"), method: .get,encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    func myItems(token:String ,type:String , seller_id:Int ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"myItems"),method: .post, parameters:["token":token , "cat_id":type , "seller_id":seller_id], encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func searchByCat(cat_id:Int ,keyword:String ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"searchByCat"),method: .post, parameters:["cat_id":cat_id , "keyword":keyword], encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
 
    
    
    func serviceProviders(completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"serviceProviders"), method: .get,encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func GetItemsByCategoryId(completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"categoryIndex"), method: .get,encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    //apiIndex
    func GetOffers(completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"apiIndex"), method: .get,encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    func GetListOfProductByCategory(category_id:Int,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"productsByCategory?category_id="+String(category_id)), method: .get,encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    //
    func FORGETPASSWORD(email:String,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"sendEmail"),method: .post, parameters:["email":email], encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
  
    
    func ContactUs(name :String,msj:String, email:String , phone:String, completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"contactUs"),method: .post, parameters:["name":name , "msj":msj , "email" : email , "phone":phone], encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    func Login(email:String ,password:String ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"Login"),method: .post, parameters:["email":email, "password":password], encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    func delateClasswork(parameters: [String: AnyObject],completion: (_ success : Bool) -> Void)
    {
        let parameters:[String:AnyObject] =
            ["data" : [parameters] as AnyObject ]
        request("http://waseam.com/wifimarket/public/api/addInvoice", method: .post, parameters: parameters, encoding:JSONEncoding.default).responseJSON
        {
            response in
            switch response.result {
            case .success(let JSON):
                print("suce")
                    break
            case .failure(_):
                print("failure")
                break
            }
        }
    }

    
    func SliderGet(completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"slider"), method: .get,encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    func PostCHANGEPASSWORD(pk_i_id:String ,NewPassword:String,completion:((DataResponse<Any>,Error?)->Void)!){
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"TUsers?pk_i_id="+pk_i_id+"&NewPassword="+NewPassword),method: .post, parameters:["s_password":NewPassword], encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func PostComment(product_id:String ,token:String ,comment:String , rating:String ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"makeACommentToTarget"),method: .post, parameters:["product_id":product_id, "token":token  ,"comment":comment , "rating":rating], encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func PostCart(Carts:Any ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        let hed = ["Content-Type":"application/json","accept":"application/json"]
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"TCarts?api_token=1"),method: .post, parameters:["Carts":Carts], encoding: JSONEncoding.default, headers: hed).responseJSON
            { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
   
    
    func PostNewUserWith(s_name:String ,s_email:String , s_password:String, s_devicetoken:String ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"TUsers?CreateUser=yes"),method: .post, parameters:["s_name":s_name, "s_email":s_email , "s_password" : s_password  ,"s_devicetoken":s_devicetoken , "s_deviceOS":"IOS"], encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    func PostBranchUnderMonitor(pk_i_id:Int ,b_under_monitor:Bool ,rate:Int  ,empId:Int,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"TBranches?pk_i_id="+String(pk_i_id)+"&b_under_monitor="+String(b_under_monitor)+"&rate="+String(rate)+"&empId="+String(empId)), method: .post,encoding: JSONEncoding.default).responseJSON
            { response in
                if(response.result.isSuccess)
                {
                    completion(response,nil)
                }
                else
                {
                    completion(response,response.result.error)
                }
        }
    }
    
    func UpdateOrderStatusDriver(fk_order_id:String ,fk_status_id:String ,api_token:String  ,fk_driver_id:String,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"TOrders?fk_order_id="+fk_order_id+"&fk_status_id="+fk_status_id+"&api_token="+api_token+"&Driver="), method: .post, parameters:["s_hint":"" , "fk_driver_id":fk_driver_id],encoding: JSONEncoding.default).responseJSON
            { response in
                if(response.result.isSuccess)
                {
                    completion(response,nil)
                }
                else
                {
                    completion(response,response.result.error)
                }
        }
    }
    
    func AddOrder(fk_user_id:Int,d_lat:Double , d_long:Double , s_details:String, d_total:Double, s_jawwal:String ,s_street:String ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"TOrders?fk_user_id="+String(fk_user_id)+"&api_token=1"), method: .post, parameters:["fk_user_id":fk_user_id ,"d_lat":d_lat,"d_long":d_long, "s_details":s_details,"d_total":d_total ,"s_jawwal":s_jawwal, "s_street":s_street   ],encoding: JSONEncoding.default).responseJSON
            { response in
                if(response.result.isSuccess)
                {
                    completion(response,nil)
                }
                else
                {
                    completion(response,response.result.error)
                }
        }
    }
    func UpdateOrderStatus(fk_order_id:String ,fk_status_id:String ,api_token:String ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"TOrders?fk_order_id="+fk_order_id+"&fk_status_id="+fk_status_id+"&api_token="+api_token), method: .post, parameters:["s_hint":""],encoding: JSONEncoding.default).responseJSON
            { response in
                if(response.result.isSuccess)
                {
                    completion(response,nil)
                }
                else
                {
                    completion(response,response.result.error)
                }
        }
    }
    
    func postLoginWith(s_email:String , s_password:String, s_devicetoken:String ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"TUsers"), method: .post, parameters:["s_email":s_email , "s_password": s_password , "s_devicetoken": s_devicetoken , "s_deviceOS" : "IOS"],encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    func postForgetPasswprdWith(email:String , completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"TUsers?Froget_Password=yes"), method: .post, parameters:["s_email":email],encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    func PostLogout(pk_i_id:String , completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"TResturants?pk_i_id="+pk_i_id+"&logout=true"), method: .post,encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    func PostLogoutDriver(pk_i_id:String , completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"TDrivers?pk_i_id="+pk_i_id+"&logout=true"), method: .post,encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    
    
    
    func GetOrderDetails(fk_order_id:Int,PageSize: Int , PageIndex: Int ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"TCarts?fk_order_id="+String(fk_order_id)+"&pageSize="+String(PageSize)+"&pageIndex="+String(PageIndex)), method: .get,encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    //TOrders?fk_status_id={fk_status_id}&newreq={newreq}
    func GetOrdersWaitingAcceptOrRejectByDrvvers2(fk_status_id:Int ,fk_resturant_id:Int  ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"TOrders?fk_status_id="+String(fk_status_id)+"&fk_resturant_id="+String(fk_resturant_id)+"&newreq="), method: .get,encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    func GetOrdersWaitingAcceptOrRejectByDrvvers(fk_status_id:Int ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"TOrders?fk_status_id="+String(fk_status_id)+"&newreq="), method: .get,encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
    
    func GetOrdersByResturant(fk_status_id:Int, fk_resturant_id :Int ,PageSize: Int , PageIndex: Int ,completion:((DataResponse<Any>,Error?)->Void)!)
    {
        Alamofire.request(String(format:"%@%@",MyApi.apiMainURL,"TOrders?fk_status_id="+String(fk_status_id)+"&fk_resturant_id="+String(fk_resturant_id)+"&pageSize="+String(PageSize)+"&pageIndex="+String(PageIndex)), method: .get,encoding: JSONEncoding.default).responseJSON { response in
            if(response.result.isSuccess)
            {
                completion(response,nil)
            }
            else
            {
                completion(response,response.result.error)
            }
        }
    }
}
