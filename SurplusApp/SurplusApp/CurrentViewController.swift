//
//  CurrentViewController.swift
//  SurplusApp
//
//  Created by Alex Rodriguez on 5/25/19.
//  Copyright © 2019 Alex Rodriguez. All rights reserved.
//

import UIKit
import MultiProgressView

class CurrentViewController: UIViewController, MultiProgressViewDataSource {
    
    let defaults = UserDefaults.standard
    @IBOutlet var projectImage: UIImageView!
    
    @IBOutlet var projectNameField: UILabel!
    @IBOutlet var projectDescriptField: UITextView!
    @IBOutlet var progressView: MultiProgressView!
    
    let fc = FirebaseController()
    var project_name = ""
    var project_description = ""
    var project_goal = Float(0)
    var project_total_contrib = Float(0)
    var user_contrib = Float(0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(profile))
    
        
        progressView.dataSource = self
        progressView.lineCap = .round
        progressView.cornerRadius = 6.25
        
        
        
        
        
        //        self.tabBarController?.addChild(<#T##childController: UIViewController##UIViewController#>)
//        130 400
        
       
        guard let uid = defaults.object(forKey: "userID") as? String else {return}
        fc.getUserProject(userID: uid) { (proj_id) in
            let project_id = proj_id!
            self.fc.getName(projectID: project_id) { (name) in
                self.project_name = name!
                self.projectNameField.text? = self.project_name
            }
            self.fc.getDescription(projectID: project_id) { (descript) in
                self.project_description = descript!
                self.projectDescriptField.text? = self.project_description
            }
            self.fc.getTotalGoal(projectID: project_id) { (total) in
                self.project_goal = total!
                self.fc.getCurrentRaised(projectID: project_id) { (raised) in
                    self.project_total_contrib = raised!
                    self.fc.getTotalContrib(userID: uid) { (raised) in
                        self.user_contrib = raised!
                        print("How big? \(self.user_contrib/self.project_goal)")
                        UIView.animate(withDuration: 0.2) {
                            self.animateSetProgress(self.progressView, firstProgress: self.user_contrib/self.project_goal, secondProgress: self.project_total_contrib/self.project_goal-(self.user_contrib/self.project_goal))
                        }
                        
                    }
                    
                }
                
            }
            
            
        }
        
        
        
        // Do any additional setup after loading the view.
    }
    
    private func animateSetProgress(_ progressView: MultiProgressView, firstProgress: Float, secondProgress: Float) {
        UIView.animate(withDuration: 0.75, delay: 0, options: .curveEaseInOut, animations: {
            progressView.setProgress(section: 0, to: firstProgress)
        }) { _ in
            UIView.animate(withDuration: 0.75, delay: 0, options: .curveEaseInOut, animations: {
                progressView.setProgress(section: 1, to: secondProgress)
            }, completion: nil)
        }
    }

    
    func numberOfSections(in progressView: MultiProgressView) -> Int {
        return 2
    }
    
    func progressView(_ progressView: MultiProgressView, viewForSection section: Int) -> ProgressViewSection {
        
        let sectionView = ProgressViewSection()
        switch section {
        case 0:
            sectionView.backgroundColor = .cyan
        case 1:
            sectionView.backgroundColor = .blue
        default:
            break
        }
        return sectionView
        
    }
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        //        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    @objc func profile() {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController else {return}
        self.navigationController?.pushViewController(vc, animated: true)
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
