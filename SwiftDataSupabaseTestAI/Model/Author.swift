import Foundation
import SwiftData

@Model
class Author: Codable {
    var id: UUID
    var name: String
    var countryID: UUID?  // Foreign key for Supabase
    var country: Country?  // Direct SwiftData relation
    @Relationship(deleteRule: .cascade, inverse: \Book.author) var books: [Book] = []

    init(id: UUID = UUID(), name: String, countryID: UUID?) {
        self.id = id
        self.name = name
        self.countryID = countryID
    }

    // MARK: - Codable
    enum CodingKeys: String, CodingKey {
        case id, name, countryID
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        countryID = try container.decodeIfPresent(UUID.self, forKey: .countryID)

        // Resolve related Country
        if let countryID = countryID, let context = ModelContextManager.shared.modelContext {
            let fetchDescriptor = FetchDescriptor<Country>(predicate: #Predicate { $0.id == countryID })
            if let fetchedCountry = try? context.fetch(fetchDescriptor).first {
                country = fetchedCountry
            }
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(country?.id, forKey: .countryID)
    }
}
