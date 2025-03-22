//
//  Untitled.swift
//  USTopHeadLinesNews
//
//  Created by Mac Os Sequoia on 21/03/25.
//

import SwiftUI

struct NewsDetailView: View {
    let article: Article
    @State private var likes: Int = 0
    @State private var comments: Int = 0
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let imageUrl = article.urlToImage {
                    AsyncImage(url: URL(string: imageUrl)) { image in
                        image.resizable()
                    } placeholder: {
                        Color.gray
                    }
                    .frame(height: 200)
                    .cornerRadius(8)
                } else {
                    Color.gray
                        .frame(height: 200)
                        .cornerRadius(8)
                }

                Text(article.title)
                    .font(.title)
                    .bold()

                if let description = article.description {
                    Text(description)
                        .font(.body)
                }

                HStack {
                    Text("👍 Likes: \(likes)")
                    Spacer()
                    Text("💬 Comments: \(comments)")
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)

                Button(action: {
                    if let url = URL(string: article.url) {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Text("Read Full Article")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .padding(.vertical)
            }
            .padding()
        }
        .navigationTitle("News Details")
        .onAppear {
            fetchArticleInfo()
        }
    }

    private func fetchArticleInfo() {
        isLoading = true
        errorMessage = nil

        let articleId = article.url
            .replacingOccurrences(of: "https://", with: "")
            .replacingOccurrences(of: "/", with: "-")

        fetchLikes(articleId: articleId)
        fetchComments(articleId: articleId)
    }

    private func fetchLikes(articleId: String) {
        guard let url = URL(string: "https://cn-news-info-api.herokuapp.com/likes/\(articleId)") else {
            errorMessage = "Invalid URL"
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                if let data = data, let likesString = String(data: data, encoding: .utf8) {
                    self.likes = Int(likesString) ?? 0
                } else {
                    self.errorMessage = error?.localizedDescription ?? "Failed to fetch likes"
                }
                self.isLoading = false
            }
        }.resume()
    }

    private func fetchComments(articleId: String) {
        guard let url = URL(string: "https://cn-news-info-api.herokuapp.com/comments/\(articleId)") else {
            errorMessage = "Invalid URL"
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                if let data = data, let commentsString = String(data: data, encoding: .utf8) {
                    self.comments = Int(commentsString) ?? 0
                } else {
                    self.errorMessage = error?.localizedDescription ?? "Failed to fetch comments"
                }
                self.isLoading = false
            }
        }.resume()
    }
}
