//
//  NetworkService.swift
//  AndersenPetProject
//
//  Created by Alexey Dubovik on 10.06.24.
//

import Foundation
import UIKit

final class NetworkService: NetworkServiceProtocol {
    
    var currentPage = 1
    
    private let session: URLSession
    private weak var delegate: NetworkServiceDelegate?
    
    init(delegate: NetworkServiceDelegate) {
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = URLCache(memoryCapacity: 50 * 1024 * 1024, diskCapacity: 200 * 1024 * 1024, diskPath: "imageCache")
        self.session = URLSession(configuration: configuration)
        self.delegate = delegate
    }
    
    func resetPages() {
        self.currentPage = 1
    }
    
    func fetchImageInfo() {
        var components = URLComponents()
        components.scheme = Api.scheme
        components.host = Api.host
        components.queryItems = [ URLQueryItem(name: Api.queryItems[0], value: String(currentPage)),
                                  URLQueryItem(name: Api.queryItems[1], value: Api.itemsPerPage),
                                  URLQueryItem(name: Api.queryItems[2], value: Api.apiKey)]
        components.path = Api.listPath
        guard let url = components.url else { return }
        session.dataTask(with: url) {[weak self] data, response, error in
            if let _ = error {
                self?.delegate?.didFailWithError(error: Errors.networkError)
            } else if let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode), let data = data {
                do {
                    let imageInfo = try JSONDecoder().decode([ImageInfo].self, from: data)
                    self?.delegate?.didFetchImages(imageInfo)
                    
                } catch {
                    self?.delegate?.didFailWithError(error: Errors.decodingError)
                }
            }
        }.resume()
    }
    
    func fetchImageForInfo(url: URL, completion: @escaping (UIImage) -> Void) {
        session.dataTask(with: url) { [weak self] data, response, error in
            if let _ = error {
                self?.delegate?.didFailWithError(error: Errors.networkError)
            } else if let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode), let data = data {
                DispatchQueue.global().async {
                    guard let image = UIImage(data: data) else { return }
                    completion(image)
                }
            }
        }
        .resume()
    }
    
    func searchImages(for searchText: String) {
        var components = URLComponents()
        components.scheme = Api.scheme
        components.host = Api.host
        components.queryItems = [ URLQueryItem(name: Api.queryItems[0], value: String(currentPage)),
                                  URLQueryItem(name: Api.queryItems[1], value: Api.itemsPerPage),
                                  URLQueryItem(name: Api.queryItems[2], value: Api.apiKey),
                                  URLQueryItem(name: Api.queryItems[3], value: searchText)]
        components.path = Api.searchPath
        guard let url = components.url else { return }
        session.dataTask(with: url) {[weak self] data, response, error in
            if let _ = error {
                self?.delegate?.didFailWithError(error: Errors.networkError)
            } else if let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode), let data = data {
                do {
                    let searchResult = try JSONDecoder().decode(SearchResults.self, from: data)
                    self?.delegate?.didFetchImages(searchResult.results)
                    
                } catch {
                    self?.delegate?.didFailWithError(error: Errors.decodingError)
                }
            }
        }.resume()
    }
    
}
