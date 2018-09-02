//
//  SAProductVC.swift
//  MerHouse
//
//  Created by ibrahim M. samak on 4/3/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import TZSegmentedControl
import SDWebImage

class SAProductVC: UIViewController,UICollectionViewDelegate , UICollectionViewDelegateFlowLayout ,  UICollectionViewDataSource,UIScrollViewDelegate
{
    @IBOutlet weak var col: UICollectionView!
    @IBOutlet var segControlFromNib : TZSegmentedControl!
    
    
    var DictPl11 = [1: "test", 4: "test1", 3: "test3", 6: "test0" , 7:"test10"] as [Int: String]
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
    var fk_category_id = 0
    
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
        
        title = "PRODUCTS".localized
        col.dataSource = self
        col.delegate = self
        
        self.col.contentInset = UIEdgeInsets(top: 23, left: 5, bottom: 10, right: 5)
        self.col.register(UINib(nibName: "ProductCell", bundle: nil), forCellWithReuseIdentifier: "ProductCell")
        
       //setNavigationButton()
        self.LoadCategories(fk_catogrry_id: self.fk_category_id)
        
        
        //        self.LoadProducts(fk_Category_id: self.Categoryid, pageIndexNo: self.pageIndex)
        
        //        let segControlFromNib = TZSegmentedControl(sectionTitles: ["TRENDING","EDITOR'S PICKS", "FOR YOU", "VIDEOS", "LANGUAGE" ])
        //        titleCont1.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)

        segControlFromNib.indicatorWidthPercent = 3.0
        segControlFromNib.backgroundColor = UIColor.white
        segControlFromNib.borderColor = UIColor.white
        segControlFromNib.borderWidth = 0.5
        segControlFromNib.segmentWidthStyle = .dynamic
        segControlFromNib.verticalDividerEnabled = true
        segControlFromNib.verticalDividerWidth = 0.5
        segControlFromNib.verticalDividerColor = UIColor.white
        segControlFromNib.selectionStyle = .textWidth
        segControlFromNib.selectionIndicatorLocation = .down
        segControlFromNib.selectionIndicatorColor = MyTools.tools.colorWithHexString("46CCF7")
        segControlFromNib.selectionIndicatorHeight = 2.0
        segControlFromNib.borderType = .bottom
        //        titleCont1.edgeInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        segControlFromNib.selectedTitleTextAttributes =
            [NSAttributedStringKey.foregroundColor.rawValue:MyTools.tools.colorWithHexString("46CCF7"),
             NSAttributedStringKey.font.rawValue:UIFont(name: "Tahoma", size: 18.0) ?? UIFont.systemFont(ofSize: 18.0)]
        
        segControlFromNib.titleTextAttributes =             [NSAttributedStringKey.foregroundColor.rawValue:UIColor.black]

        //        self.view.addSubview(titleCont1)
        
        //self.view.backgroundColor = UIColor(red: 0.3, green: 0.4, blue: 0.7, alpha: 0.7)
        
        //        segControlFromNib.indexChangeBlock = { (index) in
        //            debugPrint("Segmented \(self.segControlFromNib.sectionTitles[index]) is visible now")
        //        }
        
        segControlFromNib.indexChangeBlock = { (index) in
            self.pageIndex = 1
            self.elements.removeAllObjects()
            let value = (Array(self.emptyDict.values))
            let key = (Array(self.emptyDict.keys))
            print(value[index])
            print(key[index])
            self.Categoryid = key[index]
            self.LoadProducts(fk_Category_id: self.Categoryid, pageIndexNo: self.pageIndex)
        }
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
        
        if(Language.currentLanguage().contains("ar")){
            let s_name = content.value(forKey: "s_name") as! String
            cell.lblTitle.text = s_name
        }
        else
        {
            let s_nameEn = content.value(forKey: "s_nameEn") as! String
            cell.lblTitle.text = s_nameEn
        }
        
        
        if let n = content.value(forKey: "Price") as? NSNumber
        {
            let f = n.floatValue
            cell.lblPrice.text = String(f)+" "+"AED".localized
        }
        
        //        let Price = content.value(forKey: "Price") as! Float
        let s_image = content.value(forKey: "s_image") as? String ?? ""
        
        cell.img.sd_setImage(with: URL(string:MyApi.PhotoURL+s_image)!, placeholderImage: UIImage(named: "logo1")!, options: SDWebImageOptions.refreshCached)

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
                            else
                            {
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
    
    func LoadCategories(fk_catogrry_id : Int)
    {
        print("Loding when Pull")
        if MyTools.tools.connectedToNetwork()
        {
            MyTools.tools.showIndicator(view: self.view)
            MyApi.api.GetSubCategory(fk_category_id: fk_catogrry_id){ (response, err) in
                if((err) == nil)
                {
                    if let JSON = response.result.value as? NSDictionary
                    {
                        self.entries = JSON["status"] as? NSDictionary
                        if (self.entries != nil)
                        {
                            //                            self.Tcategory = JSON["TObject"] as! NSArray
                            //                            self.FilteredArray =  self.Tcategory as NSArray
                            
                            //                            var deserts = new Dictionary<int,string>();
                            //                            for (var i = 0; i < values.Length; i += 2) {
                            //                                deserts.Add(int.Parse(values[i]), values[i+1]);
                            //                            }
                            //
                            //                            print(JSON["TObject"]as! NSArray)
                            let categryArry = JSON["TObject"]as! NSArray
                            if (categryArry.count > 0)
                            {
                                for index in 0..<categryArry.count
                                {
                                    let content = categryArry.object(at: index) as AnyObject
                                    let pk = content.value(forKey: "pk_i_id") as! Int
                                    let s_nameEn = content.value(forKey: "s_nameEn") as! String
                                    let s_name = content.value(forKey: "s_name") as! String
                                    
                                    if(Language.currentLanguage().contains("ar"))
                                    {
                                        self.emptyDict[pk] = s_name
                                    }
                                    else
                                    {
                                        self.emptyDict[pk] = s_nameEn
                                    }
                                }
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.init(uptimeNanoseconds: 30000))
                                {
                                    self.segControlFromNib!.sectionTitles = Array(self.emptyDict.values)
                                }
                                
                                print(self.emptyDict)
                                self.Categoryid = (self.emptyDict.first?.key)!
                                print(self.Categoryid)
                            }
                            
                            if(self.emptyDict.count > 0 )
                            {
                                
                                self.LoadProducts(fk_Category_id: self.Categoryid, pageIndexNo: self.pageIndex)
                                
                            }
                            else
                            {
                                self.LoadProductsFromMainCategory(fk_Category_id: self.fk_category_id, pageIndexNo: self.pageIndex)
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
    
    
    func LoadProducts(fk_Category_id:Int , pageIndexNo:Int)
    {
        if MyTools.tools.connectedToNetwork()
        {
            MyTools.tools.showIndicator(view: self.view)
            MyApi.api.GetProductsByCategoryId(fk_Category_id: fk_Category_id , PageSize: 18 , PageIndex: pageIndexNo ) {(response, err) in
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
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        if scrollView == self.col
        {
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {
                if !isNewDataLoading
                {
                    if MyTools.tools.connectedToNetwork()
                    {
                        //if(self.TPaging.count>0)
                        //{
                        if ( (self.TPaging["currentPage"] as! Int) <= (self.TPaging["totalPages"] as! Int) && self.FilteredArray.count>0)
                        {
                            isNewDataLoading=true
                            pageIndex = pageIndex + 1
                            self.LoadProducts(fk_Category_id: self.Categoryid, pageIndexNo: pageIndex)
                            self.col.reloadData()
                            print(pageIndex)
                        }
                        //}
                    }
                }
            }
        }
    }
    
    func LoadProductsFromMainCategory(fk_Category_id:Int , pageIndexNo:Int)
    {
        if MyTools.tools.connectedToNetwork()
        {
            MyTools.tools.showIndicator(view: self.view)
            MyApi.api.GetProductsByMinCategoryId(fk_Category_id: fk_Category_id , PageSize: 18 , PageIndex: pageIndexNo ) {(response, err) in
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
}

