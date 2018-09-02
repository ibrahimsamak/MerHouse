//
//  SAFavVC.swift
//  MerHouse
//
//  Created by ibrahim M. samak on 4/6/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import TZSegmentedControl
import SDWebImage

class SAFavVC: UIViewController,UICollectionViewDelegate , UICollectionViewDelegateFlowLayout ,  UICollectionViewDataSource
{
    @IBOutlet weak var col: UICollectionView!
    
  
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
    
    var DataArray = [RFav]()
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
        
        title = "FAVORITE".localized

        self.col.contentInset = UIEdgeInsets(top: 23, left: 5, bottom: 10, right: 5)
        self.col.register(UINib(nibName: "ProductCell", bundle: nil), forCellWithReuseIdentifier: "ProductCell")
        

        self.loadData()
        self.col.delegate = self
        self.col.reloadData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        setNavigationButton()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.DataArray.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
        
        let content = self.DataArray[indexPath.row]
        let s_name = content.s_name
        let Price = content.d_price
        let s_image = content.s_image
        
        cell.img.sd_setImage(with: URL(string:MyApi.PhotoURL+s_image)!, placeholderImage: UIImage(named: "logo1")!, options: SDWebImageOptions.refreshCached)
        cell.lblTitle.text = s_name
        cell.lblPrice.text = String(Price)+" "+"AED".localized
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
                            let content = self.DataArray[indexPath.row]
                            let s_name = content.s_name
                            let Price = content.d_price
                            let s_image = content.s_image
                            let s_desc = content.s_desc
                            let pk_i_id = content.pk_i_id
                            let weight =  content.d_weight

                            vc.price = (Price)
                            vc.s_desc = s_desc
                            vc.s_name = s_name
                            vc.Pk_i_id = Int(pk_i_id)!
                            vc.s_image = s_image
                            vc.weight = weight
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

    func loadData()
    {
        var myId = ""
        var devicetoken = ""
        if ((UserDefaults.standard.object(forKey: "CurrentUser")) != nil)
        {
            myId = MyTools.tools.getMyId(pk_i_id: "pk_i_id")
            devicetoken = UIDevice.current.identifierForVendor!.uuidString
        }
        else
        {
            devicetoken =  UIDevice.current.identifierForVendor!.uuidString
            myId = ""
        }
        
        self.DataArray = RealmFunctions.shared.GetMyFavItems(s_devicetoken:devicetoken, s_devicetoken2:myId).toArray(ofType: RFav.self)
        self.col.reloadData()
    }
}


