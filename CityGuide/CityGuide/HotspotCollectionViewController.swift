//
//  HotspotCollectionViewController.swift
//  CityGuide
//
//  Created by Vladislav Zozulyak on 06.02.15.
//  Copyright (c) 2015 The Empire. All rights reserved.
//

import UIKit

class HotspotCollectionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
	}
    
    required override init() {
		super.init(nibName: "HotspotCollectionViewController", bundle: nil)
	}

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

	}

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
