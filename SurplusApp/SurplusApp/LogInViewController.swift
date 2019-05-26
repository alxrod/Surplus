//
//  LogInViewController.swift
//  SurplusApp
//
//  Created by Alex Rodriguez on 5/25/19.
//  Copyright © 2019 Alex Rodriguez. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    let fb = FirebaseController()
    let defaults = UserDefaults.standard
    var skip = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        let userID = defaults.object(forKey: "userID")
        print(userID)
        if userID != nil{
            self.view.isHidden = true
            print("Just waiting on segue")
            skip = true
            
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (skip) {
            performSegue(withIdentifier: "logInSegue", sender: nil)
        }
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (identifier == "logInSegue") {
            guard let email = emailField.text else {return false}
            guard let password = passwordField.text else {return false}
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
                    guard let strongSelf = self else { return }
                    if let user = user{
                        self?.defaults.set(user.user.uid, forKey: "userID")
                        self?.performSegue(withIdentifier: "logInSegue", sender: nil)
                        return
                    }else{
                        print(error)
                        return
                    }
                    
            }
            
            return false
            
        }
        return true
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

