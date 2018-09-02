//
//  CategoryCell.swift
//  MerHouse
//
//  Created by ibrahim M. samak on 4/3/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewContent: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.viewContent.layer.borderWidth = 1
//        self.viewContent.layer.borderColor = MyTools.tools.colorWithHexString("a1a1a1").cgColor
        
    }

}
