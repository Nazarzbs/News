//
//  NewsAPIService.swift
//  News
//
//  Created by Nazar on 26/3/25.
//

import SwiftUI
import SwiftData

@Observable
final class NewsAPIService {
    private let apiKey: String
    private let baseURL = "https://newsapi.org/v2"
    
    var articles: [Article] = []
    var isLoading = false
    var errorMessage: String?
    var currentPage = 1
    var totalResults = 0
    
    // Store the last search query
    private var lastQuery = "ukraine"
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    // MARK: - Search everything.
    func searchAllArticles(
        query: String? = nil,
        pageSize: Int = 20
    ) async {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        // Update the last query if a new one is provided
        if let query = query, !query.isEmpty {
            lastQuery = query
        }
        
        var components = URLComponents(string: "\(baseURL)/everything")!
        components.queryItems = [
            URLQueryItem(name: "apiKey", value: apiKey),
            URLQueryItem(name: "q", value: lastQuery), // Always include a query
            URLQueryItem(name: "pageSize", value: "\(pageSize)"),
            URLQueryItem(name: "page", value: "\(currentPage)")
        ]
        
        guard let url = components.url else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(NewsAPIResponse.self, from: data)
            
            // Check for API errors
            if response.status == "error" {
                throw NewsAPIError.apiError(response.message ?? "Unknown API error")
            }
            
            await MainActor.run {
                if currentPage == 1 {
                    articles = response.articles
                } else {
                    articles.append(contentsOf: response.articles)
                }
                totalResults = response.totalResults
            }
        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
            }
        }
        
        isLoading = false
    }
    
    func loadNextPage() async {
            currentPage += 1
            await searchAllArticles() // Uses lastQuery
        }
    
    func refresh(query: String? = nil) async {
            currentPage = 1
            await searchAllArticles(query: query)
        }
}

// MARK: - Error Handling

enum NewsAPIError: Error {
    case apiError(String)
    
    var localizedDescription: String {
        switch self {
        case .apiError(let message):
            return message
        }
    }
}

