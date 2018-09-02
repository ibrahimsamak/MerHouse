//
//  SAOrdersVC.swift
//  MerHouse
//
//  Created by ibrahim M. samak on 4/6/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class SAOrdersVC:  UIViewController  ,UITableViewDelegate  , UITableViewDataSource  {
    
    @IBOutlet weak var tbl: UITableView!
    var entries : NSDictionary!
    var Tcategory : NSArray = []
    var FilteredArray : NSArray = []
    var elements: NSMutableArray = []
    var pageSize : Int = 10
    var pageIndex : Int = 1
    var TPaging : NSDictionary!
    var btnBarBadge : MJBadgeBarButton!
    var isNewDataLoading: Bool = false
    
    
    @objc func onBagdeButtonClick()
    {
        print("button Clicked \(self.btnBarBadge.badgeValue)")
        let vc:SACartVC = AppDelegate.storyboard.instanceVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "MY ORDERS".localized
        self.tbl.register(UINib(nibName: "MyOrder", bundle: nil), forCellReuseIdentifier: "MyOrder")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationButton()
        if ((UserDefaults.standard.object(forKey: "CurrentUser")) != nil)
        {
            self.elements.removeAllObjects()
            self.LoadNotifications(pageIndexNo: self.pageIndex)
        }
        
        self.tbl.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.elements.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrder", for: indexPath) as!  MyOrder
        let content = self.elements.object(at: indexPath.row) as AnyObject
        let s_name = content.value(forKey: "s_name") as! String
        let s_details = content.value(forKey: "s_details") as! String
        let s_Jawwal = content.value(forKey: "s_jawwal") as! String
        let s_steet = content.value(forKey: "s_street") as! String
        if let n = content.value(forKey: "d_total") as? NSNumber
        {
            let f = n.floatValue
            cell.lblTotal.text = "Total".localized+" "+String(f)+" "+"AED".localized
        }
        
        
//        let d_total = content.value(forKey: "d_total") as! Float
        let TStatu = content.value(forKey: "TStatu") as! NSDictionary
        let StatusName = TStatu.value(forKey: "s_name") as! String
        let StatusNameEn = TStatu.value(forKey: "s_nameEn") as! String
        let dt_date = content.value(forKey: "dt_date") as! String
        let i_deliver = content.value(forKey: "i_deliver") as? String ?? "0"

        cell.lblStatusName.text = StatusNameEn
        cell.lblTitle.text = "Order No. "+s_name
        cell.lblDate.text = dt_date
        cell.lblJawwal.text = "Phone: "+s_Jawwal
        cell.lblAddress.text = "Address: "+s_steet
        cell.llblDesc.text = s_details
        cell.lblDelivery.text = "Delivery Charge:".localized+" "+i_deliver+" "+"AED".localized
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 180.0
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
    
    func LoadNotifications(pageIndexNo:Int)
    {
        if MyTools.tools.connectedToNetwork()
        {
            MyTools.tools.showIndicator(view: self.view)
            let myId = MyTools.tools.getMyId(pk_i_id: "pk_i_id")
            MyApi.api.GetOrders(fk_user_id: Int(myId)! , PageSize: 10 , PageIndex: pageIndexNo ) {(response, err) in
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let content = self.elements.object(at: indexPath.row) as AnyObject
        let pk_id_id = content.value(forKey: "pk_i_id") as! Int
        
        let vc:SAOrderDetails = AppDelegate.storyboard.instanceVC()
        vc.pk_i_id = pk_id_id
        MIBlurPopup.show(vc, on: self)

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

