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
    @IBOutlet weak var addReminderTextField: UITextField!

    var delegate: AddNoteDelegate?
    var note: Note?
    var priority: Priority = .now
    private var datePicker: UIDatePicker!

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
        addReminderTextField.delegate = self
        addNoteTextField.enablesReturnKeyAutomatically = true
        setUpPrioritiesView()
        addNoteTextField.text = note != nil ? note?.title : ""
        setUpBackgroundColor()
    }

    private func setUpBackgroundColor() {
        if let note = note {
            view.backgroundColor = Priority(rawValue: note.priority)?.color()
        } else {
            view.backgroundColor = Priority(rawValue: "Now")?.color()
        }
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
            let newNote = Note(title: textFieldText, priority: priority.rawValue) {
            if let note = note {
                note.title = textFieldText
                note.priority = priority.rawValue
            } else {
                delegate.add(note: newNote)
            }
        }
    }

    @IBAction func priorityButtonTapped(_ sender: UIButton) {
        guard let label = sender.titleLabel,
            let text = label.text else {
                return
        }
        guard let priority = Priority(rawValue: text) else {
            return
        }
        self.priority = priority
        view.backgroundColor = priority.color()
    }
}

extension AddNoteVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveNote()
        addNoteTextField.resignFirstResponder()
        navigationController?.popViewController(animated: true)
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == addReminderTextField {
            update(addReminderTextField: textField)
        }
    }

    private func update(addReminderTextField: UITextField) {
        let cgRect = CGRect(x: 0, y: 0, width: view.frame.width, height: 216)
        datePicker = UIDatePicker(frame: cgRect)
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
        print(sender.title)
    }

    @objc private func cancelTapped(_ sender: UIBarButtonItem) {
        print(sender.title)
    }
}

