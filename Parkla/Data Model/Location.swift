//
//  Location.swift
//  Parkla
//
//  Created by Ender Güzel on 20.02.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import Foundation
import CoreLocation
import RealmSwift

class Location: Object {
    
    @objc dynamic var latitude: CLLocationDegrees = 0
    @objc dynamic var longitude: CLLocationDegrees = 0
    @objc dynamic var title: String = ""
    @objc dynamic var date: Date = Date()
    
}
