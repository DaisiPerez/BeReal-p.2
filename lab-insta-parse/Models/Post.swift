import Foundation
import ParseSwift

struct Post: ParseObject {
    // These are required by ParseObject
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?

    // Your own custom properties.
    var caption: String?
    var user: User?
    var imageFile: ParseFile?
    
    // Location properties
    var country: String?
    var state: String?
    var city: String?
    
    // Comments array - stores relation to comments
    var comments: [Comment]?
    var commentCount: Int?
}
