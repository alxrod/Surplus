//
//  ArchiveTableViewController.swift
//  SurplusApp
//
//  Created by Alex Rodriguez on 5/25/19.
//  Copyright © 2019 Alex Rodriguez. All rights reserved.
//

import UIKit

class ArchiveTableViewController: UITableViewController {
    
    var projects = [Project]()
    let defaults = UserDefaults.standard
    let fc = FirebaseController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.backgroundColor = UIColor(hex:"587498")
        self.tabBarController?.tabBar.isTranslucent = false

        guard let uid = defaults.object(forKey: "userID") as? String else {return}
            print("Starting")
            fc.getCompletedProjects(userID: uid) { (proj_ids) in
                if let project_ids = proj_ids as? [String] {
                    for proj_id in project_ids {
                        print("Iterating")
                        self.fc.getArchiveProject(projectID: proj_id) { (projectData) in
                            print(projectData)
                            if let proj = projectData {
                                print("final stage")
                                guard let name = proj["name"] as? String else {return}
                                guard let description = proj["summary"] as? String else {return}
                                guard let urlS = proj["imageURL"] as? String else {return}
                                guard let url = URL(string: urlS) else {return}
                                var newProject = Project(name: name, summary: description, image: url)
                                print("About to append \(newProject)")
                                self.projects.append(newProject)
                                print("after: \(self.projects[0].name)")
                                self.tableView.reloadData()
                                
                            }
                        }
                        
                    }
                
                
                }
        }

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print ("this many rows: \(projects)")
        return projects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Hellooo?")
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Project", for: indexPath) as? ProjectTableViewCell else {
            fatalError("Unable to dequeue ProjectCell")
        }
        print("trying to render some cells!")
        let project = projects[indexPath.item]
        cell.project_name.text = project.name
        cell.project_descript.text = project.summary
        cell.imageView?.load(url: project.image)
        print(cell.project_name, "predicted")

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
