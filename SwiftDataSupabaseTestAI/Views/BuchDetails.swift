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

    var body: some View {
        
        Form {
            
            TextField("Titel", text: $buch.title)

            Picker("Author", selection: $buch.author) {
                Text("kein Author").tag(nil as Author?)
                ForEach(autoren, id: \.self) { autor in
                    Text(autor.name).tag(autor as Author?)
                }
            }

        }
        .navigationTitle(buch.title)
    }
}



//#Preview {
//    AutorDetails(autor: MyPreviews.shared.autor)
//}
