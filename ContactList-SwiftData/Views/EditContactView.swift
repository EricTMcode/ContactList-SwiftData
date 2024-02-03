//
//  EditContactView.swift
//  ContactList-SwiftData
//
//  Created by Eric on 03/02/2024.
//

import PhotosUI
import SwiftData
import SwiftUI

struct EditContactView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @Bindable var contact: Contact
    
    @State private var selectedItem: PhotosPickerItem?
    
    var body: some View {
        Form {
            HStack {
                Spacer()
                VStack {
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
                    
                    PhotosPicker(contact.photo != nil ? "Change Picture" : "Add Picture", selection: $selectedItem, matching: .images)
                }
                Spacer()
            }
            Section("Contact Info") {
                Group {
                    TextField("First Name", text: $contact.firstName)
                    TextField("Last Name", text: $contact.lastName)
                }
                .textContentType(.name)
                
                TextField("Company", text: $contact.company)
            }
            
            Section("Comunication") {
                TextField("Email Address", text: $contact.emailAddress)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
            }
            
            Section("Notes") {
                TextField("Details about this contact", text: $contact.details, axis: .vertical)
            }
        }
        .navigationTitle("Edit Contact")
        .navigationBarTitleDisplayMode(.inline)
        .task(id: selectedItem) {
            if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                contact.photo = data
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button("OK") {
                    dismiss()
                }
                .disabled(contact.firstName.isEmpty)
            }
        }
    }
}

#Preview {
    NavigationStack {
        let preview = Previewer([Contact.self])
        EditContactView(contact: Contact.example).modelContainer(preview.container)
    }
}
