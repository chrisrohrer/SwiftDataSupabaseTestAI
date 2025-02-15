//
//  NewProductSheet.swift
//  PraxisBestand
//
//  Created by Christoph Rohrer on 26.10.24.
//

import SwiftUI
import SwiftData


struct NewBuchSheet: View {
    
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \Author.name)
    private var autoren: [Author]

    @Query(sort: \Category.name)
    private var kategorien: [Category]

    @State private var autor: Author? = nil
    @State private var titel: String = ""
    @State private var kategorie: Category? = nil
    
    var body: some View {
        NewSheet(title: "Neues Book") {
            Section("Book") {
                TextField("Titel", text: $titel)
                    .font(.headline)
                
                Picker("Author", selection: $autor) {
                    Text("kein Author").tag(nil as Author?)
                    ForEach(autoren, id: \.self) { autor in
                        Text(autor.name).tag(autor as Author?)
                    }
                }

                Picker("Kategorie", selection: $kategorie) {
                    Text("keine Kategorie").tag(nil as Category?)
                    ForEach(kategorien, id: \.self) { cat in
                        Text(cat.name).tag(cat as Category?)
                    }
                }
            }
            
        } action: {
            withAnimation {
                let new = Book(title: titel, author: autor!, category: kategorie)
                modelContext.insert(new)
                try? modelContext.save()
            }
        } disabled: {
            autor == nil || titel.isEmpty
        }
    }
}

//#Preview {
//    NewBuchSheet()
//        .modelContainer(MyPreviews.shared.container)
//}
