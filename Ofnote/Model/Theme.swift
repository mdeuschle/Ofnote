//
//  Theme.swift
//  Ofnote
//
//  Created by Matt Deuschle on 5/22/18.
//  Copyright © 2018 Matt Deuschle. All rights reserved.
//

import UIKit
import ChameleonFramework

struct Theme {
    private(set) var name: String
    private(set) var color: UIColor

    init(name: String, color: UIColor) {
        self.name = name
        self.color = color
    }
//
//    func getColorFor(priority: Priority) -> UIColor {
//        let colors = ColorSchemeOf(.analogous,
//                                   color: color,
//                                   isFlatScheme: true)
//        switch priority {
//        case .now:
//            return color
//        case .later:
//            return colors[0]
//        case .delegate:
//            return colors[4]
//        }
//    }
}

extension Theme: Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case color
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        let colorData = try container.decode(Data.self, forKey: .color)
        color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor ?? .black
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        let colorData = NSKeyedArchiver.archivedData(withRootObject: color)
        try container.encode(colorData, forKey: .color)
    }
}





