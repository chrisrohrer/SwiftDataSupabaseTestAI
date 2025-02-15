import Foundation
import SwiftData

@Model
class Book: Codable {
    var id: UUID
    var title: String
    var authorID: UUID  // Foreign key for Supabase
    var categoryID: UUID?  // Foreign key for Supabase
    var author: Author?
    var category: Category?

    init(id: UUID = UUID(), title: String, author: Author, category: Category?) {
        self.id = id
        self.title = title
        self.author = author
        self.authorID = author.id
        self.category = category
        self.categoryID = category?.id
    }

    // MARK: - Codable
    enum CodingKeys: String, CodingKey {
        case id, title, authorID, categoryID
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        authorID = try container.decode(UUID.self, forKey: .authorID)
        categoryID = try container.decodeIfPresent(UUID.self, forKey: .categoryID)

        if let context = ModelContextManager.shared.modelContext {
            let authorFetch = FetchDescriptor<Author>(predicate: #Predicate { $0.id == authorID })
            if let fetchedAuthor = try? context.fetch(authorFetch).first {
                author = fetchedAuthor
            }

            if let categoryID = categoryID {
                let categoryFetch = FetchDescriptor<Category>(predicate: #Predicate { $0.id == categoryID })
                if let fetchedCategory = try? context.fetch(categoryFetch).first {
                    category = fetchedCategory
                }
            }
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(authorID, forKey: .authorID)
        try container.encodeIfPresent(category?.id, forKey: .categoryID)
    }
}
