//
//  SettingsVC.swift
//  Ofnote
//
//  Created by Matt Deuschle on 5/21/18.
//  Copyright © 2018 Matt Deuschle. All rights reserved.
//

import UIKit
import ChameleonFramework

protocol UpdateThemeDelegate {
    func updateThemeWith(color: UIColor)
}

class SettingsVC: UITableViewController {

    let themes = DataService.instance.getThemes()
    var updateThemeDelegate: UpdateThemeDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ThemeCell", bundle: nil), forCellReuseIdentifier: "themeCell")
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        title = "Pick A Theme"
    }

    // MARK: - tableView data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return themes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "themeCell", for: indexPath) as? ThemeCell else {
            return UITableViewCell()
        }
        let theme = themes[indexPath.row]
        cell.textLabel?.text = theme.name
        cell.backgroundColor = theme.color
        return cell
    }

    // MARK: - tableView delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath),
            let color = cell.backgroundColor else {
                return
        }
        updateThemeDelegate?.updateThemeWith(color: color)
        navigationController?.popViewController(animated: true)
    }
}
