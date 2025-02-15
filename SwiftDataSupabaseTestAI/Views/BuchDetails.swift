//
//  AutorDetails.swift
//  SwiftDataSupabaseSyncTest
//
//  Created by Christoph Rohrer on 26.01.25.
//

import SwiftUI
import SwiftData

struct BuchDetails: View {
    
    @Bindable var buch: Book
    
    @Query(sort: \Author.name)
    private var autoren: [Author]

    @Query(sort: \Category.name)
    private var kategorien: [Category]

    var body: some View {
        
        Form {
            
            TextField("Titel", text: $buch.title)

            Picker("Autor", selection: $buch.author) {
                Text("kein Author").tag(nil as Author?)
                ForEach(autoren, id: \.self) { autor in
                    Text(autor.name).tag(autor as Author?)
                }
            }

            Picker("Kategorie", selection: $buch.category) {
                Text("keine Kategorie").tag(nil as Category?)
                ForEach(kategorien, id: \.self) { cat in
                    Text(cat.name).tag(cat as Category?)
                }
            }

            Spacer()
        }
        .navigationTitle(buch.title)
        .padding()
    }
}



//#Preview {
//    AutorDetails(autor: MyPreviews.shared.autor)
//}
