//
//  ContactList_SwiftDataApp.swift
//  ContactList-SwiftData
//
//  Created by Eric on 02/02/2024.
//

import SwiftData
import SwiftUI

@main
struct ContactList_SwiftDataApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Contact.self)
    }
}
