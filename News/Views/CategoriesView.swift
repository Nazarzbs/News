//
//  CategoriesView.swift
//  News
//
//  Created by Nazar on 27/3/25.
//

import SwiftUI

struct CategoriesView: View {
    var viewModel: NewsCategoriesViewModel
    @State private var selectedCategory: NewsCategory = .all
    @Namespace private var animationNamespace
    
    let categories: [NewsCategory] = NewsCategory.allCases
    
    var body: some View {
        NavigationStack {
            
            // Category Selection Section
            Section {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(categories, id: \.self) { category in
                            CategoryChip(
                                category: category,
                                isSelected: selectedCategory == category,
                                namespace: animationNamespace
                            )
                            .onTapGesture {
                                withAnimation(.smooth) {
                                    selectedCategory = category
                                }
                                Task {
                                    await viewModel.fetchHeadlines(category: category)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }
            }
            
            List {
                
                // Articles List Section
                if viewModel.isLoading {
                        ProgressView("Loading articles...")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .listRowSeparator(.hidden)
                } else if viewModel.headlines.isEmpty {
                        ContentUnavailableView(
                            "No Articles",
                            systemImage: "newspaper",
                            description: Text("There are no articles in this category.")
                             
                        )
                        .listRowSeparator(.hidden)
                } else {
                        ForEach(viewModel.headlines) { article in
                            ArticleRow(article: article)
                               
                                .listRowSeparator(.hidden)
                    }
                }
            }
            .listStyle(.plain)
            .refreshable {
                await viewModel.fetchHeadlines(category: selectedCategory)
            }
            .onAppear {
                print("CategoriesView: onAppear")
                Task {
                    await viewModel.fetchHeadlines(category: selectedCategory)
                }
            }
            .navigationTitle("News")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("News")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
            }
        }
    }
}

// MARK: - Category Chip (Horizontal Scroll)

struct CategoryChip: View {
    let category: NewsCategory
    let isSelected: Bool
    var namespace: Namespace.ID
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: category.iconName)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(isSelected ? .white : category.color)
                
                if isSelected {
                    Text(category.displayName)
                        .font(.system(size: 14, weight: .medium))

                }
                                      
            }
            .animation(nil, value: isSelected)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                Group {
                    if isSelected {
                        Capsule()
                            .fill(category.color.gradient)
                            .matchedGeometryEffect(id: "categoryBackground", in: namespace)
                    } else {
                        Capsule()
                            .fill(Color(.secondarySystemGroupedBackground))
                    }
                }
            )
            .foregroundColor(isSelected ? .white : .primary)
            .overlay(
                Capsule()
                    .stroke(isSelected ? Color.clear : Color(.separator), lineWidth: 1)
            )
            
        }
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

