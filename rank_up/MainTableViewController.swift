//
//  MainTableViewController.swift
//  rank_up
//
//  Created by Jim Lambert on 11/15/18.
//  Copyright © 2018 Jim Lambert. All rights reserved.
//

import UIKit
import CoreData

class MainTableViewController: UITableViewController, FormDelegate {
    
    var items = [Item]()
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let saveContext = (UIApplication.shared.delegate as! AppDelegate).saveContext
    
    @IBAction func add(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "add", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "add" {
            let navCon = segue.destination as! UINavigationController
            let dest = navCon.topViewController as! AddTableViewController
            dest.delegate = self
        } else if segue.identifier == "edit" {
            let navCon = segue.destination as! UINavigationController
            let dest = navCon.topViewController as! AddTableViewController
            dest.delegate = self
            dest.myIndexPath = sender as! IndexPath
            dest.currentName = items[(sender as! IndexPath).row].name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 65
        _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                self.fetchData()
                self.tableView.reloadData()
            }
        tableView.rowHeight = 65
    }
    
    @objc func update(){
        fetchData()
        tableView.reloadData()
    }
    
    func fetchData(){
        let itemRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        itemRequest.predicate = NSPredicate(format: "done == %@", "false")
        do {
            let results = try managedObjectContext.fetch(itemRequest)
            items = results as! [Item]
            print(items)
        } catch {
            print("\(error)")
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! myCustomCell
        cell.titleLabel.text = items[indexPath.row].name
        cell.beastBtn.tag = indexPath.row
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        managedObjectContext.delete(items[indexPath.row])
        saveContext()
        fetchData()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "edit", sender: indexPath)
    }
    
    func saveButtonPressed(_ newItemName: String, _ indexPath: IndexPath?) {
        if let indexPath = indexPath {
            items[indexPath.row].name = newItemName
        } else {
            print("winner")
            let item = Item(context: managedObjectContext)
            item.name = newItemName
            item.done = "false"
            item.createdAt = Date()
        }
        saveContext()
        fetchData()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
}

class myCustomCell: UITableViewCell {
    
    var items = [Item]()
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let saveContext = (UIApplication.shared.delegate as! AppDelegate).saveContext
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var beastBtn: UIButton!
    
    @IBAction func beastClicked(_ sender: UIButton) {
        let itemRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        itemRequest.predicate = NSPredicate(format: "done == %@", "false")
        do {
            let results = try managedObjectContext.fetch(itemRequest)
            items = results as! [Item]
            print(items)
        } catch {
            print("\(error)")
        }
        items[sender.tag].done = "true"
        saveContext()
    }
}
