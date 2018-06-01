//
//  TextFieldAccessoryView.swift
//  Ofnote
//
//  Created by Matt Deuschle on 5/28/18.
//  Copyright © 2018 Matt Deuschle. All rights reserved.
//

protocol SelectPriorityDelegate {
    func didSelect(priority: Priority)
}

import UIKit
import ChameleonFramework

class TextFieldAccessoryView: UIView {

    var buttonX: CGFloat = 0
    private var theme: Theme!
    var selectPriorityDelegate: SelectPriorityDelegate?

    func configureButtonsWith(theme: Theme) {
        for index in 0..<3 {
            let priorities = Priority.allPriorities
            let frameWidth = self.frame.width / 3
            let buttonFrame = CGRect(x: buttonX,
                                     y: 0,
                                     width: frameWidth,
                                     height: 60)
            let button = UIButton(frame: buttonFrame)
            buttonX = frameWidth + buttonX
            button.backgroundColor = theme.getColorFor(priority: priorities[index])
            button.setTitle(priorities[index].rawValue, for: .normal)
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            self.addSubview(button)
        }
    }

    @objc private func buttonTapped(_ sender: UIButton) {
        guard let delegate = selectPriorityDelegate,
            let label = sender.titleLabel,
            let title = label.text,
            let priority = Priority(rawValue: title) else { return }
        delegate.didSelect(priority: priority)
    }
}


