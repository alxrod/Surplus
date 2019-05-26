//
//  ProfileViewController.swift
//  SurplusApp
//
//  Created by Alex Rodriguez on 5/26/19.
//  Copyright © 2019 Alex Rodriguez. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func authenticateCard(_ sender: Any) {
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


extension ViewController : PLKPlaidLinkViewDelegate {
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
