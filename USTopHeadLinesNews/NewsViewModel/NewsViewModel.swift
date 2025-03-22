//
//  Untitled.swift
//  USTopHeadLinesNews
//
//  Created by Mac Os Sequoia on 21/03/25.
//

import Foundation
import Combine

class NewsViewModel: ObservableObject {
    @Published var articles: [Article] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let repository = NewsRepository()
    private var cancellables = Set<AnyCancellable>()

    func fetchTopHeadlines() {
        isLoading = true
        errorMessage = nil

        repository.fetchTopHeadlines()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: { [weak self] response in
                self?.articles = response.articles
            }
            .store(in: &cancellables)
    }
}
