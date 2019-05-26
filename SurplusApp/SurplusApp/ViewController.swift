//
//  ViewController.swift
//  SurplusApp
//
//  Created by Alex Rodriguez on 5/25/19.
//  Copyright © 2019 Alex Rodriguez. All rights reserved.
//

import UIKit
import LinkKit
import Stripe

class ViewController: UIViewController {

    var didQueue = false
    let pc = PlaidController()
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
            pc.get_transcations(access_token: ac_token) { (transactions, error) in
                print("donza")
                print(transactions)
            }
            
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded...")
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        if (didQueue == false) {
//            let linkConfiguration = PLKConfiguration(key:
//                "a5c0d06d29cd2debdc3167acb3457d", env: .sandbox, product: [.auth, .transactions])
//            linkConfiguration.clientName = "Surplus"
//            let linkViewDelegate = self
//            let linkViewController = PLKPlaidLinkViewController(configuration:
//                linkConfiguration, delegate: linkViewDelegate)
//            if (UI_USER_INTERFACE_IDIOM() == .pad) {
//                linkViewController.modalPresentationStyle = .formSheet;
//            }
//
//
//            present(linkViewController, animated: true)
//            didQueue = true
//        } else {
//
//
//        }
        
    }
    
    @IBAction func cardInfo(_ sender: Any) {
        let addCardViewController = STPAddCardViewController()
        addCardViewController.delegate = self
        addCardViewController.title = "20.60"
        navigationController?.pushViewController(addCardViewController, animated: true)
    }
    

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


extension ViewController : STPAddCardViewControllerDelegate {
    func handleAddPaymentOptionButtonTapped() {
        // Setup add card view controller
        let addCardViewController = STPAddCardViewController()
        addCardViewController.delegate = self
        
        // Present add card view controller
        let navigationController = UINavigationController(rootViewController: addCardViewController)
        present(navigationController, animated: true)
    }
    
    // MARK: STPAddCardViewControllerDelegate
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        // Dismiss add card view controller
        dismiss(animated: true)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        print("token bitches \(token)")
//        submitTokenToBackend(token, completion: { (error: Error?) in
//            if let error = error {
//                // Show error in add card view controller
//                completion(error)
//            }
//            else {
//                // Notify add card view controller that token creation was handled successfully
//                completion(nil)
//
//                // Dismiss add card view controller
                dismiss(animated: true)
//            }
//        })
    }
}
