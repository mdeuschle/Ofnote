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
    private var filteredNotes = [Note]()
    private var isFiltering = false
    let addNoteButton = UIButton(type: .system)

    //MARK: Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        loadNotes()
        setUpSearchBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.searchController?.searchBar.showsCancelButton = false
        navigationItem.searchController?.searchBar.text = ""
        setUpAddNoteButton()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        addNoteButton.removeFromSuperview()
    }

    //MARK: Private methods
    private func loadNotes() {
        notes = Dao().unarchiveNotes() ?? [Note]()
        tableView.reloadData()
    }

    private func setUpAddNoteButton() {
        let cgRect = CGRect(x: 0, y: view.bounds.size.height - 50, width: view.frame.width, height: 50)
        addNoteButton.frame = cgRect
        addNoteButton.backgroundColor = .darkGray
        addNoteButton.setTitleColor(.white, for: .normal)
        addNoteButton.setTitle("Add Item", for: .normal)
        addNoteButton.addTarget(self, action: #selector(addItemTapped(_:)), for: .touchUpInside)
        navigationController?.view.addSubview(addNoteButton)
    }

    @objc private func addItemTapped(_ sender: UIButton) {
        let addNoteVC = AddNoteVC(delegate: self)
        addNoteVC.note = nil
        navigationController?.pushViewController(addNoteVC, animated: true)
    }

    //MARK: AddNote Delegate Method
    func add(note: Note) {
        if let index = notes.index(where: { $0 === note }) {
            notes.remove(at: index)
        }
        notes.append(note)
        Dao().archive(notes: notes)
        notes.sort { $0.dateCreated > $1.dateCreated }
        tableView.reloadData()
    }

    //MARK: Remove note
    override func updateModel(at indexPath: IndexPath) {
        notes.remove(at: indexPath.row)
        Dao().archive(notes: notes)
    }

    //MARK: TableView DataSource Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredNotes.count : notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let row = indexPath.row
        let note = isFiltering ? filteredNotes[row] : notes[row]
        cell.textLabel?.text = note.title
        cell.backgroundColor = Priority(rawValue: note.priorityRawValue)?.color()
        return cell
    }

    //MARK: TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let note = isFiltering ? filteredNotes[indexPath.row] : notes[indexPath.row]
        let addNoteVC = AddNoteVC(delegate: self)
        addNoteVC.note = note
        navigationController?.pushViewController(addNoteVC, animated: true)
    }
}

extension RootVC: UISearchControllerDelegate, UISearchResultsUpdating {

    private func setUpSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }

    func updateSearchResults(for searchController: UISearchController) {
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        if let text = searchController.searchBar.text, !text.isEmpty {
            isFiltering = true
            filteredNotes = notes.filter {
                $0.title.lowercased().contains(text.lowercased())
            }
        } else {
            isFiltering = false
            filteredNotes = notes
        }
        tableView.reloadData()
    }
}













