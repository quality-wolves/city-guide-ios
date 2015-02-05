//
//  MenuCollectionCell.swift
//  CityGuide
//
//  Created by Vladislav Zozulyak on 06.02.15.
//  Copyright (c) 2015 The Empire. All rights reserved.
//

import UIKit

class MenuCollectionCell: UICollectionViewCell {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var backgroundImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
