//
//  Dao.swift
//  Ofnote
//
//  Created by Matt Deuschle on 4/24/18.
//  Copyright © 2018 Matt Deuschle. All rights reserved.
//

import Foundation

struct Dao {

    let notesDirectory: String
    let themeDirectory: String

    init() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                       .userDomainMask,
                                                       true)
        notesDirectory = "\(path[0])/notes"
        themeDirectory = "\(path[0])/theme"
    }

    func archive(notes: [Note]) {
        do {
            let data = try PropertyListEncoder().encode(notes)
            NSKeyedArchiver.archiveRootObject(data, toFile: notesDirectory)
        } catch {
            print(error)
        }
    }

    func archive(theme: Theme) {
        do {
            let data = try PropertyListEncoder().encode(theme)
            NSKeyedArchiver.archiveRootObject(data, toFile: themeDirectory)
        } catch {
            print(error)
        }
    }

    func unarchiveNotes() -> [Note]? {
        guard let data = NSKeyedUnarchiver.unarchiveObject(withFile: notesDirectory) as? Data else {
            return nil
        }
        do {
            let notes = try PropertyListDecoder().decode([Note].self, from: data)
            return notes
        } catch {
            print(error)
            return nil
        }
    }
}
