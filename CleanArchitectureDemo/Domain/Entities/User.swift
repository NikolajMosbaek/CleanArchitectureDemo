import Foundation

struct User {
    let id: String
    let username: String
    let collectorType: CollectorType
}

enum CollectorType {
    case regular
    case ITCollector
}
