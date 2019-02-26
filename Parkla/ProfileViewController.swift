//
//  ProfileViewController.swift
//  Parkla
//
//  Created by Ender Güzel on 26.02.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit
import RealmSwift

class ProfileViewController: UIViewController {
    
    var realm = try! Realm()
    var locations: Results<Location>!

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var favoriteButtonLabel: UIButton!
    
    @IBAction func favoriteButton(_ sender: UIButton) {
    
    }
    
    @IBAction func infoButton(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        locations = realm.objects(Location.self)
        favoriteButtonLabel.setTitle(String(locations.count), for: .normal)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
