//
//  MainView.swift
//  News
//
//  Created by Nazar on 26/3/25.
//

import SwiftUI

struct MainView: View {
    @State private var viewModel = NewsAPIService(apiKey: "d30476204fc74acba24fc4b9680dac1d")
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            List(viewModel.articles) { article in
                ArticleRow(article: article)
                    .onAppear {
                        if article.id == viewModel.articles.last?.id {
                            Task {
                                await viewModel.loadNextPage()
                            }
                        }
                    }
            }
            
            .navigationTitle("News")
            .searchable(text: $searchText, prompt: "Search news, for example: 'ukraine'")
            .onSubmit(of: .search) {
                Task {
                    await viewModel.refresh(query: searchText)  // Pass searchText here
                }
            }
            .overlay {
                if viewModel.isLoading && viewModel.articles.isEmpty {
                    ProgressView()
                } else if viewModel.articles.isEmpty && !viewModel.isLoading {
                    ContentUnavailableView.search(text: searchText)
                }
            }
        }
        .task {
            // Load initial data with default "ukraine" query
            await viewModel.searchArticles()
        }
    }
}

struct ArticleRow: View {
    let article: Article
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Image at the top
            if let imageUrl = article.urlToImage, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .frame(height: 200)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .frame(height: 200)
                            .clipped()
                            .cornerRadius(8)
                    case .failure:
                        Image(systemName: "photo")
                            .frame(maxWidth: .infinity)
                            .frame(height: 200)
                            .background(Color.gray.opacity(0.2))
                    @unknown default:
                        EmptyView()
                    }
                }
            }
            
            // Title
            Text(article.title)
                .font(.headline)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
            
            // Description
            if let description = article.description {
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            // Metadata row
            HStack(spacing: 16) {
                // Source
                if let sourceName = article.source.name {
                    HStack(spacing: 4) {
                        Image(systemName: "newspaper")
                        Text(sourceName)
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
                }
                
                // Author
                if let author = article.author {
                    HStack(spacing: 4) {
                        Image(systemName: "person.fill")
                        Text(author)
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Date
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                    Text(article.publishedAt.formatted(date: .abbreviated, time: .omitted))
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
            .padding(.top, 4)
        }
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}
