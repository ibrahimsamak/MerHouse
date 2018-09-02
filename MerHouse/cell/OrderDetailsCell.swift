//
//  OrderDetailsCell.swift
//  MerHouse
//
//  Created by ibrahim M. samak on 4/6/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class OrderDetailsCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblTitle:  UILabel!
    @IBOutlet weak var lblPrice:  UILabel!
    @IBOutlet weak var lblQty:    UILabel!
    @IBOutlet weak var lblweight: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if(Language.currentLanguage().contains("ar")){
            lblTitle.textAlignment = .right
            lblPrice.textAlignment = .right
            lblQty.textAlignment = .right
            lblweight.textAlignment = .right
        }
        else{
            lblTitle.textAlignment = .left
            lblPrice.textAlignment = .left
            lblQty.textAlignment = .left
            lblweight.textAlignment = .left
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
