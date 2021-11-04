//
//  NewsFeedViewController.swift
//  NewsReport
//
//  Created by ธนาธิป ก๋ำนารายณ์ on 2/11/2564 BE.
//

import UIKit
import RxSwift
import Kingfisher

class NewsFeedViewController: BaseViewController {

    @IBOutlet private weak var feedTableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    private let disposeBag = DisposeBag()
    let newsFeedViewModel = NewsFeedViewModel()
    var news = PublishSubject<[Article]>()
    
    private lazy var viewSpinner: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = view.center
        spinner.color = UIColor.black
        view.addSubview(spinner)
        spinner.startAnimating()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News"
        binding()
        setupView()
        newsFeedViewModel.requestData(page: 1, isLoadMore: false)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    private func setupView() {
        feedTableView.tableFooterView = UIView(frame: .zero)
        feedTableView.estimatedRowHeight = 80
        feedTableView.rowHeight = UITableView.automaticDimension
    }
    
    private func binding() {
        
        self.feedTableView.rx.didScroll.subscribe { [weak self] _ in
            guard let self = self else { return }
            let contentHeight = self.feedTableView.contentSize.height
            let offSetY = self.feedTableView.contentOffset.y
            
            if (contentHeight - self.feedTableView.frame.size.height - 100) < offSetY {
                self.newsFeedViewModel.fetchMoreData.onNext(())
            }
        }
        .disposed(by: disposeBag)
        
        self.feedTableView.rx.willDisplayCell
            .subscribe(onNext: ({ [weak self] (cell, indexPath) in
                guard let self = self else { return }
                cell.alpha = 0
                let transform = CATransform3DTranslate(CATransform3DIdentity, 0, -250, 0)
                cell.layer.transform = transform
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
                    cell.alpha = 1
                    cell.layer.transform = CATransform3DIdentity
                }, completion: nil)
            }))
            .disposed(by: disposeBag)
        
        Observable
            .zip(feedTableView.rx.itemSelected, feedTableView.rx.modelSelected(Article.self))
            .bind { [unowned self] indexPath, model in
                self.feedTableView.deselectRow(at: indexPath, animated: true)
                guard let vc = UIStoryboard(name: StoryboardName.newsDetail.rawValue, bundle: nil).instantiateViewController(withIdentifier: ViewControllerIdentifier.newsDetail.rawValue) as? NewsDetailViewController else { return }
                vc.article = model
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        newsFeedViewModel
            .loading
            .bind(to: self.rx.isAnimating)
            .disposed(by: disposeBag)
        
        newsFeedViewModel
            .news
            .observe(on: MainScheduler.instance)
            .bind(to: self.feedTableView.rx.items(
                cellIdentifier: TableViewCellIdentifier.feed.rawValue,
                cellType: FeedTableViewCell.self)) { [weak self] (row, article, cell) in
                    guard let self = self else { return }
                    guard let article = article else {
                        return
                    }
                    cell.feedImageView.kf.setImage(with: URL(string: article.urlToImage ?? ""), placeholder: UIImage(named: "placeholder"), options: [.cacheOriginalImage], completionHandler: nil)
                    cell.titleLabel.text = article.title ?? ""
                    cell.descriptionLabel.text = article.description ?? ""
                    if let dateString = "\(article.publishedAt ?? "")".convertDateString(currentFormat: DateTimeFormat.server.rawValue, expectFormat: DateTimeFormat.english.rawValue) {
                        cell.createdDateLabel.text = "Updated: " + dateString
                    }
                    
                }
                .disposed(by: disposeBag)
        
        newsFeedViewModel
            .error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (error) in
                guard let self = self else { return }
                switch error {
                case .internetError(let message):
                    self.showAlertWithMessage(message: message)
                case .serverError(let message):
                    self.showAlertWithMessage(message: message)
                }
            })
            .disposed(by: disposeBag)
        
        newsFeedViewModel.isLoadSpinning.subscribe { [weak self] isLoading in
            guard let self = self,
                  let isLoading = isLoading.element
            else { return }
            self.feedTableView.tableFooterView = isLoading ? self.viewSpinner : UIView(frame: .zero)
        }
        .disposed(by: disposeBag)
        
        searchBar.rx.text
            .orEmpty
            .subscribe(onNext: { [weak self] query in
                guard let self = self else { return }
                let data = self.newsFeedViewModel.news.value
                if query != "" {
                    self.newsFeedViewModel.news.accept(data.filter { $0?.title?.hasPrefix(query) ?? false })
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    private func showAlertWithMessage(message: String) {
        let alert = UIAlertController(title: "Error", message: "\(message)", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
