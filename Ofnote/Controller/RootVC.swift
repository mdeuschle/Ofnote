//
//  ViewController.swift
//  Ofnote
//
//  Created by Matt Deuschle on 4/23/18.
//  Copyright © 2018 Matt Deuschle. All rights reserved.
//

import UIKit
import ChameleonFramework

class RootVC: UITableViewController, AddNoteDelegate, SelectedThemeDelegate {

    private var notes = [Note]()
    private var filteredNotes = [Note]()
    private var isFiltering = false
    private var theme: Theme! {
        didSet {
            setUpNavigationBar()
            setUpAddNoteButton()
            setUpTableView()
        }
    }
    let addNoteButton = UIButton(type: .system)

    // MARK: - Lifecyle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        loadNotes()
        loadTheme()
        setUpNavigationBar()
        setUpSearchBar()
        setUpBarButtonItemes()
        tableView.rowHeight = 100
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpAddNoteButton()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        addNoteButton.removeFromSuperview()
    }

    // MARK: - Private methods

    private func loadNotes() {
        notes = Dao().unarchiveNotes() ?? [Note]()
        tableView.reloadData()
    }

    private func loadTheme() {
        theme = Dao().unarchiveTheme() ?? Theme(name: "Mint", color: .flatMint)
        tableView.reloadData()
    }

    private func setUpNavigationBar() {
        let contrastColor = ContrastColorOf(theme.color, returnFlat: true)
        guard let navigationController = navigationController else {
                return
        }
        let _navigationBar = navigationController.navigationBar
        _navigationBar.barTintColor = theme.color
        _navigationBar.tintColor = contrastColor
        let textAttributes = [NSAttributedStringKey.foregroundColor: contrastColor]
        _navigationBar.largeTitleTextAttributes = textAttributes
        _navigationBar.titleTextAttributes = textAttributes
        UIApplication.shared.statusBarStyle = contrastColor.hexValue() == "#262626" ? .default : .lightContent
        UIBarButtonItem.appearance(whenContainedInInstancesOf:[UISearchBar.self]).tintColor = contrastColor
    }

    private func setUpBarButtonItemes() {
        let settingsButton = UIBarButtonItem(image: #imageLiteral(resourceName: "settings"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(settingsButtonTapped(_:)))
        navigationItem.rightBarButtonItems = [self.editButtonItem, settingsButton]
    }

    @objc private func settingsButtonTapped(_ sender: UIBarButtonItem) {
        let settingsVC = SettingsVC(nibName: "SettingsVC", bundle: nil)
        settingsVC.selectedThemeDelegate = self
        navigationController?.pushViewController(settingsVC, animated: true)
    }

    private func setUpTableView() {
        tableView.backgroundColor = theme.color
    }

    private func setUpAddNoteButton() {
        let cgRect = CGRect(x: 0, y: view.bounds.size.height - 50, width: view.frame.width, height: 50)
        addNoteButton.frame = cgRect
        addNoteButton.backgroundColor = ComplementaryFlatColorOf(theme.color)
        let fontColor = ContrastColorOf(theme.color, returnFlat: true)
        addNoteButton.setTitleColor(fontColor, for: .normal)
        addNoteButton.setTitle("Add Item", for: .normal)
        addNoteButton.addTarget(self, action: #selector(addItemTapped(_:)), for: .touchUpInside)
        navigationController?.view.addSubview(addNoteButton)
    }

    @objc private func addItemTapped(_ sender: UIButton) {
        let addNoteVC = passToAddNoteVC()
        navigationController?.pushViewController(addNoteVC, animated: true)
    }

    // MARK: - Selected Theme Delegate

    func didSelect(theme: Theme) {
        self.theme = theme
        Dao().archive(theme: theme)
        tableView.reloadData()
    }

    // MARK: - AddNote Delegate Method

    func add(note: Note) {
        if let index = notes.index(where: { $0 === note }) {
            notes.remove(at: index)
        }
        notes.insert(note, at: 0)
        Dao().archive(notes: notes)
        tableView.reloadData()
    }

    // MARK: - Remove note

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            Dao().archive(notes: notes)
        }
    }

    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let noteToMove = notes[sourceIndexPath.row]
        notes.remove(at: sourceIndexPath.row)
        notes.insert(noteToMove, at: destinationIndexPath.row)
        Dao().archive(notes: notes)
    }

    // MARK: - TableView DataSource Methods

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredNotes.count : notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as? NoteCell else {
            return UITableViewCell()
        }
        let row = indexPath.row
        let note = isFiltering ? filteredNotes[row] : notes[row]
        cell.configure(note: note, theme: theme)
        return cell
    }

    // MARK: - TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let note = isFiltering ? filteredNotes[indexPath.row] : notes[indexPath.row]
        let addNoteVC = passToAddNoteVC(note: note)
        navigationController?.pushViewController(addNoteVC, animated: true)
    }

    // MARK: - Setup AddNote VC
    
    private func passToAddNoteVC(note: Note? = nil) -> AddNoteVC {
        let addNoteVC = AddNoteVC(delegate: self)
        addNoteVC.note = note
        addNoteVC.theme = theme
        return addNoteVC
    }
}

extension RootVC: UISearchControllerDelegate, UISearchResultsUpdating {

    private func setUpSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.barStyle = .blackOpaque
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













