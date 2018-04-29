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

    func color() -> UIColor {
        switch self {
        case .later:
            return .yellow
        case .delegate:
            return .blue
        default:
            return .red
        }
    }
}
