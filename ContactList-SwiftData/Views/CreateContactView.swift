//
//  CreateContactView.swift
//  ContactList-SwiftData
//
//  Created by Eric on 02/02/2024.
//

import PhotosUI
import SwiftData
import SwiftUI

struct CreateContactView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State var contact = Contact()
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
        .navigationTitle("New Contact")
        .navigationBarTitleDisplayMode(.inline)
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
                    save()
                    dismiss()
                }
                .disabled(contact.firstName.isEmpty)
            }
        }
    }
}

private extension CreateContactView {
    func save() {
        modelContext.insert(contact)
        contact.category = selectedCategory
        selectedCategory?.contacts?.append(contact)
    }
}

#Preview {
    NavigationStack {
        let preview = Previewer([Contact.self])
        return CreateContactView().modelContainer(preview.container)
    }
}
