//
//  SwiftDataSupabaseTestAIApp.swift
//  SwiftDataSupabaseTestAI
//
//  Created by Christoph Rohrer on 15.02.25.
//

import SwiftUI
import SwiftData

@main
struct SwiftDataSupabaseTestAIApp: App {
    
    @StateObject var authVM = AuthVM()

    @State private var modelContainer = try! ModelContainer(for: Author.self, Book.self, Category.self, Country.self)

    var body: some Scene {
        WindowGroup {
            AuthView()
                .onAppear {
                    // Save the ModelContext globally
                    ModelContextManager.shared.setContext(modelContainer.mainContext)
                }
        }
        .modelContainer(modelContainer)
        .environmentObject(authVM)
    }
}




class ModelContextManager {
    static let shared = ModelContextManager()
    var modelContext: ModelContext?

    private init() {}

    func setContext(_ context: ModelContext) {
        self.modelContext = context
    }
}
