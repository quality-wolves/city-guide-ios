//
//  MainViewController.swift
//  CityGuide
//
//  Created by Vladislav Zozulyak on 06.02.15.
//  Copyright (c) 2015 The Empire. All rights reserved.
//

import UIKit

enum Menu: Int {
    case Stay = 0
    case Eat, Buy, Drink, See, Do, Favourites, Map, Whatson, Soundtrack
    func description() -> String {
        switch self {
        case .Stay:
            return "Stay"
        case .Eat:
            return "Eat"
        case .Buy:
            return "Buy"
        case .Drink:
            return "Drink"
        case .See:
            return "See"
        case .Do:
            return "Do"
        case .Favourites:
            return "Favourites"
        case .Map:
            return "Map"
        case .Whatson:
            return "Whatson"
        case .Soundtrack:
                return "Soundtrack"
        default:
            return String(self.rawValue)
        }
    }
}

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.registerNib(UINib(nibName: "MenuCollectionCell", bundle: nil), forCellWithReuseIdentifier: "MenuCollectionCell")
    }
    
    override func viewDidLayoutSubviews() {
        var flowLayout: UICollectionViewFlowLayout? = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        var padding:CGFloat = 5
        var w:CGFloat = (self.view.frame.size.width - padding)/2.0
        flowLayout?.itemSize = CGSizeMake(w, w)
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
        
        var menuItem: Menu = Menu(rawValue: indexPath.row)!
        cell?.titleLabel.text = menuItem.description()
        switch menuItem {
        case .Stay:
            cell?.backgroundImage.image = UIImage(named: "Menu2 2")
            break
        case .Eat:
            cell?.backgroundImage.image = UIImage(named: "Salero")
            break
        case .Buy, .Favourites:
            cell?.backgroundImage.image = UIImage(named: "BARCELONA-BUY 5")
            break
        case .Drink, .Map:
            cell?.backgroundImage.image = UIImage(named: "Drink-1 2")
            break
        case .See, .Whatson:
            cell?.backgroundImage.image = UIImage(named: "See 2")
            break
        case .Do, .Soundtrack:
            cell?.backgroundImage.image = UIImage(named: "Cine")
            break
//        case .Favourites:
//            cell?.backgroundImage.image = UIImage(named: "BARCELONA-BUY 5")
//            break
//        case .Map:
//            cell?.backgroundImage.image = UIImage(named: "")
//            break
//        case .Whatson:
//            cell?.backgroundImage.image = UIImage(named: "")
//            break
//        case .Soundtrack:
//            cell?.backgroundImage.image = UIImage(named: "")
//            break
        }
        
        return cell!
    }
    

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.navigationController?.pushViewController(AppDelegate.sharedInstance().hotspotsController, animated: true)
        
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
