import Foundation
import SwiftData

@Model
class Category: Codable {
    var id: UUID
    var name: String
    @Relationship(deleteRule: .cascade, inverse: \Book.category) var books: [Book] = []

    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }

    // MARK: - Codable
    enum CodingKeys: String, CodingKey {
        case id, name
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
    }
}
