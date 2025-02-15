import Foundation
import SwiftData

@MainActor
class SupabaseSyncManager {
    let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }

    /// Fetch all data from Supabase and sync it into SwiftData
    func syncAllData() async {
        do {
            // Fetch data (Runs on background thread)
            let countries = try await fetchCountries()
            let categories = try await fetchCategories()
            let authors = try await fetchAuthors()
            let books = try await fetchBooks()

            // Ensure SwiftData syncs are always done on the main thread
            try await MainActor.run {
                syncCountries(countries)
                syncCategories(categories)
                syncAuthors(authors)
                syncBooks(books)

                try context.save()
            }
        } catch {
            print("❌ Sync failed: \(error)")
        }
    }

    // MARK: - Fetch Functions (Run on Background Thread)

    private func fetchCountries() async throws -> [CountryCodable] {
        return try await supabase.from("Country").select().execute().value
    }

    private func fetchCategories() async throws -> [CategoryCodable] {
        return try await supabase.from("Category").select().execute().value
    }

    private func fetchAuthors() async throws -> [AuthorCodable] {
        return try await supabase.from("Author").select().execute().value
    }

    private func fetchBooks() async throws -> [BookCodable] {
        return try await supabase.from("Book").select().execute().value
    }

    // MARK: - Sync Functions (Run on Main Thread)

    private func syncCountries(_ countries: [CountryCodable]) {
        for country in countries {
            if let existing = try? context.fetch(FetchDescriptor<Country>()).first(where: { $0.id == country.id }) {
                existing.name = country.name
            } else {
                let new = Country(fromCodable: country)
                context.insert(new)
            }
        }
    }

    private func syncCategories(_ categories: [CategoryCodable]) {
        for category in categories {
            if let existing = try? context.fetch(FetchDescriptor<Category>()).first(where: { $0.id == category.id }) {
                existing.name = category.name
            } else {
                let new = Category(fromCodable: category)
                context.insert(new)
            }
        }
    }

    private func syncAuthors(_ authors: [AuthorCodable]) {
        for author in authors {
            if let existing = try? context.fetch(FetchDescriptor<Author>()).first(where: { $0.id == author.id }) {
                existing.name = author.name
                existing.countryID = author.countryID
                
                existing.resolveRelationships(using: context)

            } else {
                let new = Author(fromCodable: author)
                context.insert(new)
                new.resolveRelationships(using: context)
            }
        }
    }

    private func syncBooks(_ books: [BookCodable]) {
        for book in books {
            if let existing = try? context.fetch(FetchDescriptor<Book>()).first(where: { $0.id == book.id }) {
                print("✅ Updating existing book: \(existing.id) - \(existing.title) - \(book.authorID)")
                existing.title = book.title
                existing.authorID = book.authorID
                existing.categoryID = book.categoryID
                
                existing.resolveRelationships(using: context)

            } else {
                print("🆕 Inserting new book: \(book.id) - \(book.title)")
                let new = Book(fromCodable: book)
                context.insert(new)

                new.resolveRelationships(using: context)
            }
        }
    }
}
