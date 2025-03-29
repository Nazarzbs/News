//
//  MainView.swift
//  News
//
//  Created by Nazar on 26/3/25.
//

import SwiftUI

struct MainView: View {
    var viewModel: NewsViewModel
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            List(viewModel.articles) { article in
                ArticleRow(article: article)
                    .onAppear {
                        if article.id == viewModel.articles.last?.id {
                            Task {
                                await viewModel.loadMore()
                            }
                        }
                    }
            }
            .listStyle(.plain)
            .navigationTitle("News")
            .searchable(text: $searchText, prompt: "Search news, for example: 'ukraine'")
            .onSubmit(of: .search) {
                Task {
                    await viewModel.search(query: searchText)
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
            await viewModel.search()
        }
    }
}
