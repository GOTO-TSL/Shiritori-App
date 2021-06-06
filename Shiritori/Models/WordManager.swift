//
//  GameManager.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/05/04.
//

import Foundation

protocol WordManagerDelegate {
    func didUpdateWord(_ wordManager: WordManager, word: String)
    func didJudgement(_ wordManager: WordManager, judge: Bool)
    func didFailWithError(error: Error)
}

struct WordManager {
    let wordURL = "https://api.datamuse.com/words?max=20&sp="
    var isShiritori = false
    var delegate: WordManagerDelegate?
    
    func judgeWord(InputWord: String) {
        let urlString = "\(wordURL)\(InputWord)"
        performJudgeRequest(with: urlString)
    }
    
    func featchWord(InputWord: String) {
        let initial = InputWord[InputWord.index(before: InputWord.endIndex)]
        let urlString = "\(wordURL)\(initial)*"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let word = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWord(self, word: word)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func performJudgeRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let judge = self.judgeData(safeData) {
                        self.delegate?.didJudgement(self, judge: judge)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ wordData: Data) -> String? {
        let decoder = JSONDecoder()
        do {
            let decodedData: [WordData] = try decoder.decode([WordData].self, from: wordData)
//            print(self.judgement)
//            print(decodedData.count)
            let word = decodedData[Int.random(in: 0...19)].word
            return word
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    func judgeData(_ wordData: Data) -> Bool? {
        let decoder = JSONDecoder()
        do {
            let decodedData: [WordData] = try decoder.decode([WordData].self, from: wordData)
            if decodedData.count == 0 {
                return false
            } else {
                return true
            }
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
