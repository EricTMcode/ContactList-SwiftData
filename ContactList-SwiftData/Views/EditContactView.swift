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
    @State private var showCreateCategory = false
    @State private var selectedCategory: Category?
    @Query private var categories: [Category]
    
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
            
            Section("Select a Category") {
                if categories.isEmpty {
                    ContentUnavailableView("No Categories", systemImage: "archivebox")
                } else {
                    Picker("Categories", selection: $selectedCategory) {
                        ForEach(categories.sorted(by: { $0.title < $1.title })) { category in
                            Text(category.title)
                                .tag(category as Category?)
                        }
                        
                        Text("None")
                            .tag(nil as Category?)
                    }
//                    .labelsHidden()
//                    .pickerStyle(.inline)
                }
                
                Button {
                    showCreateCategory.toggle()
                } label: {
                    Text("Add Category")
                        .font(.subheadline)
                }
            }
            
            Section("Notes") {
                TextField("Details about this contact", text: $contact.details, axis: .vertical)
            }
        }
        .navigationTitle("Edit Contact")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            selectedCategory = contact.category
        }
        .sheet(isPresented: $showCreateCategory) {
            NavigationStack {
                CreateCategoryView()
            }
            .presentationDetents([.height(400), .medium])
            .presentationDragIndicator(.automatic)
        }
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
                    contact.category = selectedCategory
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
