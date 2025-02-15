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

    @Query(sort: \Country.name)
    private var countries: [Country]

    @State private var autor = Author(name: "", countryID: nil)
    
    var body: some View {
        NewSheet(title: "Neuer Author") {
            Section("Author") {
                TextField("Name", text: $autor.name)
                    .font(.headline)
                
                Picker("Land", selection: $autor.country) {
                    Text("kein Land").tag(nil as Country?)
                    ForEach(countries, id: \.self) { land in
                        Text(land.name).tag(land as Country?)
                    }
                }

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
