//
//  ArticleRow.swift
//  News
//
//  Created by Nazar on 28/3/25.
//

import SwiftUI

struct ArticleRow: View {
    let article: Article
    let imageWidth: CGFloat = UIScreen.main.bounds.width - 32

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Image at the top
            if let imageUrl = article.urlToImage, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: imageWidth, height: 200)
                            .aspectRatio(16/9, contentMode: .fit)
                            .background(Color.gray.opacity(0.3))
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: imageWidth)
                            .clipped()
                    case .failure:
                        Image(systemName: "photo")
                            .frame(width: imageWidth, height: 200)
                            .aspectRatio(16/9, contentMode: .fit)
                            .background(Color.gray.opacity(0.3))
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(maxWidth: imageWidth)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(article.title)
                    .font(.headline)

                if let description = article.description {
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                HStack(spacing: 8) {
                    if let sourceName = article.source.name {
                        HStack(spacing: 2) {
                            Image(systemName: "newspaper")
                                .font(.caption)
                            Text(sourceName)
                                .font(.caption)
                        }
                        .foregroundColor(.blue)
                    }

                    if let author = article.author {
                        HStack(spacing: 2) {
                            Image(systemName: "person.fill")
                                .font(.caption)
                            Text(author)
                                .font(.caption)
                                .lineLimit(1)
                        }
                        .foregroundColor(.secondary)
                    }

                    Spacer()

                    HStack(spacing: 2) {
                        Image(systemName: "clock")
                            .font(.caption)
                        Text(article.publishedAt.formatted(date: .abbreviated, time: .omitted))
                            .font(.caption)
                    }
                    .foregroundColor(.secondary)
                }
                .padding(.top, 8)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .listRowSeparator(.hidden)
        .frame(maxWidth: .infinity)
        .clipShape(.rect(cornerRadius: 20))
        .background {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(.white)
                .shadow(radius: 5)
        }
    }
}

#Preview {
    MainTabView()
}
