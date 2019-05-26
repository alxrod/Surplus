//
//  ProfileViewController.swift
//  SurplusApp
//
//  Created by Alex Rodriguez on 5/26/19.
//  Copyright © 2019 Alex Rodriguez. All rights reserved.
//

import UIKit
import LinkKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var userName: UILabel!
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var totalContrib: UILabel!
    
    var transactionsTable = [Transaction]()
    
    
    let pc = PlaidController()
    let defaults = UserDefaults.standard
    let fb = FirebaseController()
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
                if let transactions = transactions{
                    var prices: [Double] = []
                    for (key, value) in transactions{
                        prices.append(value)
                        var transaction = Transaction(name: key, amount: value)
                        self.transactionsTable.append(transaction)
                        
                    }
                    self.tableView.reloadData()
                    var sum = 0.0
                    for price in prices{
//                        let decimal = Double(price - floor(price))
//                        let multiplier = 0.1*floor(decimal / 0.1)
                        sum += price * 0.01
//                        sum = sum + (0.1-(decimal - multiplier))
                    }
                    let userID = self.defaults.object(forKey: "userID") as! String?
                    if let userID = userID{
                        self.fb.updateTotalContrib(userID: userID, donation: Float(sum))
                        self.totalContrib.text = "$\(round(100*sum)/100)"
                    }
                }
            }
            
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let userID = defaults.object(forKey: "userID")
        if let userID = userID{
            fb.getUsername(userID: userID as! String) {(username) in
                print(username)
                if let username = username{
                    self.userName.text = username
                }
            }
            self.userName.text = userID as! String
            fb.getBankingToken(userID: userID as! String) { (token) in
                self.accessToken = token
            }
            
//            
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func updateUsername(sender: UIButton) {
        let userID = defaults.object(forKey: "userID")
        if let userID = userID{
            fb.getUsername(userID: userID as! String){(username) in
                if let username = username{
                    
                }
            }
            
        }
    }
    

    
    @IBAction func logOut(_ sender: Any) {
        print("Trying to sign out")
        fb.signOut()
        
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Transaction", for: indexPath) as? TransactionCell else {
            fatalError("Unable to dequeue ProjectCell")
        }
        let transaction = transactionsTable[indexPath.item]
        cell.nameField.text = transaction.name
        cell.totalField.text = "Total: $\(String(transaction.amount))"
        cell.donationField.text = "Donation: $\(transaction.amount * 0.05)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionsTable.count
    }

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
