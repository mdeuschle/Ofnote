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

