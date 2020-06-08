import Foundation

extension Optional where Wrapped == Data {
    var asUtf8String: String? {
        flatMap { String(data: $0, encoding: .utf8) }
    }
}
