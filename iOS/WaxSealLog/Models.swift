import Foundation

struct Seal: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var title: String
    var design: String = ""
    var material: String = ""
    var notes: String = ""
    var dateAdded: Date = Date()
}
