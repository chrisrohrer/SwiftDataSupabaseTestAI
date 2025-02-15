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
    
    @Query(sort: \Country.name)
    private var countries: [Country]

    var body: some View {
        
        Form {
            
            TextField("Name", text: $autor.name)
            
            Picker("Land", selection: $autor.country) {
                Text("kein Land").tag(nil as Country?)
                ForEach(countries, id: \.self) { land in
                    Text(land.name).tag(land as Country?)
                }
            }

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
        .padding()
    }
}



//#Preview {
//    AutorDetails(autor: MyPreviews.shared.autor)
//}
