//
//  ImagesFetcher.swift
//  Flashcards
//
//  Created by Николай on 19.02.2022.
//

import Foundation

final class ImagesFetcher {
    
    static let shared = ImagesFetcher()
    
    private init() { }
    
    // MARK: - Public methods
    
    func fetchImage(url: String, completion: @escaping (Data) -> Void ) {
        
        guard let url = URL(string: url) else { return }
        
        if let imageData = getCachedImageData(from: url) {
            completion(imageData)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, _) in
            guard let data = data, let response = response else { return }
            
            if url != response.url {
                return
            }
            
            self.storeToCache(response: response, data: data)
            
            DispatchQueue.main.async {
                completion(data)
            }
        }.resume()
    }
    
    // MARK: - Private methods
    
    private func storeToCache(response: URLResponse, data: Data) {
        guard let url = response.url else { return }
        let request = URLRequest(url: url)
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: request)
    }
    
    private func getCachedImageData(from url: URL) -> Data? {
        let request = URLRequest(url: url)
        let response = URLCache.shared.cachedResponse(for: request)
        
        if let response = response {
            return response.data
        }
        return nil
    }
    
}
