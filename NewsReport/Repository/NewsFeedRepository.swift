//
//  NewsFeedRepository.swift
//  NewsReport
//
//  Created by ธนาธิป ก๋ำนารายณ์ on 4/11/2564 BE.
//

import Foundation
import Moya
import RxSwift

protocol NewsFeedRepository {
    func getNews(page: Int) -> Observable<[Article]?>
}

class NewsFeedRepositoryImpl: NewsFeedRepository {
    private let datasource: NewsFeedDatasource
    
    init(datasource: NewsFeedDatasource = NewsFeedDatasourceImpl()) {
        self.datasource = datasource
    }
    
    func getNews(page: Int) -> Observable<[Article]?> {
        return datasource.getNews(page: page)
    }
}
