import Foundation
import ParseSwift

struct Comment: ParseObject {
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?

    var post: Pointer<Post>?
    var user: User?
    var text: String?
    var username: String?
    var name: String?

    init(post: Post, text: String, user: User?) {
        self.post = post.toPointer()
        self.text = text
        self.user = user
        self.username = user?.username
        self.name = user?.name
    }
}
