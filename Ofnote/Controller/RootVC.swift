//
//  ViewController.swift
//  Ofnote
//
//  Created by Matt Deuschle on 4/23/18.
//  Copyright © 2018 Matt Deuschle. All rights reserved.
//

import UIKit

class RootVC: UIViewController, AddNoteDelegate {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var addNoteToolBar: UIToolbar!

    private var notes = [Note]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }

    func add(note: Note) {
        notes.append(note)
        tableView.reloadData()
    }

    @IBAction func addNoteTapped(_ sender: UIBarButtonItem) {
        let addNoteVC = AddNoteVC(delegate: self)
        addNoteVC.delegate = self
        navigationController?.pushViewController(addNoteVC, animated: true)
    }
}

extension RootVC: UITableViewDataSource {

    //MARK: TableViewDataSource Methods

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "NoteCell")
        let note = notes[indexPath.row]
        cell.textLabel?.text = note.title
        return cell
    }

}






