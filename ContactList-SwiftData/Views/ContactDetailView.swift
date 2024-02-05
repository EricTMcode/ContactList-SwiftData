//
//  ContactDetailView.swift
//  ContactList-SwiftData
//
//  Created by Eric on 03/02/2024.
//

import SwiftUI

struct ContactDetailView: View {
    let contact: Contact
    
    @State private var isShowingEdit = false
    
    var body: some View {
        Form {
            HStack {
                Spacer()
                if let imageData = contact.photo,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 130, height: 130)
                        .clipShape(Circle())
                        .clipped()
                } else {
                    Image(systemName: "person.crop.circle")
                        .font(.system(size: 120))
                        .foregroundStyle(.blue)
                }
                Spacer()
            }
            Section("Contact Info") {
                Text(contact.firstName)
                Text(contact.lastName)
                Text(contact.company)
            }
            
            Section("Comunication") {
                Text(contact.emailAddress)
            }
            
            if let category = contact.category {
                Section("Category") {
                    Text(category.title)
                }
            }
            
            Section("Notes") {
                Text(contact.details)
            }
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(isPresented: $isShowingEdit) {
            NavigationStack {
                EditContactView(contact: contact)
            }
        }
        .toolbar {
            Button("Edit") {
                isShowingEdit.toggle()
            }
        }
    }
}

#Preview {
    let preview = Previewer([Contact.self])
    return ContactDetailView(contact: Contact.example).modelContainer(preview.container)
}
