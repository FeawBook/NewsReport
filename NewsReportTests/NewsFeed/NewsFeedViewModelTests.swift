//
//  NewsFeedViewModelTests.swift
//  NewsReportTests
//
//  Created by ธนาธิป ก๋ำนารายณ์ on 4/11/2564 BE.
//

import XCTest
import Moya
import RxSwift
import RxTest
@testable import NewsReport

class NewsFeedViewModelTests: XCTestCase {
    private var viewModel: NewsFeedViewModel!
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!

    override func setUp() {
        viewModel = NewsFeedViewModel()
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }

    func test_isShowArticleListEmpty() {
        viewModel.newsFeedUseCase.getNews(page: 0)
            .subscribe(onNext: { item in
            XCTAssertEqual(item?.count, 0)
            }).disposed(by: disposeBag)
    }
    
    func test_isShowArticleListNotEmpty() {
        viewModel.newsFeedUseCase.getNews(page: 1)
            .subscribe(onNext: { item in
                XCTAssertGreaterThan(item?.count ?? 0, 1)
            }).disposed(by: disposeBag)
    }
    
    func test_isShowLoadingWhenFetchData() {
        let isLoading = scheduler.createObserver(Bool.self)
        scheduler.createColdObservable([.next(10, true),
                                        .next(20, false),
                                        .next(30, false)])
                 .bind(to: viewModel.loading)
                 .disposed(by: disposeBag)
        scheduler.start()
        XCTAssertEqual(isLoading.events, [])
    }
}
