//
//  NewsFeedDataSourceTests.swift
//  NewsReportTests
//
//  Created by ธนาธิป ก๋ำนารายณ์ on 4/11/2564 BE.
//

import XCTest
import Moya
import RxSwift
@testable import NewsReport

class NewsFeedDataSourceTests: XCTestCase {
    var disposeBag: DisposeBag = DisposeBag()
    var provider: MoyaProvider<NewsApi>?
    
    override func setUp() {
        super.setUp()
    }
    
    func test_GetNewsFeedAPISuccess() {
        let bundle = Bundle(for: type(of: self))
        guard let filePath = bundle.path(forResource: "news", ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else {
                  XCTFail("Data is nil")
            return
        }
        provider = MockMoyaProvider<NewsApi>(endpointClosure: { api in
            api.endpointForAPI(response: .networkResponse(200, data))
        }, stubClosure: { api in
                .immediate
        })
        
        if let provider = provider {
            let dataSource = NewsFeedDatasourceImpl(provider: provider)
            
            dataSource.getNews(page: 1)
                .subscribe(onNext: { item in
                    XCTAssertNotNil(item)
                })
                .disposed(by: disposeBag)
        }
        
    }
    
    func test_GetNewsFeedDataEmpty() {
        let bundle = Bundle(for: type(of: self))
        guard let filePath = bundle.path(forResource: "empty", ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else {
                  XCTFail("Data is nil")
            return
        }
        
        provider = MockMoyaProvider<NewsApi>(endpointClosure: { api in
            api.endpointForAPI(response: .networkResponse(200, data))
        }, stubClosure: { api in
                .immediate
        })
        
        if let provider = provider {
            let dataSource = NewsFeedDatasourceImpl(provider: provider)
            
            dataSource.getNews(page: 1)
                .subscribe(onNext: { item in
                    XCTAssertEqual(item?.count, 0, "data is empty")
                })
                .disposed(by: disposeBag)
        }
    }
    
    func test_GetNewsFeedAPIError() {
        let bundle = Bundle(for: type(of: self))
        guard let filePath = bundle.path(forResource: "error", ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else {
                  XCTFail("Data is nil")
            return
        }
        
        provider = MockMoyaProvider<NewsApi>(endpointClosure: { api in
            api.endpointForAPI(response: .networkResponse(401, data))
        }, stubClosure: { api in
                .immediate
        })
        
        if let provider = provider {
            let dataSource = NewsFeedDatasourceImpl(provider: provider)
            
            dataSource.getNews(page: 1)
                .subscribe(onNext: { item in
                    XCTAssertNil(item)
                })
                .disposed(by: disposeBag)
        }
    }
    
}
