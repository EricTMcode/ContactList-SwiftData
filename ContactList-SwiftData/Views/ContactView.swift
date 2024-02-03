//
//  ContactView.swift
//  ContactList-SwiftData
//
//  Created by Eric on 03/02/2024.
//

import SwiftData
import SwiftUI

struct ContactView: View {
    @Environment(\.modelContext) var modelContext
    @Query var contacts: [Contact]
    
    @State private var contactEdit: Contact?
    
    var body: some View {
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
                        
                        VStack(alignment: .leading) {
                            Text(contact.lastName + " " + contact.firstName)
                                .font(.body)
                                .fontWeight(.medium)
                            
                            Text(contact.company)
                                .font(.callout)
                        }
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
        .fullScreenCover(item: $contactEdit, onDismiss: { contactEdit = nil
        }) { contact in
            NavigationStack {
                EditContactView(contact: contact)
                    .interactiveDismissDisabled()
            }
        }
    }
    
    init(searchString: String = "", sortOrder: [SortDescriptor<Contact>] = []) {
        _contacts = Query(
            filter: #Predicate { contact in
                if searchString.isEmpty {
                    true
                } else {
                    contact.lastName.localizedStandardContains(searchString)
                    || contact.firstName.localizedStandardContains(searchString)
                    || contact.company.localizedStandardContains(searchString)
                    || contact.emailAddress.localizedStandardContains(searchString)
                    || contact.details.localizedStandardContains(searchString)
                }
            }, sort: sortOrder)
    }
}

#Preview {
    ContactView()
}
