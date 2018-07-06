//
//  ViewController.swift
//  simple_keyboard_layout_guide
//
//  Created by iawaknahc on 07/06/2018.
//  Copyright (c) 2018 iawaknahc. All rights reserved.
//

import UIKit
import simple_keyboard_layout_guide

class ViewController: UIViewController {
    private let keyboardHeightView = UIView()
    private let accessoryView = UIView()
    private let textField = UITextField()
    private var keyboardLayoutGuide: KeyboardLayoutGuide!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "HELLO"
        self.keyboardLayoutGuide = KeyboardLayoutGuide(viewController: self)

        self.view.backgroundColor = UIColor.white
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(tap)

        self.keyboardHeightView.translatesAutoresizingMaskIntoConstraints = false
        self.keyboardHeightView.backgroundColor = UIColor.blue

        self.accessoryView.backgroundColor = UIColor.green
        self.accessoryView.bounds = CGRect.init(x: 0, y: 0, width: 0, height: 44)

        self.textField.translatesAutoresizingMaskIntoConstraints = false
        self.textField.inputAccessoryView = self.accessoryView
        self.textField.text = "HELLO"
        self.textField.textAlignment = .center
        self.textField.backgroundColor = UIColor.red

        self.view.addSubview(self.textField)
        self.view.addSubview(self.keyboardHeightView)

        self.textField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.textField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.textField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.textField.bottomAnchor.constraint(equalTo: self.keyboardLayoutGuide.topAnchor).isActive = true

        self.keyboardHeightView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true
        self.keyboardHeightView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.keyboardHeightView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.keyboardHeightView.heightAnchor.constraint(equalTo: self.keyboardLayoutGuide.heightAnchor).isActive = true
    }

    @objc private func onTap(_ gestureRecognizer: UITapGestureRecognizer) {
        self.textField.resignFirstResponder()
    }
}

