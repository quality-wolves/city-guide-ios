//
//  MainViewController.swift
//  CityGuide
//
//  Created by Vladislav Zozulyak on 06.02.15.
//  Copyright (c) 2015 The Empire. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, HeaderViewDelegate, UIAlertViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var headLabel: UILabel!
    var refreshControl: UIRefreshControl!
    var headerView: HeaderView!
	private var categories: [CGCategory]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.registerNib(UINib(nibName: "MenuCollectionCell", bundle: nil), forCellWithReuseIdentifier: "MenuCollectionCell")
        self.collectionView.registerNib(UINib(nibName: "HeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderView")
		self.refreshControl = UIRefreshControl()
        self.refreshControl.tintColor = UIColor.blackColor()
        self.refreshControl.addTarget(self, action: "refreshAction", forControlEvents: UIControlEvents.ValueChanged)
        self.collectionView.addSubview(self.refreshControl)
        
        let string = "by Coolmapp"
        let boldFont = UIFont.boldSystemFontOfSize(9.0)
        let italicFont = UIFont.italicSystemFontOfSize(9.0)
        let regularFont = UIFont.systemFontOfSize(9.0)
        let range = NSMakeRange(3, 8)

        let attrString:NSMutableAttributedString = NSMutableAttributedString(string: string)

        attrString.beginEditing()
        attrString.addAttribute(NSFontAttributeName, value: boldFont, range: range)
        attrString.addAttribute(NSFontAttributeName, value: italicFont, range: range)
        attrString.endEditing()
        
        self.headLabel.attributedText = attrString
        categories = CGCategory.allCategoriesExceptHotspots();
    }
    
    func refreshAction() {
        self.checkForUpdate()
    }
    
    func getLastSaveDate() -> NSDate {
        let kPrevCheckTimeKey = "PrevCheckTimeKey"
        var date:NSDate? = NSUserDefaults.standardUserDefaults().objectForKey(kPrevCheckTimeKey) as? NSDate
        
        
        if date == nil {
            date = NSDate(timeIntervalSince1970: 0)
        }
    
        return date!
    }
    
    func setLastSaveDateNow() {
        let kPrevCheckTimeKey = "PrevCheckTimeKey"
        NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey: kPrevCheckTimeKey)
    }
    
    func showLoading(animated: Bool) {
        if animated {
            UIView.animateWithDuration(0.5, animations: {
                self.loadingView.alpha = 1;
            })
        } else {
            self.loadingView.alpha = 1;
        }
    }

    func hideLoading(animated: Bool) {
        if animated {
            UIView.animateWithDuration(0.3, animations: {
                self.loadingView.alpha = 0;
            })
        } else {
            self.loadingView.alpha = 0;
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        var nowDate = NSDate()
        if (nowDate.timeIntervalSinceDate(self.getLastSaveDate()) > 10*60) {//24*60*60) {
            self.setLastSaveDateNow()
            self.checkForUpdate()
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.hideLoading(false)
        var flowLayout: UICollectionViewFlowLayout? = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        var padding:CGFloat = 5
        let rowsize = ceil((self.collectionView.height-38)/5)
        NSLog("%@ %@", rowsize, rowsize*2+14)
        var w:CGFloat = self.collectionView.frame.size.width/2.0 - padding
        var kImgScaleFactor:CGFloat = 335.0/640.0;
        flowLayout?.itemSize = CGSizeMake(w, w * kImgScaleFactor as CGFloat + 29)
        
        
        flowLayout?.minimumLineSpacing = 0;
        flowLayout?.headerReferenceSize = CGSizeMake(self.collectionView.width, self.collectionView.width * kImgScaleFactor as CGFloat + 41 + 12);

//        flowLayout?.itemSize = CGSizeMake(w, (self.collectionView.height - 238)/3)
//        flowLayout?.minimumLineSpacing = 0;
//        flowLayout?.headerReferenceSize = CGSizeMake(self.collectionView.width, 238);
//        flowLayout?.minimumInteritemSpacing = 2;

        self.collectionView.collectionViewLayout = flowLayout!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    required init() {
        super.init(nibName: "MainViewController", bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories.count;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let identifier = "MenuCollectionCell"
        var cell: MenuCollectionCell? = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as? MenuCollectionCell
		cell?.setCategory(categories[indexPath.row]);
        return cell!
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if (kind == UICollectionElementKindSectionHeader) {
            var headerView = self.collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderView", forIndexPath: indexPath) as! HeaderView
            headerView.delegate = self;
            return headerView
        }
        return UICollectionReusableView()//TODO WTF AM I DOING
    }
    
    func headerViewDidSelectedCategory(category: CGCategory!) {
        didSelectCategory(category)
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    func didSelectCategory (category: CGCategory!) {
        if (category.id == CategoryEnum.Map) {
            var mapVC = MapViewController()
            self.navigationController?.pushViewController(mapVC, animated: true)
            return
        }
        
        if (category.id == CategoryEnum.Whatson) {
            var whatsonVC = WhatsonCollectionViewController()
            self.navigationController?.pushViewController(whatsonVC, animated: true)
            return
        }
        
        let hotspots = Hotspot.hotspotsByCategory(category)
        
        if hotspots.count == 0 {
            if category.id == CategoryEnum.Favourites {
                var alert = UIAlertView(title: kAppName, message: "No favourites added yet!", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
                return
            }
            
            var alert = UIAlertView(title: kAppName, message: "Sorry, there is no items for " + category.name, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            return
        }
        
        var hotspotsController = HotspotCollectionViewController(hotspots: hotspots)
        //		navigationController = UINavigationController(rootViewController: mainVC)
        //		navigationController?.navigationBarHidden = true;
        
        self.navigationController?.pushViewController(hotspotsController, animated: true)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		let category = categories[indexPath.row]
        self.didSelectCategory(category)
    }
    
    func update() {
        self.showLoading(true)
        DataManager.instance().updateWithCompletition({(bool finished) in
            SQLiteWrapper.sharedInstance().closeDatabase()
            SQLiteWrapper.sharedInstance().openDatabase()
            self.hideLoading(true)
        })
//        let todayDate = NSDate()
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        let date = dateFormatter.stringFromDate(self.getLastUpdateDate())
//        let attachmentsUrl = SERVER_URL + "get_attachments_that_has_loaded_after/" + date
//        let databaseUrl = SERVER_URL + "get_database"
//        DataManager.instance().downloadAndUnzip(databaseUrl, completionHandler: {
//            DataManager.instance().downloadAndUnzip(attachmentsUrl, completionHandler: {
//                NSLog("Attachments downloaded and unzipped!");
//                self.collectionView.reloadData()
//
////                self.refreshControl.endRefreshing()
//            })
//        })

    }
    
    func getLastUpdateDate() -> NSDate {
        return Hotspot.lastUpdateDate()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if (buttonIndex == 1) { //ok
            self.update()
        }
    }
    
    func checkForUpdate() {
        DataManager.instance().checkForUpdateWithCompletition({ (bool hasUpdates) in
            self.refreshControl.endRefreshing()
            if (hasUpdates) {
                let alert = UIAlertView(title: kAppName, message: "There is new hotspots coming. Would you like to update resources?", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "OK")
                alert.show()
            }
        });
    }
}