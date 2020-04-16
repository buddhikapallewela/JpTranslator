//
//  Extentions.swift
//  JpTranslator
//
//  Created by Buddhika Pallewela on 2020/04/16.
//  Copyright © 2020 Buddhika Pallewela. All rights reserved.
//

import UIKit

/// UIKit Related
extension UITextView {
    func addAccessoryButtons() {
        let textViewToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        textViewToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let clear: UIBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearAction))
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneAction))
        let items = [clear, flexSpace, done]
        textViewToolbar.items = items
        textViewToolbar.sizeToFit()

        self.inputAccessoryView = textViewToolbar
    }
    
    @objc private func doneAction() {
        self.resignFirstResponder()
    }
    
    @objc private func clearAction() {
        self.text = ""
    }

}
