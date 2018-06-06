//
//  Appearance.swift
//  Ofnote
//
//  Created by Matt Deuschle on 6/2/18.
//  Copyright © 2018 Matt Deuschle. All rights reserved.
//

import UIKit
import ChameleonFramework

struct Appearance {
    static let theme: Theme = Dao().unarchiveTheme() ?? Theme(name: "Mint", color: .flatMint)
    static let contrastColor = ContrastColorOf(theme.color, returnFlat: true)
    private init() {}
    static func configure() {
        UINavigationBar.appearance().barTintColor = Appearance.theme.color
        let contrastColor = ContrastColorOf(theme.color, returnFlat: true)
        UINavigationBar.appearance().tintColor = contrastColor
        let textAttributes = [NSAttributedStringKey.foregroundColor: contrastColor]
        UINavigationBar.appearance().largeTitleTextAttributes = textAttributes
        UINavigationBar.appearance().titleTextAttributes = textAttributes
        UIApplication.shared.statusBarStyle = contrastColor.hexValue() == "#262626" ? .default : .lightContent
    }
}



