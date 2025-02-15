//
//  AutorenView.swift
//  SwiftDataSupabaseSyncTest
//
//  Created by Christoph Rohrer on 26.01.25.
//

import SwiftUI
import SwiftData

struct AutorenView: View {
    
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var authVM: AuthVM

    @Query(sort: \Author.name)
    private var autoren: [Author]

    @State private var showNewSheet = false

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(autoren) { autor in
                    NavigationLink {
                        AutorDetails(autor: autor)
                        
                    } label: {
                        autorListCell(autor)
                    }
                }
                .onDelete(perform: deleteItems)
            }

            .toolbar {
                ToolbarItemGroup(placement: .navigation) {
                    Button("Logout") { authVM.signOut() }
                }
                
                ToolbarItem {
                    Button("Add Item", systemImage: "plus") { showNewSheet = true }
                }
            }
            .navigationTitle("Autoren")
        } detail: {
            Text("Author auswählen")
        }
        .sheet(isPresented: $showNewSheet) {
            NewAutorSheet()
        }
    }
    
    
    private func autorListCell(_ autor: Author) -> some View {
            VStack(alignment: .leading) {
                Text(autor.name)
                    .font(.headline)
            }
            .badge(autor.books.count)
    }

    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(autoren[index])
            }
        }
    }

}


//#Preview {
//    AutorenView()
//        .modelContainer(MyPreviews.shared.container)
//}
