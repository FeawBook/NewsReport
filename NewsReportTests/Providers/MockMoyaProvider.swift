//
//  MockMoyaProvider.swift
//  NewsReportTests
//
//  Created by ธนาธิป ก๋ำนารายณ์ on 4/11/2564 BE.
//

import Foundation
import Moya
@testable import NewsReport

class MockMoyaProvider<T: TargetType>: MoyaProvider<T> {
    var callServiceCount: Int = 0
    override func request(_ target: T, callbackQueue: DispatchQueue? = .none, progress: ProgressBlock? = .none, completion: @escaping Completion) -> Cancellable {
        callServiceCount += 1
        return super.request(target, callbackQueue: callbackQueue, progress: progress, completion: completion)
    }
}
