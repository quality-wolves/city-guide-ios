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
        
		categories = CGCategory.allCategoriesExceptHotspots();
        
        SQLiteWrapper.sharedInstance().checkFile()
    }
    
    func refreshAction() {
        self.checkForUpdate()
        self.refreshControl.endRefreshing()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        self.checkForUpdate()
    }
    
    override func viewDidLayoutSubviews() {
        var flowLayout: UICollectionViewFlowLayout? = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        var padding:CGFloat = 5
        let rowsize = ceil((self.collectionView.height-38)/5)
        NSLog("%@ %@", rowsize, rowsize*2+14)
        var w:CGFloat = self.collectionView.frame.size.width/2.0 - padding
        flowLayout?.itemSize = CGSizeMake(w, rowsize+1)
        flowLayout?.minimumLineSpacing = 0;
        flowLayout?.headerReferenceSize = CGSizeMake(self.collectionView.width, rowsize*2+14);

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
        return self.categories.count;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let identifier = "MenuCollectionCell"
        var cell: MenuCollectionCell? = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as? MenuCollectionCell
		cell?.setCategory(categories[indexPath.row]);
        return cell!
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView? {
        if (kind == UICollectionElementKindSectionHeader) {
            var headerView = self.collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderView", forIndexPath: indexPath) as HeaderView
            headerView.delegate = self;
            return headerView
        }
        return nil
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
        let todayDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.stringFromDate(self.getLastUpdateDate())
        let attachmentsUrl = SERVER_URL + "get_attachments_that_has_loaded_after/" + date
        let databaseUrl = SERVER_URL + "get_database"
        DataManager.instance().downloadAndUnzip(databaseUrl, completionHandler: {
            DataManager.instance().downloadAndUnzip(attachmentsUrl, completionHandler: {
                NSLog("Attachments downloaded and unzipped!");
                self.collectionView.reloadData()
//                self.refreshControl.endRefreshing()
            })
        })

    }
    
    func getLastUpdateDate() -> NSDate {
        let fm = NSFileManager.defaultManager()
        let path = NSString(format: "%@/%@", DataManager.instance().documentsDirectory(), SQLiteWrapper.sharedInstance().name)

        var error: NSError?
        let attrs = fm.attributesOfItemAtPath(path, error: &error) as NSDictionary!
        let date = attrs["NSFileModificationDate"] as NSDate!

        return date.dateByAddingTimeInterval(-24*60*60)
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if (buttonIndex == 1) { //ok
            self.update()
        } else {
//            self.refreshControl.endRefreshing()
        }
    }
    
    func checkForUpdate() {
        let todayDate = NSDate()
        let lastUpdate = self.getLastUpdateDate()
        
        if (todayDate.timeIntervalSinceDate(lastUpdate) > 1) {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.stringFromDate(lastUpdate)
            
            let urlString: String = SERVER_URL + "is_updated/" + dateString + ".json"
            let url = NSURL(string: urlString)

            NSLog("Url string: %@", urlString)
            NSLog("Url: %@", url!)
            
            dispatch_async(dispatch_get_global_queue(0,0), {
                var isUpdated:NSInteger = 0

                var parseError: NSError?
                let str = NSString(contentsOfURL: url!, encoding: NSUTF8StringEncoding, error: &parseError)
                if (parseError != nil) {
                    NSLog("download error: %@", parseError!)
                }
                if (str != nil) {
                    NSLog("data: %@", str!)
 
                    let data = str?.dataUsingEncoding(NSUTF8StringEncoding)
                    NSLog("Data not null")
                    if  let json: NSDictionary = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error:&parseError) as? NSDictionary {
                        NSLog("Serialization success")
                        if let count = json["count"] as? NSInteger {
                            isUpdated = count
                        }
                    }
                    
                    if (isUpdated > 0) {
                        dispatch_async(dispatch_get_main_queue(), {

                            let alert = UIAlertView(title: kAppName, message: "There is new hotspots coming. Would you like to update resources?", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "OK")
                            alert.show()
                        })
                    }
                }
            })

        }
    }
}