//
//  SwipeCell.swift
//  Ofnote
//
//  Created by Matt Deuschle on 5/19/18.
//  Copyright © 2018 Matt Deuschle. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeCell: SwipeTableViewCell {

    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var reminderImage: UIImageView!
    @IBOutlet weak var reminderLabel: UILabel!

    func configure(note: Note) {
        noteTitleLabel.text = note.title
        reminderLabel.text = note.reminderDate?.format
    }
}
