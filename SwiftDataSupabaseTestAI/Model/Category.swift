import Foundation
import SwiftData

@Model
class Category {
    var id: UUID
    var name: String
    @Relationship(deleteRule: .cascade, inverse: \Book.category) var books: [Book] = []

    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }
    
    convenience init(fromCodable category: CategoryCodable) {
        self.init(id: category.id, name: category.name)
    }

}


struct CategoryCodable: Codable {
    var id: UUID
    var name: String
}
