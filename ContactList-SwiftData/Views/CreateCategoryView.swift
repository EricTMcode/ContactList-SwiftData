//
//  CreateCategoryView.swift
//  ContactList-SwiftData
//
//  Created by Eric on 05/02/2024.
//

import SwiftData
import SwiftUI

struct CreateCategoryView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @State private var title = ""
    
    @Query private var categories: [Category]
    var body: some View {
        List  {
            Section("Category Title") {
                TextField("Enter title here", text: $title)
                
                Button("Add Category") {
                    withAnimation {
                        let category = Category(title: title)
                        modelContext.insert(category)
                        category.contacts = []
                        title = ""
                    }
                }
                .disabled(title.isEmpty)
                
            }
            Section("Categories") {
                if categories.isEmpty {
                    
                } else {
                    ForEach(categories.sorted(by: { $0.title < $1.title })) { category in
                        Text(category.title)
                            .swipeActions {
                                Button(role: .destructive) {
                                    withAnimation {
                                        modelContext.delete(category)
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash.fill")
                                }
                            }
                    }
                }
            }
        }
        .navigationTitle("Add Category")
        .navigationBarTitleDisplayMode(.inline)
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
            }
        }
    }
}

#Preview {
    NavigationStack {
        let preview = Previewer([Contact.self])
        return CreateCategoryView().modelContainer(preview.container)
    }
}
