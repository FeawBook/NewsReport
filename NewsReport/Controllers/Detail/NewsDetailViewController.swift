//
//  NewsDetailViewController.swift
//  NewsReport
//
//  Created by ธนาธิป ก๋ำนารายณ์ on 3/11/2564 BE.
//

import UIKit
import Kingfisher

class NewsDetailViewController: BaseViewController {
    @IBOutlet private weak var newsImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionDetailLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    var article: Article?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Detail"
        setupDate()
    }
    
    func setupDate() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.newsImageView.kf.setImage(with: URL(string: self.article?.urlToImage ?? ""), placeholder: UIImage(named: "placeholder"), options: [.cacheOriginalImage], completionHandler: nil)
            self.titleLabel.text = self.article?.title ?? ""
            self.descriptionDetailLabel.text = self.article?.content ?? ""
            if let dateString = "\(self.article?.publishedAt ?? "")".convertDateString(currentFormat: DateTimeFormat.server.rawValue, expectFormat: DateTimeFormat.english.rawValue) {
                self.dateLabel.text = "Updated: " + dateString
            }
        }
    }
}
