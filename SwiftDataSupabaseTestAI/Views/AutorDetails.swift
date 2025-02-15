//
//  AutorDetails.swift
//  SwiftDataSupabaseSyncTest
//
//  Created by Christoph Rohrer on 26.01.25.
//

import SwiftUI
import SwiftData

struct AutorDetails: View {
    
    @Bindable var autor: Author
    
    var body: some View {
        
        Form {
            
            TextField("Name", text: $autor.name)
            
            Section("Bücher") {
                List(autor.books) { buch in
                    VStack(alignment: .leading) {
                        Text(buch.title)
                            .font(.headline)
                        Text(buch.author?.name ?? "unbekannt")
                    }
                }
            }
        }
        .navigationTitle(autor.name)
    }
}



//#Preview {
//    AutorDetails(autor: MyPreviews.shared.autor)
//}
