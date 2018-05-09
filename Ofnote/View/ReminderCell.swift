//
//  ReminderCell.swift
//  Ofnote
//
//  Created by Matt Deuschle on 5/5/18.
//  Copyright © 2018 Matt Deuschle. All rights reserved.
//

import UIKit

class ReminderCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!

    func configure(note: Note) {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, MMM dd, h:mm a"
        dateLabel.text = formatter.string(from: note.dateCreated)
    }
}
