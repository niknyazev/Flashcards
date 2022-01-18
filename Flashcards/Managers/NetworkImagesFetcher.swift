//
//  NetworkManager.swift
//  Flashcards
//
//  Created by Николай on 18.01.2022.
//

import Foundation

class NetworkImagesFetcher {
    
    let shared = NetworkImagesFetcher()
    
    private init() {}
    
    func request(query: String, completion: @escaping (Data?, Error?) -> Void)  {
        
        let queryParameters = queryParameters(query: query)
        let url = url(queryItems: queryParameters)
       
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = queryHeaders()
        request.httpMethod = "get"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }.resume()
        
    }
    
    private func queryHeaders() -> [String: String] {
        var headers: [String: String] = [:]
        headers[""] = ""
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
        components.host = "api.unsplash.com"
        components.path = "/search/photos"
        components.queryItems = queryItems
        return components.url!
    }
    
}
