//
//  CollectionViewController.swift
//  MeMe_V2
//
//  Created by Manish Sharma on 10/9/15.
//  Copyright © 2015 CelG Mobile LLC. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewController: UICollectionViewController {
    //Access stored Images in App delegate
    var memes: [Meme]!{
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    //Flowlayout outlet to arrange cells in Collection View
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    //Set size, item spacing, and Inter-item spacing for flowlayout of Collection View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space1: CGFloat = 5.0
        let space2: CGFloat = 6.0
        let dimension1 = (self.view.frame.size.width - (2 * space1))/space1
        let dimension2 = (self.view.frame.size.height - (2 * space2))/space2
        
        flowLayout.minimumInteritemSpacing = space1
        flowLayout.minimumLineSpacing = space2
        flowLayout.itemSize = CGSizeMake(dimension1, dimension2)
        
    }
    override func viewWillAppear(animated: Bool) {
        //Reload images after new image has been saved
        collectionView!.reloadData()
        //Ensure tabbar controller is no longer hidden
        tabBarController?.tabBar.hidden = false
    }
    
    //Action outlet from Table view to MeMe Editor View Controller
    @IBAction func memeEditor(sender: AnyObject) {
        let memeEditorViewConttroller = storyboard!.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        navigationController!.pushViewController(memeEditorViewConttroller, animated: true)
    }
    
    //Collection view DataSource to return number of items in the collection view
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    //Collection view delegate to create collection view cells
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! CollectionViewCell
        //Pass-on MeMedImage to detailed view controller
        cell.imageView.image = memes[indexPath.row].memedImage
        return cell
    }
    
    //Collection view delegate to bring Detail View Controller
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let detailViewController = storyboard!.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        detailViewController.index = indexPath.row
        navigationController!.pushViewController(detailViewController, animated: true)
    }
    
}
