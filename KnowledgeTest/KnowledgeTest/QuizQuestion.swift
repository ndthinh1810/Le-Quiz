//
//  QuizQuestion.swift
//  Le'Quiz
//

import Foundation

class QuizAPI {
    let apiUrl = "https://opentdb.com/api.php?amount=10&category=17"

    func fetchQuizQuestion(completion: @escaping (Result<QuizAPIResponse, Error>) -> Void) {
        guard let url = URL(string: apiUrl) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(QuizAPIResponse.self, from: data)
                
                if !response.results.isEmpty {
                    completion(.success(response))
                } else {
                    completion(.failure(NSError(domain: "No questions found", code: 0, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

struct QuizAPIResponse: Codable {
    let responseCode: Int
    let results: [QuizQuestionData]
    
    enum CodingKeys: String, CodingKey {
        case responseCode = "response_code"
        case results
    }
}

struct QuizQuestionData: Codable {
    let category: String
    let question: String
    let correctAnswer: String
    let incorrectAnswers: [String]
    
    enum CodingKeys: String, CodingKey {
        case category
        case question
        case correctAnswer = "correct_answer"
        case incorrectAnswers = "incorrect_answers"
    }
}

