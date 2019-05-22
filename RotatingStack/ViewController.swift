//
//  ViewController.swift
//  RotatingStack
//
//  Created by Ethan Fine on 2/17/19.
//  Copyright © 2019 Ethan Fine. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // 135, 1000, 100
    // 12, 1350, 350
    let backgroundColor = UIColor(red:0.31, green:0.30, blue:0.31, alpha:1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = backgroundColor
        
        let rotatingStack = RotatingStack(x: 135, y: 1000, width: 100, itemSpacing: 20)
        view.layer.addSublayer(rotatingStack)
        rotatingStack.startAnimating()
    }


}

