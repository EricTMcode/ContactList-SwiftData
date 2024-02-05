//
//  Category.swift
//  ContactList-SwiftData
//
//  Created by Eric on 05/02/2024.
//

import Foundation
import SwiftData

@Model
class Category {
    
    @Attribute(.unique)
    var title: String
    
    var contacts: [Contact]?
    
    init(title: String = "") {
        self.title = title
    }
}

extension Category {
    static var defaults: [Category] {
        [
            .init(title: "Family"),
            .init(title: "Friend"),
            .init(title: "Work")
        ]
    }
}
