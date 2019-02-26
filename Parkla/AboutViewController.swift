//
//  AboutViewController.swift
//  Parkla
//
//  Created by Ender Güzel on 26.02.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var aboutLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let aboutText = "This app have been made to understand how MapKit functions. \n If you would like to give any feedback, please get in touch by e-mail. \n\n e-mail: enderguzel@gmail.com"
        
        aboutLabel.text = aboutText
        
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
