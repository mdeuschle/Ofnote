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
    @IBOutlet weak var dateTextField: UITextField!
    
    var delegate: AddNoteDelegate?
    private var datePicker = UIDatePicker()

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
        dateTextField.borderStyle = .none
        dateTextField.tintColor = .clear
        setUpDatePicker()
//        setUpAccessoryView()
    }

    private func setUpAccessoryView() {
        guard let nib = Bundle.main.loadNibNamed("TextFieldAccessoryView", owner: self, options: nil),
            let accessoryView = nib[0] as? UIView else {
                return
        }
        accessoryView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 60)
        addNoteTextField.inputAccessoryView = accessoryView
    }

    private func setUpDatePicker(){
        datePicker.datePickerMode = .date
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        dateTextField.inputAccessoryView = toolbar
        dateTextField.inputView = datePicker
    }

    @objc private func doneButtonTapped(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        dateTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }

    @objc private func cancelButtonTapped(){
        self.view.endEditing(true)
    }

    @IBAction func priorityButtonTapped(_ sender: UIButton) {
        print(sender.titleLabel?.text)
    }
    
    @IBAction func setDateButtonTapped(_ sender: UIButton) {
        dateTextField.becomeFirstResponder()
        print(sender.titleLabel?.text)
    }
}

extension AddNoteVC: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addNoteTextField.resignFirstResponder()
        if let delegate = delegate,
            let textFieldText = addNoteTextField.text,
            let note = Note(title: textFieldText, priority: "Now") {
            delegate.add(note: note)
            navigationController?.popViewController(animated: true)
        }
        return true
    }

}

