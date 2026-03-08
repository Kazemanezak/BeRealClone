//
//  DateFormatter+Post.swift
//  BeRealClone
//
//  Created by David Castaneda on 3/3/26.
//

import Foundation

extension DateFormatter {
    static let postFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        return df
    }()
}
