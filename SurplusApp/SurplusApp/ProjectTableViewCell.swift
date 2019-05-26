//
//  ProjectTableViewCell.swift
//  
//
//  Created by Alex Rodriguez on 5/26/19.
//

import UIKit

class ProjectTableViewCell: UITableViewCell {

    @IBOutlet var project_name: UILabel!
    @IBOutlet var project_descript: UILabel!
    @IBOutlet var project_snapshot: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
