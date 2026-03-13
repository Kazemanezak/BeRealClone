//
//  Comment.swift
//  BeRealClone
//
//  Created by David Castaneda on 3/13/26.
//

import Foundation
import ParseSwift

struct Comment: ParseObject {
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?

    var text: String?

    // pointers
    var user: Pointer<User>?
    var post: Pointer<Post>?

    // fallback username
    var authorUsername: String?
}
