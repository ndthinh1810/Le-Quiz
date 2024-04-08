//
//  FirstViewController.swift
//  Le'Quiz
//

import UIKit

var name = ""
var currentMode: Mode = .easy

enum Mode: Int {
    case easy = 0
    case medium = 1
    case hard = 2
    
    var name: String {
        switch self {
        case .easy:
            return "easy"
        case .medium:
            return "medium"
        case .hard:
            return "hard"
        }
    }
}

extension UIButton {
    func display() {
        self.layer.cornerRadius = self.frame.height/2
    }
}

class FirstViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var enterName: UITextField!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var btnrank: UIButton!
    @IBOutlet weak var modeLb: UILabel!
    @IBAction func showMainView(_ sender: Any) {
        if let enteredName = enterName.text, enteredName.isEmpty == false {
            name = enteredName
            enterName.resignFirstResponder()
        }
    }
    
    override func viewDidLoad() {
        btnStart.display()
        btnrank.display()
        enterName.layer.cornerRadius = 20
        self.enterName.delegate = self
        self.btnStart.isEnabled = false
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        self.view.addGestureRecognizer(recognizer)
    }
    
    @objc func viewTapped() {
        self.view.endEditing(true)
    }
    
    @IBAction func pickMode(_ sender: UIButton) {
        currentMode = Mode(rawValue: sender.tag) ?? .easy
        modeLb.text = "Difficulty: \(currentMode.name.capitalized)"
    }
    
    @IBAction func showRank(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LastViewController") as? LastViewController
        vc?.showRank = true
        if let vc = vc {
            self.present(vc, animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.isEmpty == false {
            self.btnStart.isEnabled = true
        } else {
            self.btnStart.isEnabled = false
        }
    }
}
