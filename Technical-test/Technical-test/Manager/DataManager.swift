//
//  DataManager.swift
//  Technical-test
//
//  Created by Patrice MIAKASSISSA on 29.04.21.
//

import Foundation


class DataManager {
    
    enum DataManagerError: Error {
        case invalidURL
            case parsingError(Error)

            var localizedDescription: String {
                switch self {
                case .invalidURL:
                    return "Unable to create a valid URL."
                case .parsingError(let error):
                    return "An error occurred while parsing the data: \(error.localizedDescription)"
                }
            }
    }
    
    private let path = "https://www.swissquote.ch/mobile/iphone/Quote.action?formattedList&formatNumbers=true&listType=SMI&addServices=true&updateCounter=true&&s=smi&s=$smi&lastTime=0&&api=2&framework=6.1.1&format=json&locale=en&mobile=iphone&language=en&version=80200.0&formatNumbers=true&mid=5862297638228606086&wl=sq"
    
    func fetchQuotes(completionHandler: @escaping (Result<[Quote], DataManagerError>) -> Void) {
        guard let request = URL(string: path) else {
            completionHandler(.failure(.invalidURL))
            return
        }
                
        let datatask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            
            do {
                let quotes = try JSONDecoder().decode([Quote].self, from: data)
                completionHandler(.success(quotes))
            } catch {
                completionHandler(.failure(.parsingError(error)))
            }
        }
        
        datatask.resume()
    }
    
}
