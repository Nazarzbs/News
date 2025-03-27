//
//  NewsCategoriesViewModel.swift
//  News
//
//  Created by Nazar on 27/3/25.
//

import SwiftUI

@Observable
final class NewsCategoriesViewModel {
    private let apiService: NewsCategoriesAPIService
    
    var headlines: [Article] { apiService.headlines }
    var isLoading: Bool { apiService.isLoading }
    var errorMessage: String? { apiService.errorMessage }
    
    init(apiKey: String) {
        apiService = NewsCategoriesAPIService(apiKey: apiKey)
    }
    
    func fetchHeadlines(category: NewsCategory?) async {
        await apiService.filterByCategory(category)
    }
    
    func loadMore() async {
        await apiService.loadNextPage()
    }
    
    func refresh(category: NewsCategory?) async {
        await apiService.refresh(category: category?.rawValue)
    }
}
