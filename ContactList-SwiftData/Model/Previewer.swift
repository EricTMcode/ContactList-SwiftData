//
//  Previewer.swift
//  ContactList-SwiftData
//
//  Created by Eric on 02/02/2024.
//

import Foundation
import SwiftData

struct Previewer {
    let container: ModelContainer
    
    init(_ types: [any PersistentModel.Type],
         isStoredInMemoryOnly: Bool = true) {
        let schema = Schema(types)
        let config = ModelConfiguration(isStoredInMemoryOnly: isStoredInMemoryOnly)
        self.container = try! ModelContainer(for: schema, configurations: [config])
    }
}
