//
//  NetworkManager.swift
//  Flashcards
//
//  Created by Николай on 18.01.2022.
//

import Foundation

class NetworkUrlImagesFetcher {
    
    // MARK: - Properties
    
    static let shared = NetworkUrlImagesFetcher()
    
    private init() {}
    
    // MARK: - Public methods
    
    func request(query: String, completion: @escaping ([String]?, Error?) -> Void)  {
    
        guard let encodingQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        let queryParameters = queryParameters(query: encodingQuery)
        let url = url(queryItems: queryParameters)
       
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = queryHeaders()
        request.httpMethod = "get"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
           
            let imagesUrls = JSONWorker.shared.decodeJSON(type: ImagesUrlList.self, from: data)
            let result = imagesUrls?.results.map { $0.urls.small }
        
            DispatchQueue.main.async {
                completion(result, error)
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
