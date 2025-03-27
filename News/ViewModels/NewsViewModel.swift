//
//  NewsViewModel 2.swift
//  News
//
//  Created by Nazar on 27/3/25.
//

import SwiftUI

@Observable
final class NewsViewModel {
    private let newsService: NewsAPIService
    
    var articles: [Article] { newsService.articles }
    var isLoading: Bool { newsService.isLoading }
    var errorMessage: String? { newsService.errorMessage }
    
    init(apiKey: String) {
        newsService = NewsAPIService(apiKey: apiKey)
    }
    
    func search(query: String? = nil) async {
        await newsService.refresh(query: query)
    }
    
    func loadMore() async {
        await newsService.loadNextPage()
    }
}
