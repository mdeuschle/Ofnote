//
//  ThemeCell.swift
//  Ofnote
//
//  Created by Matt Deuschle on 5/22/18.
//  Copyright © 2018 Matt Deuschle. All rights reserved.
//

import UIKit

class ThemeCell: UITableViewCell {

    @IBOutlet weak var themeNameLabel: UILabel!
    
    func configure(theme: Theme) {
        themeNameLabel.text = theme.name
    }
}
