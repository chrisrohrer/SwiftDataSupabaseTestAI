import Foundation
import SwiftData

@Model
class Book {
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

    init(id: UUID = UUID(), title: String, authorID: UUID, categoryID: UUID?) {
        self.id = id
        self.title = title
        self.authorID = authorID
        self.categoryID = categoryID
    }

    convenience init(fromCodable book: BookCodable) {
        self.init(id: book.id, title: book.title, authorID: book.authorID , categoryID: book.categoryID)
    }

    
    /// Manually resolve relationships using the correct context
    func resolveRelationships(using context: ModelContext) {
        
        let authorFetch = FetchDescriptor<Author>(predicate: #Predicate { $0.id == authorID })
        if let fetchedAuthor = try? context.fetch(authorFetch).first {
            self.author = fetchedAuthor
        }
        
        if let categoryID = categoryID {
            let categoryFetch = FetchDescriptor<Category>(predicate: #Predicate { $0.id == categoryID })
            if let fetchedCategory = try? context.fetch(categoryFetch).first {
                self.category = fetchedCategory
            }
        }
    }
}



struct BookCodable: Codable {
    let id: UUID
    let title: String
    let authorID: UUID
    let categoryID: UUID?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case authorID = "author_id"
        case categoryID = "category_id"
    }
}
