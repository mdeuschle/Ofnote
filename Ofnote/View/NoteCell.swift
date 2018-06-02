//
//  SwipeCell.swift
//  Ofnote
//
//  Created by Matt Deuschle on 5/19/18.
//  Copyright © 2018 Matt Deuschle. All rights reserved.
//

import UIKit

class NoteCell: UITableViewCell {

    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var reminderImage: UIImageView!
    @IBOutlet weak var reminderLabel: UILabel!

    func configure(note: Note, theme: Theme) {
        let priority = Priority(rawValue: note.priorityRawValue)
        self.backgroundColor = theme.getColorFor(priority: priority!)
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
