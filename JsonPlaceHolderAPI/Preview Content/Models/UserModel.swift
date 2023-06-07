import Foundation

struct User: Codable, Identifiable {
    let id: Int
    var name: String
    var username: String
    var email: String
}
