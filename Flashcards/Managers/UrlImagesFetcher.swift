//
//  UrlImagesFetcher.swift
//  Flashcards
//
//  Created by Николай on 18.01.2022.
//

import Foundation

enum NetworkError: Error {
    case noData
    case decodingError
}

class UrlImagesFetcher {
    
    // MARK: - Properties
    
    static let shared = UrlImagesFetcher()
    
    private init() {}
    
    // MARK: - Public methods
    
    func request(query: String, completion: @escaping (Result<[String], NetworkError>) -> Void) {
    
        guard let encodingQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        let queryParameters = queryParameters(query: encodingQuery)
        let url = url(queryItems: queryParameters)
       
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = queryHeaders()
        request.httpMethod = "get"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
                            
            if data == nil {
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }
            
            let imagesUrls = JSONWorker.shared.decodeJSON(type: ImagesUrlList.self, from: data)
            
            guard let imagesUrls = imagesUrls else {
                DispatchQueue.main.async {
                    completion(.failure(.decodingError))
                }
                return
            }
            
            let result = imagesUrls.results.map { $0.urls.small }
        
            DispatchQueue.main.async {
                completion(.success(result))
            }
        }.resume()
        
    }
    
    // MARK: - Private methods
    
    private func queryHeaders() -> [String: String] {
        var headers: [String: String] = [:]
        headers["Authorization"] = "Client-ID EENjn6vCuLOltg5kUPDwfubrcy6dvJGOj-SeDQlXoJs"
        return headers
    }
    
    private func queryParameters(query: String) -> [URLQueryItem] {
        let parameters = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "page", value: String(1)),
            URLQueryItem(name: "per_page", value: String(20)),
            URLQueryItem(name: "per_page", value: String(20))
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
