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

    @IBOutlet private weak var noteTitleLabel: UILabel!
    @IBOutlet private weak var dateCreatedImage: UIImageView!
    @IBOutlet private weak var dateCreatedLabel: UILabel!
    @IBOutlet private weak var reminderImage: UIImageView!
    @IBOutlet private weak var reminderLabel: UILabel!

    func configure(note: Note, theme: Theme) {
        let priority = Priority(rawValue: note.priorityRawValue)
        let themeColor = Color(theme: theme).getAccessoryColors(priority: priority!)
        self.backgroundColor = themeColor
        let contrastColor = ContrastColorOf(themeColor, returnFlat: true)
        noteTitleLabel.textColor = contrastColor
        reminderLabel.textColor = contrastColor
        dateCreatedLabel.textColor = contrastColor
        reminderImage.image = reminderImage.image?.withRenderingMode(.alwaysTemplate)
        reminderImage.tintColor = contrastColor
        dateCreatedImage.image = dateCreatedImage.image?.withRenderingMode(.alwaysTemplate)
        dateCreatedImage.tintColor = contrastColor
        noteTitleLabel.text = note.title
        dateCreatedLabel.text = "Created on: \(note.dateCreated.format)"
        if let reminderDate = note.reminderDate {
            reminderLabel.text = "Reminder: \(reminderDate.format)"
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
