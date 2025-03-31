//
//  MainTabView.swift
//  News
//
//  Created by Nazar on 27/3/25.
//


import SwiftUI

struct MainTabView: View {
    private let mainViewModel = NewsAPIService(apiKey: "0f61db8eeb734631a53b3a4739cc3029")
    private let categoriesViewModel = NewsCategoriesAPIService(apiKey: "0f61db8eeb734631a53b3a4739cc3029")
    
    var body: some View {
        TabView {
            // Main News View
            MainView(viewModel: mainViewModel)
                .tabItem {
                    Label("News", systemImage: "newspaper")
                }
            
            // Categories View
            CategoriesView(viewModel: categoriesViewModel)
                .tabItem {
                    Label("Categories", systemImage: "list.bullet")
                }
        }
    }
}
