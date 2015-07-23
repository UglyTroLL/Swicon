//
//  IconCollectionViewController.swift
//  SwiconExample
//
//  Created by Zhibo Wei on 7/23/15.
//  Copyright (c) 2015 Zhibo Wei. All rights reserved.
//

import Foundation
import UIKit
import Swicon

let cellIdentifier = "IconCell"

class IconCollectionViewController: UICollectionViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let iconNames = [
        "fa-bed",
        "fa-viacoin",
        "fa-train",
        "fa-subway",
        "fa-medium",
        "fa-recycle",
        "fa-car",
        "fa-taxi",
        "fa-tree",
        "fa-spotify",
        "fa-apple",
        "fa-windows",
        "fa-android",
        "fa-linux",
        "fa-dribbble",
        "fa-skype",
        "fa-foursquare",
        "fa-trello",
        "fa-female",
        "fa-male",
        "fa-gratipay",
        "fa-sun-o",
        "fa-moon-o",
        "fa-archive",
        "fa-bug",
        "fa-vk",
        "gm-sim_card",
        "gm-sim_card_alert",
        "gm-skip_next",
        "gm-skip_previous",
        "gm-slideshow",
        "gm-smartphone",
        "gm-sms",
        "gm-sms_failed",
        "gm-snooze",
        "gm-sort",
        "gm-sort_by_alpha",
        "gm-space_bar",
        "gm-speaker",
        "gm-speaker_group",
        "gm-speaker_notes",
        "gm-speaker_phone",
        "gm-spellcheck",
        "gm-star",
        "gm-today",
        "gm-toll",
        "gm-tonality",
        "gm-toys",
        "gm-track_changes",
        "gm-traffic",
        "gm-wc",
        "gm-web",
        "gm-whatshot",
        "gm-widgets",
        "gm-wifi",
        "gm-wifi_lock",
        "gm-wifi_tethering",
        "gm-work"
    ]
    
    var iconImages = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        for iconName in iconNames {
            iconImages.append(Swicon.instance.getUIImage(iconName, iconSize: 45, iconColour: getRandomColor(), imageSize: CGSizeMake(48, 48)))
        }
    }
    
    func getRandomColor() -> UIColor{
        var randomRed:CGFloat = CGFloat(drand48())
        var randomGreen:CGFloat = CGFloat(drand48())
        var randomBlue:CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return iconImages.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! IconCollectionViewCell
        let image = iconImages[indexPath.row]
        cell.iconImageView.image = image
        return cell
    }
    
}