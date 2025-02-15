//
//  ContentView.swift
//  SwiftDataSupabaseSyncTest
//
//  Created by Christoph Rohrer on 26.01.25.
//

import SwiftUI
import SwiftData
import Realtime


struct ContentView: View {
    
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        TabView {
            AutorenView()
                .tabItem { Label("Autoren", systemImage: "person") }

            BuecherView()
                .tabItem { Label("Bücher", systemImage: "book") }
        }

        .task {
        }
    }
}




//#Preview {
//    ContentView()
//        .modelContainer(MyPreviews.shared.container)
//}
