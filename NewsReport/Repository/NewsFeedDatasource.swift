//
//  NewsFeedDatasource.swift
//  NewsReport
//
//  Created by ธนาธิป ก๋ำนารายณ์ on 4/11/2564 BE.
//

import Foundation
import Moya
import RxSwift

protocol NewsFeedDatasource {
    func getNews(page: Int) -> Observable<[Article]?>
}

final class NewsFeedDatasourceImpl: NewsFeedDatasource {
    private let provider: MoyaProvider<NewsApi>
    
    init(provider: MoyaProvider<NewsApi> = MoyaProvider<NewsApi>()) {
        self.provider = provider
    }
    
    func getNews(page: Int) -> Observable<[Article]?> {
        return Observable.create { [weak self] emitter -> Disposable in
            guard let self = self else {
                return Disposables.create()
            }
            
            self.provider.request(.getNews(page: page)) { result in
                switch result {
                case .success(let response):
                    do {
                        let responseData = try response.map(ArticlesResponse.self).articles
                        emitter.onNext(responseData)
                    } catch(let error) {
                        emitter.onError(error)
                    }
                case .failure(let error):
                    emitter.onError(error)
                }
                emitter.onCompleted()
            }
            return Disposables.create()
        }
    }
}
