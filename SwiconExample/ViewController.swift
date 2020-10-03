//
//  ViewController.swift
//  SwiconExample
//
//  Created by Zhibo Wei on 7/9/15.
//  Copyright (c) 2015 Zhibo Wei. All rights reserved.
//

import UIKit
import Swicon

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var btn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        Swicon.instance.loadAllSync(["gm"])
        label.attributedText = Swicon.instance.getNSMutableAttributedString("gm-games", fontSize: 10)
        btn.setAttributedTitle(Swicon.instance.getNSMutableAttributedString("fa-eur", fontSize: 10), for: UIControl.State())
        img.image = Swicon.instance.getUIImage("fa-heart", iconSize: 100, iconColour: UIColor.blue, imageSize: CGSize(width: 200, height: 200))
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

