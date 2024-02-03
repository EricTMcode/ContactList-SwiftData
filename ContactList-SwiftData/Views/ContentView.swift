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
    @State private var contactEdit: Contact?
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                if contacts.isEmpty {
                    ContentUnavailableView("No contacts", systemImage: "person.circle", description: Text("Please add a contact with the + button."))
                } else {
                    List {
                        ForEach(contacts) { contact in
                            NavigationLink(value: contact) {
                                HStack {
                                    if let imageData = contact.photo,
                                       let uiImage = UIImage(data: imageData) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 60, height: 60)
                                            .clipShape(Circle())
                                    } else {
                                        Image(systemName: "person.crop.circle")
                                            .font(.system(size: 55))
                                            .foregroundStyle(.blue)
                                    }
                                    
                                    Text(contact.lastName + " " + contact.firstName)
                                        .font(.body)
                                        .fontWeight(.medium)
                                }
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    withAnimation {
                                        modelContext.delete(contact)
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash.fill")
                                }
                                
                                Button {
                                    contactEdit = contact
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }
                                .tint(.orange)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Contact List")
            .searchable(text: $searchText)
            .navigationDestination(for: Contact.self) { contact in
                ContactView(contact: contact)
            }
            .toolbar {
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
            .fullScreenCover(item: $contactEdit, onDismiss: { contactEdit = nil
            }) { contact in
                NavigationStack {
                    EditContactView(contact: contact)
                        .interactiveDismissDisabled()
                }
            }
        }
    }
}

#Preview {
    let preview = Previewer([Contact.self])
    return ContentView().modelContainer(preview.container)
}
