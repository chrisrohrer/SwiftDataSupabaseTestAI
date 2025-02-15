//
//  NewProductSheet.swift
//  PraxisBestand
//
//  Created by Christoph Rohrer on 26.10.24.
//

import SwiftUI
import SwiftData


struct NewAutorSheet: View {
    
    @Environment(\.modelContext) private var modelContext

    @State private var autor = Author(name: "", countryID: nil)
    
    var body: some View {
        NewSheet(title: "Neuer Author") {
            Section("Author") {
                TextField("Name", text: $autor.name)
                    .font(.headline)
            }
            
        } action: {
            withAnimation {
                modelContext.insert(autor)
                try? modelContext.save()
            }
        }
    }
}

//#Preview {
//    NewAutorSheet()
//        .modelContainer(MyPreviews.shared.container)
//}
