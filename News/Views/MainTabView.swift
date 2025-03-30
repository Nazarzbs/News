//
//  MainTabView.swift
//  News
//
//  Created by Nazar on 27/3/25.
//


import SwiftUI

struct MainTabView: View {
    private let mainViewModel = NewsViewModel(apiKey: "9926542fd1f14b25bb36ec022dfe345f")
    private let categoriesViewModel = NewsCategoriesViewModel(apiKey: "9926542fd1f14b25bb36ec022dfe345f")
    
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
