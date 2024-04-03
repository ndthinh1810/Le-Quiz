//
//  LastViewController.swift
//  Le'Quiz
//

import UIKit



class LastViewController: UIViewController {

    
    @IBOutlet weak var upperLabel: UILabel!
    @IBOutlet weak var lowerLabel: UILabel!
    @IBOutlet weak var tryAgain: UIButton!
    var message = ""
    
    override func viewDidLoad() {
         super.viewDidLoad()
        tryAgain.display()
        tryAgain.isHidden = true
        if (count <= 5)
        {
            message = "You need to try harder"
            tryAgain.isHidden = false
        }
        else if (count <= 7)
        {
            message = "Good Job!"
        }
        else if (count <= 9)
        {
            message = "Excellent Work!"
        }
        else if (count == 10)
        {
            message = "You are a genius!"
        }
        upperLabel.text = "\(name), your score is"
        
        lowerLabel.text = """
                          \(String(count))/10
                          \(message)
                          """
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func reDo(sender: UIButton) {
        self.dismiss(animated: true)
        count = 0
    }
}
