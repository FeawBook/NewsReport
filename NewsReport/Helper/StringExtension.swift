//
//  StringExtension.swift
//  NewsReport
//
//  Created by ธนาธิป ก๋ำนารายณ์ on 3/11/2564 BE.
//

import Foundation

enum DateTimeFormat: String {
    case english = "MMM dd, HH:mm"
    case server = "yyyy-MM-dd'T'HH:mm:ss'Z'"
}

extension String {
    func convertDateString(currentFormat: String, expectFormat: String) -> String? {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = currentFormat
        guard let currentlyDate = formatter.date(from: self) else { return nil }
        formatter.dateFormat = expectFormat
        return formatter.string(from: currentlyDate)
    }
}
