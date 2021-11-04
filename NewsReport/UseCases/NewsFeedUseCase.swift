//
//  NewsFeedUseCase.swift
//  NewsReport
//
//  Created by ธนาธิป ก๋ำนารายณ์ on 4/11/2564 BE.
//

import Foundation
import RxSwift

protocol NewsFeedUseCase {
    func getNews(page: Int) -> Observable<[Article]?>
}

final class NewsFeedUseCaseImpl: NewsFeedUseCase {
    private let repository: NewsFeedRepository
    
    init(repository: NewsFeedRepositoryImpl = NewsFeedRepositoryImpl()) {
        self.repository = repository
    }
    
    func getNews(page: Int) -> Observable<[Article]?> {
        return repository.getNews(page: page)
    }
}
