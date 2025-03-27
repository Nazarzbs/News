//
//  CategoriesView.swift
//  News
//
//  Created by Nazar on 27/3/25.
//

import SwiftUI

struct CategoriesView: View {
    var viewModel: NewsCategoriesViewModel
    @State private var selectedCategory: NewsCategory? = NewsCategory.all
    
    let categories: [NewsCategory] = NewsCategory.allCases
    
    var body: some View {
        NavigationStack {
            VStack {
                // Category Selection List
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(categories, id: \.self) { category in
                            CategoryChip(
                                category: category,
                                isSelected: selectedCategory == category
                            )
                            .onTapGesture {
                                if selectedCategory == category {
                                    selectedCategory = nil
                                } else {
                                    selectedCategory = category
                                }
                                Task {
                                    await viewModel.fetchHeadlines(category: category)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                Divider()
                
                // Articles List
                if viewModel.isLoading {
                    Spacer()
                    ProgressView("Loading articles...")
                    Spacer()
                } else if viewModel.headlines.isEmpty {
                    Spacer()
                    Text("No articles found")
                        .foregroundStyle(.gray)
                    Spacer()
                } else {
                    ScrollView {
                        
                        ForEach(viewModel.headlines) { article in
                            ArticleRow(article: article)
                        }
                        .padding()
                    }
                }
            }
            .onAppear {
                print("CategoriesView: onAppear")
                Task {
                    await viewModel.fetchHeadlines(category: selectedCategory)
                }
            }
            .navigationTitle("News Categories")
        }
    }
}

// MARK: - Category Chip (Horizontal Scroll)

struct CategoryChip: View {
    let category: NewsCategory
    let isSelected: Bool
    
    var body: some View {
        HStack {
            Image(systemName: category.iconName)
                .foregroundColor(.white)
            
            Text(category.displayName)
                .font(.system(size: 16, weight: .medium))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(isSelected ? category.color : .gray.opacity(0.3))
        .foregroundColor(isSelected ? .white : .black)
        .clipShape(Capsule())
        .overlay(
            Capsule().stroke(Color.gray, lineWidth: isSelected ? 0 : 1)
        )
        .animation(.easeInOut, value: isSelected)
    }
}

// MARK: - NewsCategory

enum NewsCategory: String, CaseIterable {
    case all = "all"
    case business = "business"
    case entertainment = "entertainment"
    case general = "general"
    case health = "health"
    case science = "science"
    case sports = "sports"
    case technology = "technology"
   
    
    var displayName: String {
        switch self {
        case .all: return "All"
        case .business: return "Business"
        case .entertainment: return "Entertainment"
        case .general: return "General"
        case .health: return "Health"
        case .science: return "Science"
        case .sports: return "Sports"
        case .technology: return "Technology"
        }
    }
    
    var iconName: String {
        switch self {
        case .all:
            return "globe"
        case .business: return "briefcase"
        case .entertainment: return "film"
        case .general: return "newspaper"
        case .health: return "heart"
        case .science: return "atom"
        case .sports: return "sportscourt"
        case .technology: return "laptopcomputer"
        }
    }
    
    var color: Color {
        switch self {
        case .all:
            return .black
        case .business: return .blue
        case .entertainment: return .purple
        case .general: return .gray
        case .health: return .pink
        case .science: return .green
        case .sports: return .orange
        case .technology: return .indigo
        }
    }
}

