//
//  Post.swift
//  BeRealClone
//
//  Created by David Castaneda on 3/3/26.
//

import ParseSwift
import Foundation

struct Post: ParseObject {
    // ParseObject required
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?

    // Custom properties (must be optional)
    var caption: String?
    var user: User?
    var imageFile: ParseFile?
    var authorUsername: String?
    
    var photoTakenAt: Date?
    var latitude: Double?
    var longitude: Double?
}

