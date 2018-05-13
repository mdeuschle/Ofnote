//
//  ViewController.swift
//  Ofnote
//
//  Created by Matt Deuschle on 4/23/18.
//  Copyright © 2018 Matt Deuschle. All rights reserved.
//

import UIKit

class RootVC: SwipeVC, AddNoteDelegate {

    private var notes: [Note]?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        setUpAddNoteButton()
        loadNotes()
    }

    private func loadNotes() {
        notes = Dao().unarchiveNotes()
        tableView.reloadData()
    }

    private func setUpAddNoteButton() {
        let cgRect = CGRect(x: 0, y: view.bounds.size.height - 50, width: view.frame.width, height: 50)
        let button = UIButton(type: .system)
        button.frame = cgRect
        button.backgroundColor = .darkGray
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Add Item", for: .normal)
        button.addTarget(self, action: #selector(addItemTapped(_:)), for: .touchUpInside)
        navigationController?.view.addSubview(button)
    }

    @objc private func addItemTapped(_ sender: UIButton) {
        let addNoteVC = AddNoteVC(delegate: self)
        addNoteVC.note = nil
        navigationController?.pushViewController(addNoteVC, animated: true)
    }

    // AddNote Delegate Method
    func add(note: Note) {

    }


}














