//
//  Untitled.swift
//  USTopHeadLinesNews
//
//  Created by Mac Os Sequoia on 22/03/25.
//

import Foundation
import Combine

class NewsRepository {
    private let baseURL = "https://newsapi.org/v2/"
    private let apiKey = "eab896af7bdd46ea9653537067d6e93d" 

    func fetchTopHeadlines() -> AnyPublisher<NewsResponse, Error> {
        let urlString = "\(baseURL)top-headlines?country=us&apiKey=\(apiKey)"
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: NewsResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
