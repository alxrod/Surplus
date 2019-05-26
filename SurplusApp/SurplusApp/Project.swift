//
//  Project.swift
//  SurplusApp
//
//  Created by Alex Rodriguez on 5/26/19.
//  Copyright © 2019 Alex Rodriguez. All rights reserved.
//

import UIKit

class Project: NSObject {
    var name: String
    var summary: String
    var image: URL
    var id: String
    
    init(name: String, summary: String, image: URL, id: String) {
        self.name = name
        self.summary = summary
        self.image = image
        self.id = id
    }
    
}

