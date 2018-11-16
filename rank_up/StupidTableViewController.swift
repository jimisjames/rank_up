//
//  StupidTableViewController.swift
//  rank_up
//
//  Created by Jim Lambert on 11/16/18.
//  Copyright © 2018 Jim Lambert. All rights reserved.
//

import UIKit

class StupidTableViewController: UITableViewController {
    
    var name: String?

    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let text = name {
            textField.text = text
        }
    }

}
