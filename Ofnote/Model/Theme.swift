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

    func getColorFor(priority: Priority) -> UIColor {
        let colors = ColorSchemeOf(.analogous,
                                   color: color,
                                   isFlatScheme: true)
        print(colors.count)
        switch priority {
        case .now:
            return color
        case .later:
            return colors[0]
        case .delegate:
            return colors[4]
        }
    }
}






