//
//  Priority.swift
//  Ofnote
//
//  Created by Matt Deuschle on 4/28/18.
//  Copyright © 2018 Matt Deuschle. All rights reserved.
//

import UIKit
import ChameleonFramework

enum Priority: String {
    case now = "Now"
    case later = "Later"
    case delegate = "Delegate"

    func getColor(for theme: Theme) -> UIColor {
        let colorsFromScheme = ColorSchemeOf(.triadic,
                                             color: theme.color,
                                             isFlatScheme: true)
        switch self {
        case .later:
            return colorsFromScheme[1]
        case .delegate:
            return colorsFromScheme[2]
        default:
            return colorsFromScheme[0]
        }
    }
}


//enum Priority: String {
//    case now = "Now"
//    case later = "Later"
//    case delegate = "Delegate"
//
//    func color() -> UIColor {
//        switch self {
//        case .later:
//            return .yellow
//        case .delegate:
//            return .blue
//        default:
//            return .red
//        }
//    }
//}

