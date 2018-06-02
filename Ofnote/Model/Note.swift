//
//  Note.swift
//  Ofnote
//
//  Created by Matt Deuschle on 4/23/18.
//  Copyright © 2018 Matt Deuschle. All rights reserved.
//

import Foundation

struct Note: Codable {
    var title: String
    var priorityRawValue = "Now"
    let dateCreated: Date
    var reminderDate: Date?

    init?(title: String) {
        if title == "" {
            return nil
        }
        self.title = title
        dateCreated = Date()
    }
}
