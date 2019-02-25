//
//  SecondViewController.swift
//  Parkla
//
//  Created by Ender Güzel on 20.02.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit
import RealmSwift

class FavouriteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}

