//
//  MainCategory.swift
//  MerHouse
//
//  Created by ibrahim M. samak on 4/25/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class MainCategory: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var img: UIImageView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if(Language.currentLanguage().contains("ar"))
        {
            lblName.textAlignment = .right
        }
        else{
            lblName.textAlignment = .left
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
