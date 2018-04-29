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
        let accessoryView = Bundle.main.loadNibNamed("TextFieldAccessoryView", owner: self, options: nil)?.first as! UIView
        accessoryView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 60)
        addNoteTextField.inputAccessoryView = accessoryView
    }
    @IBAction func priorityButtonTapped(_ sender: UIButton) {
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

