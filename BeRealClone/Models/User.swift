//
//  User.swift
//  BeRealClone
//
//  Created by David Castaneda on 3/3/26.
//

import ParseSwift
import Foundation

struct User: ParseUser {
    // ParseObject required
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?

    // ParseUser required
    var username: String?
    var email: String?
    var emailVerified: Bool?
    var password: String?
    var authData: [String: [String: String]?]?
    var lastPostedDate: Date?
}

