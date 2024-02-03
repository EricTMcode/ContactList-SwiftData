//
//  Contact.swift
//  ContactList-SwiftData
//
//  Created by Eric on 02/02/2024.
//

import SwiftData
import Foundation

@Model
class Contact {
    var firstName: String
    var lastName: String
    var company: String
    var emailAddress: String
    var details: String
    
    @Attribute(.externalStorage) var photo: Data?
    
    init(
        firstName: String = "",
        lastName: String = "",
        company: String = "",
        emailAddress: String = "",
        details: String = ""
    ) {
        self.firstName = firstName
        self.lastName = lastName
        self.company = company
        self.emailAddress = emailAddress
        self.details = details
    }
}

extension Contact {
    static var example: Contact {
        .init(firstName: "Eric", lastName: "Doe", company: "Apple", emailAddress: "eric.do@gmail.com", details: "Meet at apple park")
    }
}
