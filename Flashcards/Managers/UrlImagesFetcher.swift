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
    
    func request(identifier: String, completion: @escaping (Result<[String], NetworkError>) -> Void) {
            
        let queryParameters = queryParameters(identifier: identifier)
        let url = url(queryItems: queryParameters)
       
        var request = URLRequest(url: url)
        request.httpMethod = "get"
        
        URLSession.shared.dataTask(with: request) { (data, _, _) in
                            
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
    // TODO: remove if does not need
    private func queryHeaders() -> [String: String] {
        var headers: [String: String] = [:]
        headers["Authorization"] = "Client-ID EENjn6vCuLOltg5kUPDwfubrcy6dvJGOj-SeDQlXoJs"
        return headers
    }
    
    private func queryParameters(identifier: String) -> [URLQueryItem] {
        let parameters = [
            URLQueryItem(name: "i", value: identifier)
        ]
        return parameters
    }
    
    private func url(queryItems: [URLQueryItem]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.thecocktaildb.com"
        components.path = "/api/json/v1/1/lookup.php"
        components.queryItems = queryItems
        return components.url!
    }
    
}
