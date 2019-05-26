//
//  CurrentViewController.swift
//  SurplusApp
//
//  Created by Alex Rodriguez on 5/25/19.
//  Copyright © 2019 Alex Rodriguez. All rights reserved.
//

import UIKit

class CurrentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
//        self.tabBarController?.addChild(<#T##childController: UIViewController##UIViewController#>)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
//        self.tabBarController?.tabBar.isHidden = false
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
