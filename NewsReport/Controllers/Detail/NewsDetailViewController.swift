//
//  NewsDetailViewController.swift
//  NewsReport
//
//  Created by ธนาธิป ก๋ำนารายณ์ on 3/11/2564 BE.
//

import UIKit
import Kingfisher

class NewsDetailViewController: BaseViewController {
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionDetailLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    var article: Article?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Detail"
        self.setupDate()
    }
    
    func setupDate() {
        DispatchQueue.main.async {
            self.newsImageView.kf.setImage(with: URL(string: self.article?.urlToImage ?? ""), placeholder: UIImage(named: "placeholder"), options: [.cacheOriginalImage], completionHandler: nil)
            self.titleLabel.text = self.article?.title ?? ""
            self.descriptionDetailLabel.text = self.article?.content ?? ""
            if let dateString = "\(self.article?.publishedAt ?? "")".convertDateString(currentFormat: "yyyy-MM-dd'T'HH:mm:ss'Z'", expectFormat: "MMM dd, HH:mm") {
                self.dateLabel.text = "Updated: " + dateString
            }
        }
    }
}
