//
//  ReminderVC.swift
//  Ofnote
//
//  Created by Matt Deuschle on 5/5/18.
//  Copyright © 2018 Matt Deuschle. All rights reserved.
//


import UIKit

class ReminderVC: UIViewController {

    @IBOutlet private weak var reminderTableView: UITableView!
    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var datePickerHeight: NSLayoutConstraint!

    var note: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reminderTableView.dataSource = self
        reminderTableView.delegate = self
        let nib = UINib(nibName: "ReminderCell", bundle: nil)
        reminderTableView.register(nib, forCellReuseIdentifier: "ReminderCell")
    }
}

extension ReminderVC: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell", for: indexPath) as? ReminderCell,
            let note = note else {
                return UITableViewCell()
        }
        cell.configure(note: note)
        return cell
    }
}

extension ReminderVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

