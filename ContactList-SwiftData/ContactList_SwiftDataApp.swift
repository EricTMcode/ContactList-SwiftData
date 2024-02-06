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
    @AppStorage("isFirstTimeLaunch") private var isFirstTimeLaunch = true
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(ContactContainer.create(shouldCreateDefaults: &isFirstTimeLaunch))
    }
}

