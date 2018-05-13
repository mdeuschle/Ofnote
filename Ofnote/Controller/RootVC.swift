//
//  ViewController.swift
//  Ofnote
//
//  Created by Matt Deuschle on 4/23/18.
//  Copyright © 2018 Matt Deuschle. All rights reserved.
//

import UIKit

class RootVC: SwipeVC, AddNoteDelegate {

    private var notes = [Note]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        setUpAddNoteButton()
        loadNotes()
    }

    private func loadNotes() {
        notes = Dao().unarchiveNotes() ?? [Note]()
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
        notes.append(note)
        Dao().archive(notes: notes)
        notes.sort { $0.dateCreated > $1.dateCreated }
        tableView.reloadData()
    }

    override func updateModel(at indexPath: IndexPath) {
        notes.remove(at: indexPath.row)
        Dao().archive(notes: notes)
    }

    // TableView DataSource Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let note = notes[indexPath.row]
        cell.textLabel?.text = note.title
        cell.backgroundColor = Priority(rawValue: note.priority)?.color()
        return cell
    }
}














