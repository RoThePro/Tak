//
//  ContentViewController.swift
//  Tak
//
//  Created by Rohan Bharadwaj on 7/17/15.
//  Copyright (c) 2015 MakeSchool. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var pageIndex: Int!
    var titleText: String!
    var imageFile: String!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.imageView.image = UIImage(named: self.imageFile)
        self.titleLabel.text = self.titleText
    }
    
}
