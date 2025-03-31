//
//  TopHeadlinesService.swift
//  News
//
//  Created by Nazar on 27/3/25.
//


import SwiftUI
import SwiftData

@Observable
final class NewsCategoriesAPIService {
    private let apiKey: String
    private let baseURL = "https://newsapi.org/v2"
    
    var headlines: [Article] = []
    var isLoading = false
    var errorMessage: String?
    var currentPage = 1
    var totalResults = 0
    
    private var lastCategory: String?
    private var lastCountry: String?
    private var lastQuery: String?
    private let cacheService = CacheService.shared
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    // MARK: - Fetch Top Headlines
    func fetchTopHeadlines(
        category: String? = "all",
        country: String? = "us",
        query: String? = nil,
        pageSize: Int = 20
    ) async {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        // Update stored filters
        lastCategory = category
        lastCountry = country
        lastQuery = query
        
        // Try to load from cache first if it's the first page
        if currentPage == 1 {
            let cacheKey = "headlines_\(category ?? "all")_\(country ?? "us")"
            if let cachedResponse: NewsAPIResponse = try? await cacheService.retrieve(forKey: cacheKey) {
                await MainActor.run {
                    headlines = cachedResponse.articles
                    totalResults = cachedResponse.totalResults
                    isLoading = false
                }
            }
        }
        
        var components = URLComponents(string: "\(baseURL)/top-headlines")!
        components.queryItems = [
            URLQueryItem(name: "apiKey", value: apiKey),
            URLQueryItem(name: "pageSize", value: "\(pageSize)"),
            URLQueryItem(name: "page", value: "\(currentPage)")
        ]
        
        if let category = category, category != "all", !category.isEmpty {
            components.queryItems?.append(URLQueryItem(name: "category", value: category))
        }
        
        if let country = country, !country.isEmpty {
            components.queryItems?.append(URLQueryItem(name: "country", value: country))
        }
        
        if let query = query, !query.isEmpty {
            components.queryItems?.append(URLQueryItem(name: "q", value: query))
        }
        
        guard let url = components.url else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(NewsAPIResponse.self, from: data)
            
            if response.status == "error" {
                throw NewsAPIError.apiError(response.message ?? "Unknown API error")
            }
            
            await MainActor.run {
                if currentPage == 1 {
                    headlines = response.articles
                    // Cache the first page response
                    Task {
                        let cacheKey = "headlines_\(category ?? "all")_\(country ?? "us")"
                        try? await cacheService.cache(response, forKey: cacheKey)
                    }
                } else {
                    headlines.append(contentsOf: response.articles)
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
    
    func filterByCategory(_ category: NewsCategory?) async {
        await fetchTopHeadlines(category: category?.rawValue, country: "us")
    }
    
    func loadNextPage() async {
        currentPage += 1
        await fetchTopHeadlines(category: lastCategory, country: lastCountry, query: lastQuery)
    }
    
    func refresh(category: String? = nil, country: String? = "us", query: String? = nil) async {
        currentPage = 1
        await fetchTopHeadlines(category: category, country: country, query: query)
    }
}
