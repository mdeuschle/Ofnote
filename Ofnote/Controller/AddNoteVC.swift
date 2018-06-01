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

class AddNoteVC: UIViewController, SelectPriorityDelegate {

    @IBOutlet weak var addReminderTextField: UITextField!
    @IBOutlet weak var addNoteTextView: UITextView!
    
    var delegate: AddNoteDelegate?
    var theme: Theme?
    var note: Note?

    private var priority: Priority?
    private var reminderDate: Date?
    private var datePicker: UIDatePicker!
    private var saveBarButtonItem: UIBarButtonItem!

    // MARK: - Lifecycle
    init(delegate: AddNoteDelegate) {
        self.delegate = delegate
        super.init(nibName: "AddNoteVC", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addReminderTextField.delegate = self
        addNoteTextView.delegate = self
        setUpPrioritiesView()
        configureNote()
        configureDoneBarButton()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveNote()
    }

    // MARK: - Private methods
    private func configureNote() {
        guard let note = note else {
            addReminderTextField.text = ""
            addReminderTextField.text = ""
            priority = Priority(rawValue: "Now")
            if let theme = theme {
                view.backgroundColor = theme.color
            }
            return
        }
        priority = Priority(rawValue: note.priorityRawValue)
        addNoteTextView.text = note.title
        if let reminderDate = note.reminderDate {
            self.reminderDate = reminderDate
            addReminderTextField.text = reminderDate.format
        } else {
            addReminderTextField.text = ""
        }
    }

    private func configureDoneBarButton() {
        saveBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(doneBarButtonTapped(_:)))
        saveBarButtonItem.isEnabled = true
        navigationItem.rightBarButtonItem = saveBarButtonItem
    }

    @objc private func doneBarButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }

    private func setUpPrioritiesView() {
        let accessoryFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: 60)
        let accessoryView = TextFieldAccessoryView(frame: accessoryFrame)
        accessoryView.selectPriorityDelegate = self
        accessoryView.configureButtonsWith(theme: theme!)
        addNoteTextView.inputAccessoryView = accessoryView
    }

    private func saveNote() {
        guard let delegate = delegate,
            let textViewText = addNoteTextView.text,
            !textViewText.isEmpty else {
                return
        }
        if let note = note {
            note.title = textViewText
            note.priorityRawValue = priority!.rawValue
            if let reminderDate = self.reminderDate {
                note.reminderDate = reminderDate
                delegate.add(note: note)
            }
        } else {
            if let newNote = Note(title: textViewText) {
                newNote.priorityRawValue = priority!.rawValue
                if let reminderDate = self.reminderDate {
                    newNote.reminderDate = reminderDate
                }
                delegate.add(note: newNote)
            }
        }
    }

    // MARK: - Delegate Methods

    func didSelect(priority: Priority) {
        self.priority = priority
        if let theme = theme {
            view.backgroundColor = theme.color
        }
    }
}

extension AddNoteVC: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == addReminderTextField {
            update(addReminderTextField: textField)
            saveBarButtonItem.isEnabled = false
        }
    }

    private func update(addReminderTextField: UITextField) {
        let cgRect = CGRect(x: 0, y: 0, width: view.frame.width, height: 216)
        datePicker = UIDatePicker(frame: cgRect)
        datePicker.minimumDate = Date()
        addReminderTextField.inputView = datePicker
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped(_:)))
        let spacerButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped(_:)))
        toolBar.setItems([doneButton, spacerButton, cancelButton], animated: false)
        addReminderTextField.inputAccessoryView = toolBar
    }

    @objc private func doneTapped(_ sender: UIBarButtonItem) {
        UserNotification.shared.requestNotificationPermission()
        addReminderTextField.text = datePicker.date.format
        reminderDate = datePicker.date
        addReminderTextField.resignFirstResponder()
        saveBarButtonItem.isEnabled = true
        if addNoteTextView.text == "" {
            addNoteTextView.becomeFirstResponder()
        }
        if let date = reminderDate, let note = note {
            UserNotification.shared.scheduleNotification(with: date, note: note) { success in
                if success {
                    print("Notification Added")
                } else {
                    print("Notification not added")
                }
            }
        }
    }

    @objc private func cancelTapped(_ sender: UIBarButtonItem) {
        saveBarButtonItem.isEnabled = true
        if let note = note, let reminderDate = note.reminderDate {
            addReminderTextField.text = reminderDate.format
        } else {
            addReminderTextField.text = ""
        }
        addReminderTextField.resignFirstResponder()
    }
}

extension AddNoteVC: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        saveBarButtonItem.isEnabled = true
    }
}


