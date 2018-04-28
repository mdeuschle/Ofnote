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

    // MARK: Private Properties
    private var notes = [Note]()
    private var filteredNotes = [Note]()
    private var isFiltering = false

    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        notes = Dao().unarchiveNotes() ?? [Note]()
        configureSearchBar()
    }

    func add(note: Note) {
        notes.append(note)
        Dao().archive(notes: notes)
        tableView.reloadData()
    }

    // MARK: Actions
    @IBAction func addNoteTapped(_ sender: UIBarButtonItem) {
        let addNoteVC = AddNoteVC(delegate: self)
        addNoteVC.delegate = self
        navigationController?.pushViewController(addNoteVC, animated: true)
    }
}

extension RootVC: UITableViewDataSource {

    //MARK: TableViewDataSource
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredNotes.count : notes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "NoteCell")
        let note = isFiltering ? filteredNotes[indexPath.row] : notes[indexPath.row]
        cell.textLabel?.text = note.title
        return cell
    }
}

extension RootVC: UISearchControllerDelegate, UISearchResultsUpdating {

    private func configureSearchBar() {
        let searchBarController = UISearchController(searchResultsController: nil)
        searchBarController.delegate = self
        searchBarController.searchResultsUpdater = self
        navigationItem.searchController = searchBarController
    }

    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, !text.isEmpty {
            isFiltering = true
            filteredNotes = notes.filter { $0.title.lowercased().contains(text.lowercased()) }
        } else {
            isFiltering = false
            filteredNotes = notes
        }
        tableView.reloadData()
    }
}














