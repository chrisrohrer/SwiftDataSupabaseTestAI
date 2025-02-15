//
//  AutorenView.swift
//  SwiftDataSupabaseSyncTest
//
//  Created by Christoph Rohrer on 26.01.25.
//

import SwiftUI
import SwiftData

struct BuecherView: View {
    
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var authVM: AuthVM

    @Query(sort: \Book.title)
    private var buecher: [Book]

    @State private var showNewSheet = false

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(buecher) { buch in
                    NavigationLink {
                        BuchDetails(buch: buch)
                        
                    } label: {
                        buchListCell(buch)
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
            .navigationTitle("Bücher")
        } detail: {
            Text("Author auswählen")
        }
        .sheet(isPresented: $showNewSheet) {
            NewBuchSheet()
        }
    }
    
    
    private func buchListCell(_ buch: Book) -> some View {
            VStack(alignment: .leading) {
                Text(buch.title)
                    .font(.headline)
                Text(buch.author?.name ?? "unbekannt")
            }
    }

    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(buecher[index])
            }
        }
    }

}

//#Preview {
//    BuecherView()
//        .modelContainer(MyPreviews.shared.container)
//}
