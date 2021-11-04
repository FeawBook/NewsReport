//
//  NewsFeedViewModel.swift
//  NewsReport
//
//  Created by ธนาธิป ก๋ำนารายณ์ on 2/11/2564 BE.
//

import Foundation
import RxSwift
import Moya
import RxRelay
import RxCocoa

protocol NewsFeedViewModelProtocol {
    func requestData(page: Int, isLoadMore: Bool)
}

class NewsFeedViewModel {
    public enum NewsFeedError {
        case internetError(String)
        case serverError(String)
    }

    var news = BehaviorRelay<[Article?]>(value: [])
    let fetchMoreData: PublishSubject<Void> = PublishSubject()
    let isLoadSpinning: PublishSubject<Bool> = PublishSubject()
    public let loading: PublishSubject<Bool> = PublishSubject()
    public let error: PublishSubject<NewsFeedError> = PublishSubject()
    private let disposeBag: DisposeBag = DisposeBag()
    private var pageCounter = 1
    private var maxValue = 1
    private var isPagination = false
    let newsFeedUseCase: NewsFeedUseCase = NewsFeedUseCaseImpl()
    
    init() {
        bind()
    }
    
    private func bind(provider: MoyaProvider<NewsApi> = MoyaProvider<NewsApi>()) {
        fetchMoreData.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.requestData(page: self.pageCounter, isLoadMore: true)
        }
        .disposed(by: disposeBag)
        
    }
    
    fileprivate func handleData(_ responseData: [Article]?) {
        self.maxValue = responseData?.count ?? 0
        if self.pageCounter == 1, let finalData = responseData {
            self.maxValue = responseData?.count ?? 0
            self.isLoadSpinning.onNext(false)
            self.news.accept(finalData)
        } else if let data = responseData {
            let oldFeed = self.news.value
            self.news.accept(oldFeed + data)
        }
        self.pageCounter += 1
    }
    
    func requestData(page: Int, isLoadMore: Bool) {
        if isPagination { return }
        
        if self.pageCounter > self.maxValue {
            self.isPagination = false
        } else {
            self.isPagination = true
            self.isLoadSpinning.onNext(true)
        }
        
        if self.pageCounter == 1 {
            self.isLoadSpinning.onNext(false)
        }
        
        if !isLoadMore {
            self.loading.onNext(true)
        }
        
        self.newsFeedUseCase.getNews(page: page)
            .subscribe(onNext: { [weak self] articles in
                guard let self = self else { return }
                self.loading.onNext(false)
                self.handleData(articles)
                self.isLoadSpinning.onNext(false)
                self.isPagination = false
            }, onError: { error in
                self.error.onNext(.internetError("\(error.localizedDescription)"))
            }).disposed(by: disposeBag)
        
    }
}
