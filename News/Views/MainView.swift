//
//  MainView.swift
//  News
//
//  Created by Nazar on 26/3/25.
//

import SwiftUI

struct MainView: View {
    var viewModel: NewsAPIService
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            NewsListView(viewModel: viewModel)
                .listStyle(.plain)
                .navigationTitle("News")
                .searchable(text: $searchText, prompt: "Search news, for example: 'ukraine'")
                .onSubmit(of: .search) {
                    Task {
                        await viewModel.refresh(query: searchText)
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
            await viewModel.refresh()
        }
    }
}

private struct NewsListView: View {
    let viewModel: NewsAPIService
    
    var body: some View {
        List {
            ForEach(viewModel.articles) { article in
                ArticleRow(article: article)
            }
            
            if !viewModel.articles.isEmpty {
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowSeparator(.hidden)
                    .onAppear {
                        if !viewModel.isLoading {
                            Task {
                                await viewModel.loadNextPage()
                            }
                        }
                    }
            }
        }
    }
}
