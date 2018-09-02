//
//  SASearchVC.swift
//  MerHouse
//
//  Created by ibrahim M. samak on 5/11/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import SDWebImage

class SASearchVC: UIViewController,UICollectionViewDelegate , UICollectionViewDelegateFlowLayout ,  UICollectionViewDataSource , UISearchBarDelegate
{
    @IBOutlet weak var col: UICollectionView!
    @IBOutlet weak var txtSearch: UISearchBar!
    
    var entries : NSDictionary!
    var Tcategory : NSArray = []
    var FilteredArray : NSArray = []
    var Categoryid = 0
    var emptyDict: [Int: String] = [:]
    
    var pageSize : Int = 10
    var pageIndex : Int = 1
    var TPaging : NSDictionary!
    var isNewDataLoading: Bool = false
    var elements: NSMutableArray = []
    var btnBarBadge : MJBadgeBarButton!

    
    @objc func onBagdeButtonClick()
    {
        print("button Clicked \(self.btnBarBadge.badgeValue)")
        let vc:SACartVC = AppDelegate.storyboard.instanceVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        title = "SEARCH".localized
        
        self.col.contentInset = UIEdgeInsets(top: 23, left: 5, bottom: 10, right: 5)
        self.col.register(UINib(nibName: "ProductCell", bundle: nil), forCellWithReuseIdentifier: "ProductCell")
        
        //setNavigationButton()
        
        self.txtSearch.becomeFirstResponder()
        self.txtSearch.delegate = self
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.elements.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
        
        let content = self.elements.object(at: indexPath.row) as AnyObject
        let s_nameEn = content.value(forKey: "s_nameEn") as! String
        let s_name = content.value(forKey: "s_name") as! String
//        let Price = content.value(forKey: "Price") as! Float
        let s_image = content.value(forKey: "s_image") as? String ?? ""
        
        if let n = content.value(forKey: "Price") as? NSNumber
        {
            let f = n.floatValue
            cell.lblPrice.text = String(f)+" "+"AED".localized
        }
        
        
        if(Language.currentLanguage().contains("ar"))
        {
            cell.lblTitle.text = s_name
        }
        else
        {
            cell.lblTitle.text = s_nameEn
        }
        
        
        cell.img.sd_setImage(with: URL(string:MyApi.PhotoURL+s_image)!, placeholderImage: UIImage(named: "logo1")!, options: SDWebImageOptions.refreshCached)
//        cell.lblPrice.text = String(Price) + " AED "
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let cell = collectionView.cellForItem(at: indexPath)
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [],
                       animations: {
                        cell!.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)},
                       completion: { finished in
                        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: .curveEaseIn,
                                       animations: {
                                        cell!.transform = CGAffineTransform(scaleX: 1, y: 1)
                                        
                        },completion: {x in
                            let vc: SAProductDetailsVC = AppDelegate.storyboard.instanceVC()
                            let content = self.elements.object(at: indexPath.row) as AnyObject
                            let s_name = content.value(forKey: "s_nameEn") as! String
                            let s_nameEn = content.value(forKey: "s_nameEn") as! String
                            let d_weight = content.value(forKey: "d_weight") as! String

                            if let n = content.value(forKey: "Price") as? NSNumber
                            {
                                let f = n.floatValue
                                vc.price = (f)
                            }
                            
                            let s_image = content.value(forKey: "s_image") as? String ?? ""
                            let s_desc = content.value(forKey: "s_desc") as! String
                            let s_descEn = content.value(forKey: "s_descEn") as! String
                            let pk_i_id = content.value(forKey: "pk_i_id") as! Int
                            
                            if(Language.currentLanguage().contains("ar"))
                            {
                                vc.s_desc = s_desc
                                vc.s_name = s_name
                            }
                            else{
                                vc.s_desc = s_descEn
                                vc.s_name = s_nameEn
                            }
                                                                
                            vc.Pk_i_id = pk_i_id
                            vc.s_image = s_image
                            vc.weight = d_weight

                            MIBlurPopup.show(vc, on: self)
           })
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let size = collectionView.frame.width / 3 - 10
        return CGSize(width: size, height: 180)
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
        
        //        let search = UIImageView(image: #imageLiteral(resourceName: "Search"))
        //        search.frame = CGRect(x: CGFloat(2), y: CGFloat(0), width: CGFloat(20), height: CGFloat(20))
        //        let searchButton = UIButton(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(25), height: CGFloat(20)))
        //        searchButton.addSubview(search)
        //        searchButton.addTarget(self, action: #selector(self.Search(_:)), for: .touchUpInside)
        
        self.navigationItem.setRightBarButtonItems([UIBarButtonItem(customView: basketButton)], animated: true)
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
    
    func loadData(pageIndexNo:Int)
    {
        if MyTools.tools.connectedToNetwork()
        {
           let txtsearch = txtSearch.text?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            
            MyTools.tools.showIndicator(view: self.view)
            MyApi.api.GetProductsBySearch(s_name: txtsearch!,PageSize: 10 , PageIndex: pageIndexNo ) {(response, err) in
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
                            self.col.dataSource = self
                            self.col.delegate = self
                            self.col.reloadData()
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        if((txtSearch.text?.characters.count)! > 0)
        {
            pageIndex = 1
            self.elements.removeAllObjects()
            self.col.reloadData()
            UIView.animate(withDuration: 0.2){() -> Void in
                self.loadData(pageIndexNo: 1)
            }
            self.txtSearch.resignFirstResponder()
            self.col.reloadData()
        }
    }
}


