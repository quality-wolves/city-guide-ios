//
//  MenuCollectionCell.swift
//  CityGuide
//
//  Created by Vladislav Zozulyak on 06.02.15.
//  Copyright (c) 2015 The Empire. All rights reserved.
//

import UIKit

class MenuCollectionCell: UICollectionViewCell {
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var backgroundImage: UIImageView!
	
	func setCategory(category: CGCategory) {
		titleLabel.text = category.name.uppercaseString
        titleLabel.font = titleLabel.font.fontWithSize(9)
		backgroundImage.image = UIImage(named: category.imageFileName());
	}
}
