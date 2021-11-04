//
//  Articles.swift
//  NewsReport
//
//  Created by ธนาธิป ก๋ำนารายณ์ on 3/11/2564 BE.
//

import Foundation

struct ArticlesResponse: Codable {
    let articles: [Article]?
}

struct Article: Codable {
    let title: String?
    let description: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}
