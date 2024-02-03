//
//  ContentView.swift
//  ContactList-SwiftData
//
//  Created by Eric on 02/02/2024.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query var contacts: [Contact]
    
    @State private var showCreateContact = false
    @State private var sortOrder = [SortDescriptor(\Contact.lastName)]
    @State private var contactEdit: Contact?
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                if contacts.isEmpty {
                    ContentUnavailableView("No contacts", systemImage: "person.circle", description: Text("Please add a contact with the + button."))
                } else {
                    ContactView(searchString: searchText, sortOrder: sortOrder)
                }
            }
            .navigationTitle("Contact List")
            .searchable(text: $searchText)
            .navigationDestination(for: Contact.self) { contact in
                ContactDetailView(contact: contact)
            }
            .toolbar {
                Menu("Sort", systemImage: "ellipsis") {
                    Picker("Sort", selection: $sortOrder) {
                        Text("Name (A-Z)")
                            .tag([SortDescriptor(\Contact.lastName)])
                        Text("Name (Z-A)")
                            .tag([SortDescriptor(\Contact.lastName, order: .reverse)])
                    }
                }
                .symbolVariant(.circle)
                
                Button {
                    showCreateContact.toggle()
                } label: {
                    Label("add a contact", systemImage: "plus")
                }
            }
            .sheet(isPresented: $showCreateContact) {
                NavigationStack {
                    CreateContactView()
                }
            }
        }
    }
}

#Preview {
    let preview = Previewer([Contact.self])
    return ContentView().modelContainer(preview.container)
}
