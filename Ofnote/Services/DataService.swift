//
//  DataService.swift
//  Ofnote
//
//  Created by Matt Deuschle on 5/22/18.
//  Copyright © 2018 Matt Deuschle. All rights reserved.
//

import UIKit
import ChameleonFramework

class DataService {
    static let instance = DataService()
    var themes = [
        Theme(name: "Red", color: .flatRed),
        Theme(name: "Orange", color: .flatOrange),
        Theme(name: "Yellow", color: .flatYellow),
        Theme(name: "Sand", color: .flatSand),
        Theme(name: "Navy Blue", color: .flatNavyBlue),
        Theme(name: "Black", color: .flatBlack),
        Theme(name: "Magenta", color: .flatMagenta),
        Theme(name: "Teal", color: .flatTeal),
        Theme(name: "Sky Blue", color: .flatSkyBlue),
        Theme(name: "Green", color: .flatGreen),
        Theme(name: "Mint", color: .flatMint),
        Theme(name: "White", color: .flatWhite),
        Theme(name: "Gray", color: .flatGray),
        Theme(name: "Forest Green", color: .flatForestGreen),
        Theme(name: "Purple", color: .flatPurple),
        Theme(name: "Brown", color: .flatBrown),
        Theme(name: "Plum", color: .flatPlum),
        Theme(name: "Watermelon", color: .flatWatermelon),
        Theme(name: "Lime", color: .flatLime),
        Theme(name: "Pink", color: .flatPink),
        Theme(name: "Maroon", color: .flatMaroon),
        Theme(name: "Coffee", color: .flatCoffee),
        Theme(name: "Powder Blue", color: .flatPowderBlue),
        Theme(name: "Blue", color: .flatBlue)
    ]

    func getThemes() -> [Theme] {
        var sortedThemes = themes.sorted { $0.name < $1.name }
        let randomTheme = Theme(name: "Random", color: .randomFlat)
        if sortedThemes.contains(where: {$0.name == "Random"}) {
            sortedThemes.remove(at: 0)
            sortedThemes.insert(randomTheme, at: 0)
        } else {
            sortedThemes.insert(randomTheme, at: 0)
        }
        return sortedThemes
    }
}
