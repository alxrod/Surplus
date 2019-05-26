 //
//  FirebaseController.swift
//  SurplusApp
//
//  Created by Zack Ankner on 5/25/19.
//  Copyright © 2019 Alex Rodriguez. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class FirebaseController {
    
    var ref: DatabaseReference!
    let defaults = UserDefaults.standard

    func createUser(email: String, password: String){
        
        Auth.auth().createUser(withEmail: email, password: password){authResult, error in
            if let error = error{
                
            }else{
                self.loginUser(email: email, password: password) { (state) in
                    if let state = state{
                        if state == true{
                            let userRef = Database.database().reference(withPath: "users")
                            let userID = self.defaults.object(forKey: "userID") as! String?
                            if let userID = userID{
                                userRef.child("\(userID)/lifetimeContrib").setValue(0)
                                userRef.child("\(userID)/numSuccess").setValue(0)
                                userRef.child("\(userID)/totalContrib").setValue(0)

                            }
                        }
                    }
                }
            }
        }
        
    }
    
    func loginUser(email: String, password: String, completion: @escaping (Bool?) -> Void ){
       
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            guard let strongSelf = self else { return }
            if let user = user{
                self?.defaults.set(user.user.uid, forKey: "userID")
                completion(true)
            }else{
                completion(false)
            }
            
        }
        
    }
    
    func signOut(){
        do {
            try Auth.auth().signOut()
            self.defaults.set(nil, forKey: "userID")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func setUserProject(charityID: String, userID: String){
        ref = Database.database().reference()
        ref.child("users/\(userID)/projectID").setValue(charityID)
    }
    
    func getUserProject(userID: String, completion: @escaping (String?) -> Void){
        
        let postRef = Database.database().reference(withPath: "users/\(userID)")
        postRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let postDict = snapshot.value as? NSDictionary
            let projectID = postDict?["projectID"] as? String
            if let projectID = projectID{
                completion(projectID)
            }else{
                completion("No current project")
            }
        })
    }
    
    func setBankingToken(bankingToken: String, userID: String){
        ref = Database.database().reference()
        ref.child("users/\(userID)/bankingToken").setValue(bankingToken)
    }
    
    func getBankingToken(userID: String, completion: @escaping (String?) -> Void){
        
        let postRef = Database.database().reference(withPath: "users/\(userID)")
        postRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let postDict = snapshot.value as? NSDictionary
            let bankingToken = postDict?["bankingToken"] as? String
            if let bankingToken = bankingToken{
                completion(bankingToken)
            }else{
                completion("No banking token")
            }
        })
    }
    
    func updateCompletedProjects(userID: String, projectID: String){
        let postRef = Database.database().reference(withPath: "users/\(userID)")
        postRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let postDict = snapshot.value as? NSDictionary
            let completedDict = postDict?["completedProjects"] as? [String]
            if let completedDict = completedDict{
                let size = completedDict.count
                postRef.child("completedProjects/\(String(size))").setValue(projectID)
            }
            else{
                postRef.child("completedProjects/0").setValue(projectID)
            }
        })
    }
    
    func getCompletedProjects(userID: String, completion: @escaping ([String]?) -> Void){
        
        let postRef = Database.database().reference(withPath: "users/\(userID)")
        postRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let postDict = snapshot.value as? NSDictionary
            let completedProjects = postDict?["completedProjects"] as? [String]
            if let completedProjects = completedProjects{
                completion(completedProjects)
            }else{
                completion(["No completed projects"])
            }
        })
    }
    
    func updateNumSuccess(userID: String){
        let postRef = Database.database().reference(withPath: "users/\(userID)")
        postRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let postDict = snapshot.value as? NSDictionary
            let curSuccess = postDict?["numSuccess"] as? Int
            if let curSuccess = curSuccess{
                postRef.child("numSuccess").setValue(curSuccess + 1)
            }else{
                postRef.child("numSuccess").setValue(1)
            }
        })
    }
    
    func getNumSuccess(userID: String, completion: @escaping (Int?)-> Void){
        let postRef = Database.database().reference(withPath: "users/\(userID)")
        postRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let postDict = snapshot.value as? NSDictionary
            let numSuccess = postDict?["numSuccess"] as? Int
            if let numSuccess = numSuccess{
                completion(numSuccess)
            }else{
                completion(0)
            }
        })
    }
    
    func updateLifetimeContrib(userID: String, donation: Float){
        let postRef = Database.database().reference(withPath: "users/\(userID)")
        postRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let postDict = snapshot.value as? NSDictionary
            let curTotal = postDict?["lifetimeContrib"] as? Float
            if let curTotal = curTotal{
                postRef.child("lifetimeContrib").setValue(curTotal + donation)
            }
            else{
                postRef.child("lifetimeContrib").setValue(donation)
            }
        })
    }
    
    func getLifetimeContrib(userID: String, completion: @escaping (Float?)-> Void){
        let postRef = Database.database().reference(withPath: "users/\(userID)")
        postRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let postDict = snapshot.value as? NSDictionary
            let totalContrib = postDict?["lifetimeContrib"] as? Float
            if let totalContrib = totalContrib{
                completion((totalContrib*100).rounded()/100)
            }else{
                completion(0.00)
            }
        })
    }
    
    func updateTotalContrib(userID: String, donation: Float){
        let postRef = Database.database().reference(withPath: "users/\(userID)")
        postRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let postDict = snapshot.value as? NSDictionary
            let curTotal = postDict?["totalContrib"] as? Float
            if let curTotal = curTotal{
                postRef.child("totalContrib").setValue(curTotal + donation)
            }
            else{
                postRef.child("totalContrib").setValue(donation)
            }
        })
    }
    
    func getTotalContrib(userID: String, completion: @escaping (Float?)-> Void){
        let postRef = Database.database().reference(withPath: "users/\(userID)")
        postRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let postDict = snapshot.value as? NSDictionary
            let totalContrib = postDict?["totalContrib"] as? Float
            if let totalContrib = totalContrib{
                completion((totalContrib*100).rounded()/100)
            }else{
                completion(0.00)
            }
        })
    }
    
    func createProject(charityID: String, summary: String, description: String, imageURL: String, totalGoal: Float, name: String){
        let projectID = UUID()
        let postRef = Database.database().reference(withPath: "projects/\(projectID)")
        postRef.child("charityID").setValue(charityID)
        postRef.child("summary").setValue(summary)
        postRef.child("description").setValue(description)
        postRef.child("imageURL").setValue(imageURL)
        postRef.child("totalGoal").setValue(totalGoal)
        postRef.child("currentRaised").setValue(0)
        postRef.child("isFunded").setValue(false)
        postRef.child("name").setValue(name)
    }
    
    func updateProjectBackers(projectID: String, backerID: String){
        let postRef = Database.database().reference(withPath: "projects/\(projectID)")
        postRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let postDict = snapshot.value as? NSDictionary
            let currentBackers = postDict?["backers"] as? [String]
            if let currentBackers = currentBackers{
                postRef.child("backers/\(currentBackers.count)").setValue(backerID)
            } else{
                postRef.child("backers/0").setValue(backerID)
            }
        })
    }
    
    func increaseCurrentRaised(projectID: String, donation: Float){
        
        let postRef = Database.database().reference(withPath: "projects/\(projectID)")
        postRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let postDict = snapshot.value as? NSDictionary
            let curRaised = postDict?["currentRaised"] as? Float
            if let curRaised = curRaised{
                postRef.child("currentRaised").setValue(curRaised + donation)
            }
            else{
                postRef.child("currentRaised").setValue(donation)
            }
        })
        
    }
    
    func getName(projectID: String, completion: @escaping (String?)-> Void){
        let postRef = Database.database().reference(withPath: "projects/\(projectID)")
        postRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let postDict = snapshot.value as? NSDictionary
            let name = name?["name"] as? String
            if let name = name{
                completion(name)
            }
            else{
                completion("No project name")
            }
        })
    }
    
    func getSummary(projectID: String, completion: @escaping (String?)-> Void){
        let postRef = Database.database().reference(withPath: "projects/\(projectID)")
        postRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let postDict = snapshot.value as? NSDictionary
            let summary = postDict?["summary"] as? String
            if let summary = summary{
                completion(summary)
            }
            else{
                completion("No project summary")
            }
        })
    }
    
    func getDescription(projectID: String, completion: @escaping (String?)-> Void){
        let postRef = Database.database().reference(withPath: "projects/\(projectID)")
        postRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let postDict = snapshot.value as? NSDictionary
            let description = postDict?["description"] as? String
            if let description = description{
                completion(description)
            }
            else{
                completion("No project description")
            }
        })
    }
    
    func getCurrentRaised(projectID: String, completion: @escaping (Float?)-> Void){
        let postRef = Database.database().reference(withPath: "projects/\(projectID)")
        postRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let postDict = snapshot.value as? NSDictionary
            let currentRaised = postDict?["currentRaised"] as? Float
            if let currentRaised = currentRaised{
                completion((currentRaised*100).rounded()/100)
            }else{
                completion(0.00)
            }
        })
    }
    
    func getTotalGoal(projectID: String, completion: @escaping (Float?)-> Void){
        let postRef = Database.database().reference(withPath: "projects/\(projectID)")
        postRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let postDict = snapshot.value as? NSDictionary
            let totalGoal = postDict?["totalGoal"] as? Float
            if let totalGoal = totalGoal{
                completion((totalGoal*100).rounded()/100)
            }else{
                completion(0.00)
            }
        })
    }
    
    
    func getBackers(projectID: String, completion: @escaping ([String]?) -> Void){
        
        let postRef = Database.database().reference(withPath: "projects/\(projectID)")
        postRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let postDict = snapshot.value as? NSDictionary
            let backers = postDict?["backers"] as? [String]
            if let backers = backers{
                completion(backers)
            }else{
                completion(["No backers"])
            }
        })
    }
    
    func getIsBacked(projectID: String, completion: @escaping (Bool?)-> Void){
        let postRef = Database.database().reference(withPath: "projects/\(projectID)")
        postRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let postDict = snapshot.value as? NSDictionary
            let isBacked = postDict?["isBacked"] as? Bool
            if let isBacked = isBacked{
                completion(isBacked)
            }else{
                completion(false)
            }
        })
    }
    
    func convertProject(projectID: String){
        let activeRef = Database.database().reference(withPath: "projects/\(projectID)")
        let archiveRef = Database.database().reference(withPath: "archived/\(projectID)")
        activeRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let project = snapshot.value as? NSMutableDictionary
            if let project = project{
                project.removeObject(forKey: "description")
                archiveRef.setValue(project)
                activeRef.removeValue()
            }
            else{
                print("fail")
            }
        })
    }
    
    func updateArchiveImage(projectID: String, imageURL: String){
        ref = Database.database().reference()
        ref.child("archived/\(projectID)/imageURL").setValue(imageURL)
    }
    
    func updateNote(projectID: String, note: String){
        ref = Database.database().reference()
        ref.child("archived/\(projectID)/note").setValue(note)
    }
    
    func getNote(projectID: String, completion: @escaping (String?) -> Void){
        
        let postRef = Database.database().reference(withPath: "archived/\(projectID)")
        postRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let postDict = snapshot.value as? NSDictionary
            let note = postDict?["note"] as? String
            if let note = note{
                completion(note)
            }else{
                completion("No note")
            }
        })
    }
    
}


