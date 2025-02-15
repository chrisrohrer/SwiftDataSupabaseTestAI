import Foundation
import SwiftData

@Model
class Author {
    var id: UUID
    var name: String
    var countryID: UUID?  // Foreign key for Supabase
    var country: Country?  // Direct SwiftData relation
    @Relationship(deleteRule: .cascade, inverse: \Book.author) var books: [Book] = []

    init(id: UUID = UUID(), name: String, country: Country?) {
        self.id = id
        self.name = name
        self.country = country
        self.countryID = country?.id
    }

    init(id: UUID = UUID(), name: String, countryID: UUID?) {
        self.id = id
        self.name = name
        self.countryID = countryID
    }

    convenience init(fromCodable author: AuthorCodable) {
        self.init(id: author.id, name: author.name, countryID: author.countryID)
    }
    
    
    /// Resolve relationships manually after decoding
    func resolveRelationships(using context: ModelContext) {
        if let countryID = countryID {
            let fetchDescriptor = FetchDescriptor<Country>(predicate: #Predicate { $0.id == countryID })
            if let fetchedCountry = try? context.fetch(fetchDescriptor).first {
                self.country = fetchedCountry
            }
        }
    }
}



struct AuthorCodable: Codable {
    let id: UUID
    let name: String
    let countryID: UUID?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case countryID = "country_id"
    }
}
