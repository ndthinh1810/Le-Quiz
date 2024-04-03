//
//  FirstViewController.swift
//  Le'Quiz
//

import UIKit

var name = ""

extension UIButton {
    func display() {
        self.layer.cornerRadius = self.frame.height/2
    }
}

class FirstViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var enterName: UITextField!
    @IBOutlet weak var btnStart: UIButton!
    @IBAction func showMainView(_ sender: Any) {
        if let enteredName = enterName.text, enteredName.isEmpty == false {
            name = enteredName
            enterName.resignFirstResponder()
        }
    }
    
    override func viewDidLoad() {
        btnStart.display()
        enterName.layer.cornerRadius = 20
        self.enterName.delegate = self
        self.btnStart.isEnabled = false
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        self.view.addGestureRecognizer(recognizer)
    }
    
    @objc func viewTapped() {
        self.view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.isEmpty == false {
            self.btnStart.isEnabled = true
        } else {
            self.btnStart.isEnabled = false
        }
    }
}
