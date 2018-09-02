//
//  SAOrderDetails.swift
//  MerHouse
//
//  Created by ibrahim M. samak on 4/6/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import SDWebImage

class SAOrderDetails:  UIViewController  ,UITableViewDelegate  , UITableViewDataSource  {
    
    @IBOutlet weak var tbl: UITableView!
    var entries : NSDictionary!
    var Tcategory : NSArray = []
    var FilteredArray : NSArray = []
    var elements: NSMutableArray = []
    var pageSize : Int = 10
    var pageIndex : Int = 1
    var TPaging : NSDictionary!
    var pk_i_id = 0
    var isNewDataLoading: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tbl.register(UINib(nibName: "OrderDetailsCell", bundle: nil), forCellReuseIdentifier: "OrderDetailsCell")
        
        self.LoadNotifications(pageIndexNo: self.pageIndex)
        self.tbl.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return  self.elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailsCell", for: indexPath) as!  OrderDetailsCell
        let content = self.elements.object(at: indexPath.row) as AnyObject
        let i_amount = content.value(forKey: "i_amount") as! Int
        
      
        
        let TProduct = content.value(forKey: "TProduct") as! NSDictionary
        let s_nameEn = TProduct.value(forKey: "s_nameEn") as! String
        let s_name = TProduct.value(forKey: "s_name") as! String
        let s_image = TProduct.value(forKey: "s_image") as? String ?? ""
        let d_weight = TProduct.value(forKey: "d_weight") as! String

        if let n = TProduct.value(forKey: "Price") as? NSNumber
        {
            let f = n.floatValue
            cell.lblPrice.text = String(f)+" "+"AED".localized
        }
        
        if(Language.currentLanguage().contains("ar")){
            cell.lblTitle.text = s_name
        }
        else{
            cell.lblTitle.text = s_nameEn
        }
        cell.lblweight.text = d_weight
        cell.lblQty.text = "Qty".localized+" "+String(i_amount)
        cell.img.sd_setImage(with: URL(string:MyApi.PhotoURL+s_image)!, placeholderImage: UIImage(named: "logo1")!, options: SDWebImageOptions.refreshCached)

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 82.0
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
        self.navigationItem.setRightBarButtonItems([UIBarButtonItem(customView: basketButton)], animated: true)
    }
    
    @objc func Cart(_ sender: UIButton)
    {
        let vc:SACartVC = AppDelegate.storyboard.instanceVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func LoadNotifications(pageIndexNo:Int)
    {
        if MyTools.tools.connectedToNetwork()
        {
            MyTools.tools.showIndicator(view: self.view)
            let myId = MyTools.tools.getMyId(pk_i_id: "pk_i_id")
            MyApi.api.GetOrderDetails(fk_order_id:self.pk_i_id,fk_user_id: Int(myId)! , PageSize: 10 , PageIndex: pageIndexNo ) {(response, err) in
                if((err) == nil)
                {
                    if let JSON = response.result.value as? NSDictionary
                    {
                        self.entries = JSON["status"] as? NSDictionary
                        self.TPaging = JSON["pagination"] as? NSDictionary

                        if (self.entries != nil)
                        {
                            self.Tcategory = JSON["TObject"] as! NSArray
                            self.FilteredArray =  self.Tcategory as NSArray
                            if (self.FilteredArray.count>0)
                            {
                                self.elements.addObjects(from: self.FilteredArray.subarray(with: NSMakeRange(0,self.FilteredArray.count)))
                                self.isNewDataLoading = false
                            }
                            else
                            {
                                self.isNewDataLoading = false
                            }
                            
                            MyTools.tools.hideIndicator(view: self.view)
                            self.tbl.dataSource = self
                            self.tbl.delegate = self
                            self.tbl.reloadData()
                        }
                        else
                        {
                            MyTools.tools.hideIndicator(view: self.view)
                            MyTools.tools.showErrorAlert(title: "Error".localized, body: "An Error occurred".localized)
                        }
                    }
                    else
                    {
                        MyTools.tools.hideIndicator(view: self.view)
                        MyTools.tools.showErrorAlert(title: "Error".localized, body: "An Error occurred".localized)
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
            MyTools.tools.showErrorAlert(title: "Error".localized, body: "No Internet Connection".localized)
        }
    }
    @IBAction func btnClose(_ sender: UIButton)
    {
        dismiss(animated: true, completion: nil)
    }
 
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        if scrollView == self.tbl
        {
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {
                if !isNewDataLoading
                {
                    if MyTools.tools.connectedToNetwork()
                    {
                        //                        if(self.TPaging.count>0)
                        //                        {
                        if ( (self.TPaging["currentPage"] as! Int) <= (self.TPaging["totalPages"] as! Int) && self.FilteredArray.count>0)
                        {
                            isNewDataLoading=true
                            pageIndex = pageIndex + 1
                            self.LoadNotifications(pageIndexNo: pageIndex)
                            self.tbl.reloadData()
                            print(pageIndex)
                        }
                        //                        }
                    }
                }
            }
        }
    }
    
}

extension SAOrderDetails : MIBlurPopupDelegate
{
    var popupView: UIView {
        return self.view
    }
    
    var blurEffectStyle: UIBlurEffectStyle {
        return .dark
    }
    
    var initialScaleAmmount: CGFloat {
        return 3
    }
    
    var animationDuration: TimeInterval {
        return 0.5
    }
    
}

