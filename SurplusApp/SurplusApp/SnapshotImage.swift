//
//  SnapshotImage.swift
//  
//
//  Created by Alex Rodriguez on 5/26/19.
//

import UIKit

class SnapshotImage: UIImageView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension UIImageView {
    func load(url: URL) {
//        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
//                    DispatchQueue.main.async {

                        self.image = image
                        print("After rendering height is \(self.bounds.size.height)")
//                    }
                }
//            }
        }
    }
}

