//
//  DetailViewController.swift
//  SurplusApp
//
//  Created by Alex Rodriguez on 5/26/19.
//  Copyright © 2019 Alex Rodriguez. All rights reserved.
//

import Kingfisher
import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var projectNameField: UILabel!
    @IBOutlet var projectGoalField: UILabel!
    @IBOutlet var projectRaisedField: UILabel!
    @IBOutlet var projectDescriptionField: UITextView!
    
    @IBOutlet var projectImg: UIImageView!
    let fc = FirebaseController()
    
    var project_id: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        projectImg.layer.borderWidth = 1.0
        projectImg.layer.masksToBounds = false
        projectImg.layer.borderColor = UIColor.white.cgColor
        projectImg.layer.cornerRadius = projectImg.frame.size.width / 1.97
        projectImg.clipsToBounds = true
        
        if let project = project_id {
            self.fc.getArchiveProject(projectID: project) { (projectData) in
                print(projectData)
                if let proj = projectData {
                    print("final stage")
                    print(proj)
                    guard let name = proj["name"] as? String else {return}
                    guard let description = proj["note"] as? String else {return}
                    guard let urlS = proj["imageURL"] as? String else {return}
                    guard let currentRaised = proj["currentRaised"] as? Float else {
                        print("Failed on raise cast")
                        return
                        
                    }
                    guard let goal = proj["totalGoal"] as? Float else {
                        print("Failed on raise goal")
                        return
                        
                    }
                    guard let url = URL(string: urlS) else {return}
                    
                    self.projectImg.kf.setImage(with: url)
                    self.projectNameField.text = name
                    self.projectDescriptionField.text = description
                    self.projectGoalField.text = "Goal: $\(goal)"
                    self.projectRaisedField.text = "Raised: $\(currentRaised)"
                    print("Finished strage")
                    
                    
                }
            }
        }

        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
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
