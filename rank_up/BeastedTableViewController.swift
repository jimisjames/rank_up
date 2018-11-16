//
//  BeastedTableViewController.swift
//  rank_up
//
//  Created by Jim Lambert on 11/16/18.
//  Copyright © 2018 Jim Lambert. All rights reserved.
//

import UIKit
import CoreData

class BeastedTableViewController: UITableViewController, FormDelegate {
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let saveContext = (UIApplication.shared.delegate as! AppDelegate).saveContext
    
    var items = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchData()
        tableView.reloadData()
    }
    
    func fetchData(){
        let itemRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        itemRequest.predicate = NSPredicate(format: "done == %@", "true")
        do {
            let results = try managedObjectContext.fetch(itemRequest)
            items = results as! [Item]
            print("Winner: ",items)
        } catch {
            print("\(error)")
        }
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "beastCell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row].name
        let formatter = DateFormatter()
        //formatter.dateStyle = .medium
        if let date = items[indexPath.row].createdAt {
            formatter.setLocalizedDateFormatFromTemplate("MMM yy")
            let dateString = formatter.string(for: date)
            formatter.setLocalizedDateFormatFromTemplate("EE")
            let day = formatter.string(for: date)
            cell.detailTextLabel?.text = day! + " " + dateString!
        } else {
            cell.detailTextLabel?.text = ""
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "edit" {
            let navCon = segue.destination as! UINavigationController
            let dest = navCon.topViewController as! AddTableViewController
            dest.delegate = self
            dest.myIndexPath = (sender as! IndexPath)
            dest.currentName = items[(sender as! IndexPath).row].name
        }
    }
    
    func saveButtonPressed(_ newItemName: String, _ indexPath: IndexPath?) {
        items[indexPath!.row].name = newItemName
        saveContext()
        fetchData()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }

}
