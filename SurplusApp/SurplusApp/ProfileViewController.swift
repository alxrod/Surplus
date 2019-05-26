//
//  ProfileViewController.swift
//  SurplusApp
//
//  Created by Alex Rodriguez on 5/26/19.
//  Copyright © 2019 Alex Rodriguez. All rights reserved.
//

import UIKit
import LinkKit

class ProfileViewController: UIViewController {
    let pc = PlaidController()
    let defaults = UserDefaults.standard
    var bankingToken: String? {
        didSet {
            guard let pub_token = bankingToken else {return}
            pc.get_access_tok(public_token: pub_token) { (json, error) in
                print("Access token: \(json) error: \(error?.localizedDescription)")
                self.accessToken = json
                
            }
        }
    }
    var accessToken: String? {
        didSet {
            guard let ac_token = accessToken else {return}
            let userID = defaults.object(forKey: "userID")
            
            let fc = FirebaseController()
            guard let uid = userID as? String else {return}
            fc.setBankingToken(bankingToken: ac_token, userID: uid)
            
            pc.get_transcations(access_token: ac_token) { (transactions, error) in
                print("donza")
                print(transactions)
            }
            
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func authenticateCard(_ sender: Any) {
        let linkConfiguration = PLKConfiguration(key: "a5c0d06d29cd2debdc3167acb3457d", env: .sandbox, product: [.auth, .transactions])
        linkConfiguration.clientName = "Surplus"
        let linkViewDelegate = self
        let linkViewController = PLKPlaidLinkViewController(configuration:
            linkConfiguration, delegate: linkViewDelegate)
        if (UI_USER_INTERFACE_IDIOM() == .pad) {
            linkViewController.modalPresentationStyle = .formSheet;
        }
        
        present(linkViewController, animated: true)
        
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


extension ProfileViewController : PLKPlaidLinkViewDelegate {
    func linkViewController(_ linkViewController: PLKPlaidLinkViewController, didSucceedWithPublicToken publicToken: String, metadata: [String : Any]?) {
        dismiss(animated: true) {
            //            store token or whatever
            print("Successfully linked account!\npublicToken: \(publicToken)\nmetadata: \(metadata ?? [:]))")
            self.handleSuccessWithToken(publicToken: publicToken, metadata: metadata)
        }
    }
    
    func linkViewController(_ linkViewController: PLKPlaidLinkViewController, didExitWithError error: Error?, metadata: [String : Any]?) {
        dismiss(animated: true) {
            if let error = error {
                print("Failed to link account due to:\(error.localizedDescription)\nmetadata: \(metadata ?? [:])")
                self.handleError(error: error, metadata: metadata)
            } else {
                print("Plaid link exited with metadata: \(metadata ?? [:])")
                self.handleExitWithMetadata(metadata: metadata)
            }
        }
    }
    
    func linkViewController(_ linkViewController: PLKPlaidLinkViewController, didHandleEvent event: String, metadata: [String : Any]?) {
        print("Link event: \(event)\nmetadata: \(metadata ?? [:])")
    }
    
    func handleError(error: Error, metadata:  [String : Any]?) {
        
    }
    
    func handleSuccessWithToken(publicToken: String, metadata: [String : Any]?) {
        bankingToken = publicToken
        print("here we go finally: \(bankingToken)")
        
    }
    
    func handleExitWithMetadata(metadata: [String : Any]?) {
        
    }
}
