import Foundation
import ParseSwift

struct Comment: ParseObject {
    // Required by ParseObject
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?
    
    // Custom properties
    var text: String?
    var user: User?
    var post: Post?
    var username: String?  // Storing username directly for easy access
    var name: String?      // User's display name
}
