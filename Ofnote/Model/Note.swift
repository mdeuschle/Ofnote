//
//  Note.swift
//  Ofnote
//
//  Created by Matt Deuschle on 4/23/18.
//  Copyright © 2018 Matt Deuschle. All rights reserved.
//

import Foundation

struct Note: Codable {
    let title: String
    let dateCreated = Date()

    init?(title: String) {
        if title == "" {
            return nil
        }
        self.title = title
    }
}
