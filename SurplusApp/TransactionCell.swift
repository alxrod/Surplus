//
//  TransactionCell.swift
//  
//
//  Created by Alex Rodriguez on 5/26/19.
//

import UIKit

class TransactionCell: UITableViewCell {

    @IBOutlet var nameField: UILabel!
    @IBOutlet var totalField: UILabel!
    @IBOutlet var donationField: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
