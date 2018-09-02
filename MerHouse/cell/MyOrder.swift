//
//  MyOrder.swift
//  MerHouse
//
//  Created by ibrahim M. samak on 4/6/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class MyOrder: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblJawwal: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var llblDesc: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblStatusName: UILabel!
    @IBOutlet weak var lblDelivery: UILabel!

    override func awakeFromNib()
    {
        super.awakeFromNib()
        if(Language.currentLanguage().contains("ar")){
            lblTitle.textAlignment = .right
            lblAddress.textAlignment = .right
            lblJawwal.textAlignment = .right
            lblTotal.textAlignment = .right
            llblDesc.textAlignment = .right
            lblDate.textAlignment = .right
            lblStatusName.textAlignment = .right
            lblDelivery.textAlignment = .right
        }
        else{
            lblTitle.textAlignment = .left
            lblAddress.textAlignment = .left
            lblJawwal.textAlignment = .left
            lblTotal.textAlignment = .left
            llblDesc.textAlignment = .left
            lblDate.textAlignment = .left
            lblStatusName.textAlignment = .left
            lblDelivery.textAlignment = .left
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
}
