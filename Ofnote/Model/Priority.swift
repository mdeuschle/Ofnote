//
//  Priority.swift
//  Ofnote
//
//  Created by Matt Deuschle on 4/28/18.
//  Copyright © 2018 Matt Deuschle. All rights reserved.
//

import UIKit

enum Priority: String {
    case now = "Now"
    case later = "Later"
    case delegate = "Delegate"

    static let allPriorities = [now, later, delegate]
}


