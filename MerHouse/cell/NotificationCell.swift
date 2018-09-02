//
//  NotificationCell.swift
//  MerHouse
//
//  Created by ibrahim M. samak on 4/6/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if(Language.currentLanguage().contains("ar")){
            lblDate.textAlignment = .right
            lblDesc.textAlignment = .right
        }
        else{
            lblDate.textAlignment = .left
            lblDesc.textAlignment = .left
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
