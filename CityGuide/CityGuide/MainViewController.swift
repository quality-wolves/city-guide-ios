//
//  MainViewController.swift
//  CityGuide
//
//  Created by Vladislav Zozulyak on 06.02.15.
//  Copyright (c) 2015 The Empire. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var loadingView: UIView!

	private var categories: [Category]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.registerNib(UINib(nibName: "MenuCollectionCell", bundle: nil), forCellWithReuseIdentifier: "MenuCollectionCell")
		
		categories = Category.allCategories();
		
		DataManager.instance().downloadImages({ () -> Void in
			self.loadingView.hidden = true
		});
    }
    
    override func viewDidLayoutSubviews() {
        var flowLayout: UICollectionViewFlowLayout? = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        var padding:CGFloat = 2
        var w:CGFloat = (self.view.frame.size.width - padding)/2.0
        flowLayout?.itemSize = CGSizeMake(w, w)
        flowLayout?.minimumLineSpacing = padding;

        self.collectionView.collectionViewLayout = flowLayout!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    required override init() {
        super.init(nibName: "MainViewController", bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let identifier = "MenuCollectionCell"
        var cell: MenuCollectionCell? = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as? MenuCollectionCell
		cell?.setCategory(categories[indexPath.row]);
        return cell!
    }
    

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		let category = categories[indexPath.row]
        
        if (category.id == CategoryEnum.Map) {
            var mapVC = MapViewController()
            self.navigationController?.pushViewController(mapVC, animated: true)
            return
        }
        
		let hotspots = Hotspot.hotspotsByCategory(category)
		
        if hotspots.count == 0 {
            var alert = UIAlertView(title: kAppName, message: "Sorry, there is no items for " + category.name, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            return
        }
		
		var hotspotsController = HotspotCollectionViewController(hotspots: hotspots)
//		navigationController = UINavigationController(rootViewController: mainVC)
//		navigationController?.navigationBarHidden = true;
		
        self.navigationController?.pushViewController(hotspotsController, animated: true)
    }
}