//
//  SupabaseSyncManager.swift
//  SwiftDataSupabaseTestAI
//
//  Created by Christoph Rohrer on 15.02.25.
//

import Foundation
import SwiftData

class SupabaseSyncManager {
    
    let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    /// Fetch all data from Supabase and sync it to SwiftData
    func syncAllData() async {
        do {
            try await fetchAndSyncCountries()
            try await fetchAndSyncCategories()
            try await fetchAndSyncAuthors()
            try await fetchAndSyncBooks()
        } catch {
            print("❌ Sync failed: \(error)")
        }
    }
    
    // MARK: - Fetch and Sync Functions

    private func fetchAndSyncCountries() async throws {
        let countries: [Country] = try await supabase.from("Country").select().execute().value
        for country in countries {
            if let existingCountry = try? context.fetch(FetchDescriptor<Country>()).first(where: { $0.id == country.id }) {
                existingCountry.name = country.name  // Update if needed
            } else {
                context.insert(country)
            }
        }
    }

    private func fetchAndSyncCategories() async throws {
        let categories: [Category] = try await supabase.from("Category").select().execute().value
        for category in categories {
            if let existingCategory = try? context.fetch(FetchDescriptor<Category>()).first(where: { $0.id == category.id }) {
                existingCategory.name = category.name
            } else {
                context.insert(category)
            }
        }
    }

    private func fetchAndSyncAuthors() async throws {
        let authors: [Author] = try await supabase.from("Author").select().execute().value
        for author in authors {
            if let existingAuthor = try? context.fetch(FetchDescriptor<Author>()).first(where: { $0.id == author.id }) {
                existingAuthor.name = author.name
                existingAuthor.countryID = author.countryID
            } else {
                context.insert(author)
            }
        }
    }

    private func fetchAndSyncBooks() async throws {
        let books: [Book] = try await supabase.from("Book").select().execute().value
        for book in books {
            if let existingBook = try? context.fetch(FetchDescriptor<Book>()).first(where: { $0.id == book.id }) {
                existingBook.title = book.title
                existingBook.authorID = book.authorID
                existingBook.categoryID = book.categoryID
            } else {
                context.insert(book)
            }
        }
    }
}
