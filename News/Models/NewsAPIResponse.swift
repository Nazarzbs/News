//
//  NewsAPIResponse.swift
//  News
//
//  Created by Nazar on 26/3/25.
//

import SwiftUI

struct NewsAPIResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
    let code: String?
    let message: String?
}

struct Article: Codable, Identifiable {
    var id: UUID { UUID() }
    
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: Date
    let content: String?
    
    enum CodingKeys: String, CodingKey {
        case source, author, title, description, url, urlToImage, publishedAt, content
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        source = try container.decode(Source.self, forKey: .source)
        author = try container.decodeIfPresent(String.self, forKey: .author)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        url = try container.decode(String.self, forKey: .url)
        urlToImage = try container.decodeIfPresent(String.self, forKey: .urlToImage)
        content = try container.decodeIfPresent(String.self, forKey: .content)
        
        let dateString = try container.decode(String.self, forKey: .publishedAt)
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: dateString) {
            publishedAt = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .publishedAt,
                                                 in: container,
                                                 debugDescription: "Date string does not match format expected by formatter.")
        }
    }
}

struct Source: Codable {
    let id: String?
    let name: String?
}
