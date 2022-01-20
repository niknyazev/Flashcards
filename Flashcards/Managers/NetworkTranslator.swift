//
//  NetworkTranslator.swift
//  Flashcards
//
//  Created by Николай on 20.01.2022.
//

import Foundation

class NetworkTranslator {
    
    static let shared = NetworkTranslator()
    
    private init() {}
    
    func request(query: String, completion: @escaping (String, Error?) -> Void)  {
    
        guard let encodingQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        let queryParameters = queryParameters(query: encodingQuery)
        let url = url(queryItems: queryParameters)
       
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = queryHeaders()
        request.httpMethod = "get"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
           
            let translation = JSONWorker.shared.decodeJSON(type: TranslationResult.self, from: data)
            let result = translation?.result ?? ""
            
            DispatchQueue.main.async {
                completion(result, error)
            }
        }.resume()
        
    }
    
    private func queryHeaders() -> [String: String] {
        var headers: [String: String] = [:]
        headers["Authorization"] = ""
        return headers
    }
    
    private func queryParameters(query: String) -> [URLQueryItem] {
        let parameters = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "page", value: String(1)),
            URLQueryItem(name: "per_page", value: String(30))
        ]
        return parameters
    }
    
    private func url(queryItems: [URLQueryItem]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = ""
        components.path = ""
        components.queryItems = queryItems
        return components.url!
    }
    
}

