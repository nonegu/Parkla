//
//  SecondViewController.swift
//  Parkla
//
//  Created by Ender Güzel on 20.02.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit
import RealmSwift

class FavoriteTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var realm = try! Realm()
    var locations: Results<Location>!

    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.navigationBar.prefersLargeTitles = true
        locations = realm.objects(Location.self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        locations = realm.objects(Location.self)
        table.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        
        if locations != nil {
            
            cell.textLabel?.text = locations[indexPath.row].title
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: { (action, indexPath) in
            let alert = UIAlertController(title: "", message: "Edit location name", preferredStyle: .alert)
            alert.addTextField(configurationHandler: { (textField) in
                textField.text = self.locations[indexPath.row].title
            })
            alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { (updateAction) in
                
                try! self.realm.write {
                    self.locations[indexPath.row].title = alert.textFields!.first!.text!
                }
                self.table.reloadRows(at: [indexPath], with: .fade)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: false)
        })
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            self.deleteRealm(title: self.locations[indexPath.row].title)
            tableView.reloadData()
        })
        
        return [deleteAction, editAction]
    }
    
    func deleteRealm(title: String) {
        
        let locationToDelete = realm.objects(Location.self).filter("title = %@", title)
        
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(locationToDelete)
            }
        } catch {
            print("Error deleting realm, \(error)")
        }
        
    }
    

}

