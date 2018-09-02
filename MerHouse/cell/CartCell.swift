//
//  CartCell.swift
//  MerHouse
//
//  Created by ibrahim M. samak on 4/3/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class CartCell: UITableViewCell {

    @IBOutlet weak var stepper: GMStepper!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var btnDelete: UIButton!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        if(Language.currentLanguage().contains("ar")){
            lblTitle.textAlignment = .right
            lblPrice.textAlignment = .right
        }
        else{
            lblTitle.textAlignment = .left
            lblPrice.textAlignment = .left
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
