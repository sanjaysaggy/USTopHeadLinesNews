//
//  Untitled.swift
//  USTopHeadLinesNews
//
//  Created by Mac Os Sequoia on 21/03/25.
//

import SwiftUI

struct NewsListView: View {
    @StateObject private var viewModel = NewsViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.articles) { article in
                NavigationLink(destination: NewsDetailView(article: article)) {
                    NewsItemView(article: article)
                        .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                }
            }
            .listStyle(.plain)
            .navigationTitle("Latest News")
            .onAppear {
                viewModel.fetchTopHeadlines()
            }
        }
    }
}

struct NewsItemView: View {
    let article: Article

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let imageUrl = article.urlToImage {
                AsyncImage(url: URL(string: imageUrl)) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray
                }
                .frame(height: 180)
                .cornerRadius(8)
            } else {
                Color.gray
                    .frame(height: 180)
                    .cornerRadius(8)
            }

            Text(article.title)
                .font(.headline)
                .lineLimit(2)

            if let description = article.description {
                Text(description)
                    .font(.subheadline)
                    .lineLimit(3)
            }
        }
        .padding(.vertical, 8)
    }
}
