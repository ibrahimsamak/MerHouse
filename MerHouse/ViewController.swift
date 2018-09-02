//
//  ViewController.swift
//  MerHouse
//
//  Created by ibrahim M. samak on 4/2/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import AKSideMenu

class ViewController: UIViewController , CPSliderDelegate {
    
    @IBOutlet weak var btn_Menu: UIButton!
    @IBOutlet weak var Slider: CPImageSlider!

    var TSlider :NSArray = []
    var imagesArray = ["1.png","2.png"]
    var total = ""


    
    func sliderImageTapped(slider: CPImageSlider, index: Int)
    {
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true

        self.Slider.delegate = self
        self.Slider.autoSrcollEnabled = true
        self.Slider.enableArrowIndicator = false
        self.Slider.images = self.imagesArray
        self.Slider.durationTime = 4
    }
    
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        if(Language.currentLanguage().contains("ar")){
            self.btn_Menu.setImage(#imageLiteral(resourceName: "Back ChevronAr"), for: .normal)

        }
        else{
            self.btn_Menu.setImage(#imageLiteral(resourceName: "Back Chevron"), for: .normal)
        }
    }
    
    @IBAction func btnClick(_ sender: UIButton)
    {
        
    }
    
    @IBAction func hide(_ sender: UIButton)
    {
     
    }
    
    @IBAction func btnClose(_ sender: UIButton)
    {
        self.navigationController?.pop(animated: true)
    }
    
    @IBAction func btnSignIn(_ sender: UIButton) {
        let vc :SALoginVC = AppDelegate.storyboard.instanceVC()
        vc.total = self.total
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnSignUp(_ sender: UIButton) {
        let vc :SARegister = AppDelegate.storyboard.instanceVC()
        vc.total = self.total
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

