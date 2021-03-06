//
//  Translator.swift
//  Flashcards
//
//  Created by Николай on 20.01.2022.
//

import Foundation

class Translator {
        
    // MARK: - Properties
    
    static let shared = Translator()
    
    private init() {}
    
    // MARK: - Public methods
    
    func request(query: String, completion: @escaping (Result<String, NetworkError>) -> Void)  {
    
        guard let encodingQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let postData = postParameters(query: query) else { return }
        let queryParameters = queryParameters(query: encodingQuery)
        let url = url(queryItems: queryParameters)
       
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = queryHeaders()
        request.httpMethod = "POST"
        request.httpBody = postData
        
        URLSession.shared.dataTask(with: request) { (data, _, _) in
           
            if data == nil {
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }
            
            let translation = JSONWorker.shared.decodeJSON(type: [TranslationResult].self, from: data)
                        
            guard let translation = translation else {
                DispatchQueue.main.async {
                    completion(.failure(.decodingError))
                }
                return
            }
            
            let result = translation.first?.translations.first?.text ?? ""
                    
            DispatchQueue.main.async {
                completion(.success(result))
            }
            
        }.resume()
        
    }
    
    // MARK: - Private methods
    
    private func postParameters(query: String) -> Data? {
        let parameters = [["Text": query]]
        let result = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        return result
    }
    
    private func queryHeaders() -> [String: String] {
        let headers = [
            "content-type": "application/json",
            "x-rapidapi-host": "microsoft-translator-text.p.rapidapi.com",
            "x-rapidapi-key": "869e909059msheb8d4e402897094p1f9768jsnfefd507548cd"
        ]
        return headers
    }
    
    private func queryParameters(query: String) -> [URLQueryItem] {

        let parameters = [
            URLQueryItem(name: "to", value: "ru"),
            URLQueryItem(name: "api-version", value: "3.0"),
            URLQueryItem(name: "profanityAction", value: "NoAction"),
            URLQueryItem(name: "textType", value: "plain")
        ]
        
        return parameters
    }
    
    private func url(queryItems: [URLQueryItem]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "microsoft-translator-text.p.rapidapi.com"
        components.path = "/translate"
        components.queryItems = queryItems
        return components.url!
    }
    
}

