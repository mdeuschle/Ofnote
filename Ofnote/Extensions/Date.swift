//
//  Date.swift
//  Ofnote
//
//  Created by Matt Deuschle on 5/13/18.
//  Copyright © 2018 Matt Deuschle. All rights reserved.
//

import Foundation

extension Date {
    var format: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, MMM dd, h:mm a"
        return formatter.string(from: self)
    }
}

