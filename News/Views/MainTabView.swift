//
//  MainTabView.swift
//  News
//
//  Created by Nazar on 27/3/25.
//


import SwiftUI

struct MainTabView: View {
    @State private var mainViewModel = NewsViewModel(apiKey: "d30476204fc74acba24fc4b9680dac1d")
    @State private var categoriesViewModel = NewsCategoriesViewModel(apiKey: "d30476204fc74acba24fc4b9680dac1d")
    
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
