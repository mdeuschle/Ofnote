//
//  Color.swift
//  Ofnote
//
//  Created by Matt Deuschle on 6/2/18.
//  Copyright © 2018 Matt Deuschle. All rights reserved.
//

import UIKit
import ChameleonFramework

struct Color {

    let theme: Theme!
    private(set) var colors = [UIColor]()

    init(theme: Theme) {
        self.theme = theme
        colors = ColorSchemeOf(.analogous,
                                   color: theme.color,
                                   isFlatScheme: true)
    }

    func getAccessoryColors(priority: Priority) -> UIColor {
        switch priority {
        case .now:
            return colors[0]
        case .later:
            return colors[1]
        case .delegate:
            return colors[3]
        }
    }
}
