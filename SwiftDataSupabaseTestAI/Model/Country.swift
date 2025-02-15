import Foundation
import SwiftData

@Model
class Country {
    var id: UUID
    var name: String
    @Relationship(deleteRule: .nullify, inverse: \Author.country) var authors: [Author] = []

    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }
    
    convenience init(fromCodable country: CountryCodable) {
        self.init(id: country.id, name: country.name)
    }

}


struct CountryCodable: Codable {
    var id: UUID
    var name: String
}
