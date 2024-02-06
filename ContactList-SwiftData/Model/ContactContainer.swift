//
//  ContactContainer.swift
//  ContactList-SwiftData
//
//  Created by Eric on 06/02/2024.
//

import Foundation
import SwiftData

actor ContactContainer {
    @MainActor
    static func create(shouldCreateDefaults: inout Bool) -> ModelContainer {
        let schema = Schema([Contact.self])
        let configuration = ModelConfiguration()
        let container = try! ModelContainer(for: schema, configurations: configuration)
        if shouldCreateDefaults {
            Category.defaults.forEach { container.mainContext.insert($0) }
            shouldCreateDefaults = false
        }
        return container
    }
}
