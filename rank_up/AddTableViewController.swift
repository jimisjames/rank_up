//
//  AddTableViewController.swift
//  rank_up
//
//  Created by Jim Lambert on 11/16/18.
//  Copyright © 2018 Jim Lambert. All rights reserved.
//

import UIKit

class AddTableViewController: UIViewController {
    
    var delegate: FormDelegate?
    
    var myIndexPath: IndexPath?
    
    var theSegue: UIStoryboardSegue?
    
    var currentName: String?
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stupid" {
            theSegue = segue
            let dest = segue.destination as! StupidTableViewController
            dest.name = currentName
        }
    }
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        let text = (theSegue?.destination as! StupidTableViewController).textField.text!
        if let indexPath = myIndexPath {
            delegate?.saveButtonPressed(text, indexPath)
        } else {
            delegate?.saveButtonPressed(text, nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

