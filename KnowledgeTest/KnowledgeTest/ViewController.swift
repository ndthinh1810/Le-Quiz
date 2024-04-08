//
//  ViewController.swift
//  KnowledgeTest
//
//  Created by Jagtar Singh on 2018-07-19.
//  Copyright © 2018 Jagtar Singh. All rights reserved.
//

import UIKit

var count = 0

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var quesLabel: UILabel!
    @IBOutlet weak var answerTableView: UITableView!
    @IBOutlet weak var lastScreen: UIButton!
    @IBOutlet weak var close: UIButton!
    @IBOutlet weak var finImage: UIImageView!
    var questions: [QuizQuestionData] = []
    var currentQuestion: QuizQuestionData? = nil
    var answers: [String] = []
    var queCnt = 0
    override func viewDidLoad() {
        lastScreen.isHidden = true
        close.isHidden = true
        finImage.isHidden = true
        super.viewDidLoad()
        self.setupTableView()
        self.getData()
        lastScreen.display()
        close.display()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setupTableView() {
        self.answerTableView.delegate = self
        self.answerTableView.dataSource = self
    }
    
    func getData() {
        let quizAPI = QuizAPI()
        quizAPI.fetchQuizQuestion { result in
            switch result {
            case .success(let question):
                self.questions = question.results
                DispatchQueue.main.async {
                    self.nextQuestion()
                }
            case .failure(let error):
                print("Error fetching quiz question: \(error)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let ques = self.currentQuestion {
            return ques.incorrectAnswers.count + 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = answers[indexPath.row].replacingOccurrences(of: "&quot;", with: "'")
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if answers[indexPath.row] == self.currentQuestion?.correctAnswer {
            count += 1
        }
        queCnt += 1
        self.nextQuestion()
    }
    
    func saveRecordToUserDefaults(record: Record, forKey key: String) {
        var currentData = RecordManager.shared.getData(key: key)
        currentData.removeAll(where: { $0.name == record.name })
        currentData.append(record)
        RecordManager.shared.saveData(key: key, data: currentData)
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        self.dismiss(animated: true)
        count = 0
    }
    
    func nextQuestion() {
        if queCnt >= self.questions.count {
            lastScreen.isHidden = false
            close.isHidden = false
            finImage.isHidden = false
            self.answerTableView.isHidden = true
            quesLabel.text = "Finnnnn!"
            saveRecordToUserDefaults(record: Record(point: count, name: name), forKey: currentMode.name)
        } else {
            self.answers = []
            self.currentQuestion = self.questions[queCnt]
            self.quesLabel.text = self.currentQuestion?.question.replacingOccurrences(of: "&quot;", with: "'")
            answers = currentQuestion?.incorrectAnswers ?? []
            answers.append(currentQuestion?.correctAnswer ?? "")
            answers.shuffle()
        }
        self.answerTableView.reloadData()
    }
}

struct Record: Codable {
    var point: Int
    var name: String
    
    init(point: Int, name: String) {
        self.name = name
        self.point = point
    }
}

class RecordManager: NSObject {
    
    @objc static let shared = RecordManager()
    
    override init() {
    }
    private let hard = "hard"
    private let medium = "medium"
    private let easy = "easy"
    var easyData: [Record] {
        set(value) {
            let jsonEncoder = JSONEncoder()
            guard let data = try? jsonEncoder.encode(value) else {
                return
            }
            UserDefaults.standard.set(data, forKey: easy)
        }
        get {
            let jsonDecoder = JSONDecoder()
            guard let data = UserDefaults.standard.data(forKey: easy),
                  let recordData = try? jsonDecoder.decode([Record].self, from: data) else {
                return []
            }
            return recordData
        }
    }
    
    var mediumData: [Record] {
        set(value) {
            let jsonEncoder = JSONEncoder()
            guard let data = try? jsonEncoder.encode(value) else {
                return
            }
            UserDefaults.standard.set(data, forKey: medium)
        }
        get {
            let jsonDecoder = JSONDecoder()
            guard let data = UserDefaults.standard.data(forKey: medium),
                  let recordData = try? jsonDecoder.decode([Record].self, from: data) else {
                return []
            }
            return recordData
        }
    }
    
    var hardData: [Record] {
        set(value) {
            let jsonEncoder = JSONEncoder()
            guard let data = try? jsonEncoder.encode(value) else {
                return
            }
            UserDefaults.standard.set(data, forKey: hard)
        }
        get {
            let jsonDecoder = JSONDecoder()
            guard let data = UserDefaults.standard.data(forKey: hard),
                  let recordData = try? jsonDecoder.decode([Record].self, from: data) else {
                return []
            }
            return recordData
        }
    }
    
    func getData(key: String) -> [Record] {
        if key == hard {
            return hardData
        } else if key == medium {
            return mediumData
        } else {
            return easyData
        }
    }
    
    func saveData(key: String, data: [Record]) {
        if key == hard {
            self.hardData = data
        } else if key == medium {
            self.mediumData = data
        } else {
            self.easyData = data
        }
    }
}
