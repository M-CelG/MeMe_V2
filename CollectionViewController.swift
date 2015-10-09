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
    
    var memes: [Meme]!{
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
}
