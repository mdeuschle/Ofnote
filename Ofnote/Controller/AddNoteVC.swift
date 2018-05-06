//
//  AddNoteVC.swift
//  Ofnote
//
//  Created by Matt Deuschle on 4/26/18.
//  Copyright © 2018 Matt Deuschle. All rights reserved.
//

protocol AddNoteDelegate {
    func add(note: Note)
}

import UIKit

class AddNoteVC: UIViewController {

    @IBOutlet weak var addNoteTextField: UITextField!

    var delegate: AddNoteDelegate?
    var note: Note?
    private var noteSaveTapped = false

    init(delegate: AddNoteDelegate) {
        self.delegate = delegate
        super.init(nibName: "AddNoteVC", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addNoteTextField.delegate = self
        addNoteTextField.enablesReturnKeyAutomatically = true
        setUpPrioritiesView()
        setUpReminderButton()
        addNoteTextField.text = note != nil ? note?.title : ""
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !noteSaveTapped && note == nil {
            saveNote()
        }
    }
    
    private func setUpReminderButton() {
        let button = UIBarButtonItem(title: "Reminder", style: .plain, target: self, action: #selector(reminderButtonTapped(_:)))
        navigationItem.rightBarButtonItem = button
    }

    @objc private func reminderButtonTapped(_ sender: UIBarButtonItem) {
        let reminderVC = ReminderVC(nibName: "ReminderVC", bundle: nil)
        navigationController?.pushViewController(reminderVC, animated: true)
    }

    private func setUpPrioritiesView() {
        guard let nib = Bundle.main.loadNibNamed("TextFieldAccessoryView", owner: self, options: nil),
            let accessoryView = nib[0] as? UIView else {
                return
        }
        accessoryView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 60)
        addNoteTextField.inputAccessoryView = accessoryView
    }

    private func saveNote() {
        if let delegate = delegate,
            let textFieldText = addNoteTextField.text,
            let note = Note(title: textFieldText, priority: "Now") {
            delegate.add(note: note)
        }
    }

    @IBAction func priorityButtonTapped(_ sender: UIButton) {
        print(sender.titleLabel?.text)
    }
}

extension AddNoteVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        noteSaveTapped = true
        addNoteTextField.resignFirstResponder()
        saveNote()
        navigationController?.popViewController(animated: true)
        return true
    }
}

