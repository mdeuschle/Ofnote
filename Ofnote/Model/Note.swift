//
//  Note.swift
//  Ofnote
//
//  Created by Matt Deuschle on 4/23/18.
//  Copyright © 2018 Matt Deuschle. All rights reserved.
//

import UIKit

class Note: Codable {
    let title: String
    var priority: Priority.RawValue
    let dateCreated = Date()

    init?(title: String, priority: Priority.RawValue) {
        if title == "" {
            return nil
        }
        self.title = title
        self.priority = priority
    }
}
