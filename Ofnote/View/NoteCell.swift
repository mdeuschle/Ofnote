//
//  SwipeCell.swift
//  Ofnote
//
//  Created by Matt Deuschle on 5/19/18.
//  Copyright © 2018 Matt Deuschle. All rights reserved.
//

import UIKit
import ChameleonFramework

class NoteCell: UITableViewCell {

    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var reminderImage: UIImageView!
    @IBOutlet weak var reminderLabel: UILabel!

    func configure(note: Note, theme: Theme) {
        let priority = Priority(rawValue: note.priorityRawValue)
        let themeColor = Color(theme: theme).getAccessoryColors(priority: priority!)
        self.backgroundColor = themeColor
        let textColor = ContrastColorOf(themeColor, returnFlat: true)
        noteTitleLabel.textColor = textColor
        reminderLabel.textColor = textColor
        noteTitleLabel.text = note.title
        if let reminderDate = note.reminderDate {
            reminderLabel.text = reminderDate.format
            reminder(isHidden: false)
        } else {
            reminder(isHidden: true)
        }
    }

    private func reminder(isHidden: Bool) {
        reminderLabel.isHidden = isHidden
        reminderImage.isHidden = isHidden
    }
}
