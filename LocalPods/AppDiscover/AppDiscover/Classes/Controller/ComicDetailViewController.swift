//
//  ComicDetailViewController.swift
//  AppDiscover
//
//  Created by Archer on 2018/12/28.
//

import Fate
import UIKit
import YYKit
import FOLDin
import SnapKit
import RxSwift
import RxCocoa
import RxSwiftExt
import ReactorKit
import RxAppState
import RxDataSources

class ComicDetailViewController: UIViewController {

    /// 漫画ID
    var comicId = ""
    
    override var prefersNavigationBarStyle: UINavigationBarStyle {
        return .custom
    }
    
    private lazy var tableView: UITableView = {
        let v = UITableView(frame: .zero, style: .grouped)
        v.showsVerticalScrollIndicator = false
        v.estimatedRowHeight = 100
        v.backgroundColor = .clear
        v.separatorStyle = .none
        v.fate.register(cellClass: ComicChapterCell.self)
        v.fate.register(cellClass: ComicGuessLikeCell.self)
        v.fate.register(headerFooterViewClass: ChapterHeaderView.self)
        v.fate.register(headerFooterViewClass: ChapterFooterView.self)
        v.fate.register(headerFooterViewClass: GuessLikeHeaderView.self)
        v.fate.register(headerFooterViewClass: GuessLikeFooterView.self)
        if #available(iOS 11.0, *) {
            v.contentInsetAdjustmentBehavior = .never
        }
        return v
    }()
    
    // 顶部背景图
    private lazy var coverImageView = ComicImageView()
    // 顶部简介
    private lazy var previewView = ComicPreviewView()
    // 底部工具条
    private lazy var toolBar = ComicToolBar()
    
    private lazy var placeholderView = U17PlaceholderView()
    
    private lazy var dataSource = tableViewSectionedReloadDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        buildNavbar()
    }
    
    deinit { NSLog("\(className()) is deallocating...") }
}

extension ComicDetailViewController: View {
    func bind(reactor: ComicDetailViewReactor) {
        
        // MARK: 设置代理
        tableView.rx.setDelegate(self).disposed(by: disposeBag)

        // 每个都去写[weak self]
        // 还是挺烦的，简化一下
        weak var `self` = self
        
        let viewDidLoad = rx.viewDidLoad.share(replay: 1, scope: .forever)
        
        // MARK: 请求数据
        viewDidLoad
            .map { Reactor.Action.getStaticDetail(self?.comicId) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        viewDidLoad
            .map { Reactor.Action.getGuessLikeList(self?.comicId) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        viewDidLoad
            .map { Reactor.Action.getRealtimeDetail(self?.comicId) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        // MARK: 绑定预览数据
        reactor.state
            .map { $0.previewViewDisplay }
            .filterNil()
            .bind(to: previewView.rx.display)
            .disposed(by: disposeBag)
        
        // MARK: 绑定背景图
        reactor.state
            .map { $0.imageViewDisplay }
            .filterNil()
            .bind(to: coverImageView.rx.display)
            .disposed(by: disposeBag)
        
        // MARK: 绑定数据源
        reactor.state
            .map { $0.sections }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        // MARK: 处理出错
        reactor.state
            .map {$0.error }
            .filterNil()
            .subscribe(onNext: { (error) in
                SwiftyHUD.show(error.message)
            }).disposed(by: disposeBag)
        
        // MARK: 跳转分类
        previewView.rx.showsCategory
            .subscribe(onNext: { (category) in
                self?.showsCategory(category)
            }).disposed(by: disposeBag)
        
        // MARK: 查看其他作品
        previewView.rx.showsOtherWork
            .subscribe(onNext: { _ in
                SwiftyHUD.show("其他作品是不可能给你看滴~")
            }).disposed(by: disposeBag)
        
        // MARK: 投月票
        toolBar.rx.sendTicket
            .subscribe(onNext: {
                SwiftyHUD.show("月票是不可能给投月票滴~")
            }).disposed(by: disposeBag)
        
        // MARK: 评论区
        toolBar.rx.sendComment
            .subscribe(onNext: {
                SwiftyHUD.show("评论是不可能给评论滴~")
            }).disposed(by: disposeBag)
    }
    
    private func tableViewSectionedReloadDataSource() -> RxTableViewSectionedReloadDataSource<ComicDetailSection> {
        return RxTableViewSectionedReloadDataSource(configureCell: { (ds, tv, ip, sectionItem) in
            switch sectionItem {
            case .chapter(item: let display):
                let cell: ComicChapterCell = tv.fate.dequeueReusableCell(for: ip)
                cell.display = display
                return cell
                
            case .guessLike(item: let display):
                let cell: ComicGuessLikeCell = tv.fate.dequeueReusableCell(for: ip)
                cell.display = display
                return cell
            }
        })
    }
}

extension ComicDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch dataSource[indexPath] {
        case .chapter: return 45
        case .guessLike(item: let display):
            return tableView.fate.heightForRowAt(indexPath, cellClass: ComicGuessLikeCell.self, configuration: { (cell) in
                cell.display = display
            })
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch dataSource[section] {
        case .chapter:
            let view: ChapterHeaderView? = tableView.fate.dequeueReusableHeaderFooterView()
            return view
            
        case .guessLike:
            return tableView.fate.dequeueReusableHeaderFooterView() as GuessLikeHeaderView?
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch dataSource[section] {
        case .chapter: return 0.01
        case .guessLike: return 45
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch dataSource[section] {
        case .chapter:
            let view: ChapterFooterView? = tableView.fate.dequeueReusableHeaderFooterView()
            let disposeBag = DisposeBag()
            view?.disposeBag = disposeBag
            view?.rx.expand
                .subscribeNext(weak: self) { (self) in
                    return { _ in self.expandBranch(at: section) }
                }.disposed(by: disposeBag)
            return view
            
        case .guessLike:
            let view: GuessLikeFooterView? = tableView.fate.dequeueReusableHeaderFooterView()
            let disposeBag = DisposeBag()
            view?.disposeBag = disposeBag
            view?.rx.report
                .subscribeNext(weak: self) { (self) in
                    return { _ in self.reportFeedback() }
                }.disposed(by: disposeBag)
            return view
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 35
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        // 向下滑动
        if offsetY < 0 {
            fd.navigationItem.title = nil
        } else {
            let comicName = reactor?.currentState.staticResponse?.comic?.name
            fd.navigationItem.title = comicName
        }
    }
}

extension ComicDetailViewController {
    @objc private func popViewControllerAnimated() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func downloadComics() {
        let vc = ChapterDownloadListViewController()
        vc.reactor = ChapterDownloadListViewReactor()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func shareComic() {
        SwiftyHUD.show("分享是不可能给分享滴~")
    }
    
    private func showsCategory(_ category: String) {
        let vc = ComicCategoryViewController()
        vc.category = category
        vc.reactor = ComicCategoryViewReactor()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func reportFeedback() {
        SwiftyHUD.show("举报是不可能举报的嘛")
    }
    
    private func expandBranch(at section: Int) {
        
    }
}

extension ComicDetailViewController {
    private func buildNavbar() {
        fd.navigationBar.barTintColor = .clear
        fd.navigationBar.contentMargin = FDMargin(left: 10, right: 9)
        fd.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white,
                                                .font : UIFont.boldSystemFont(ofSize: 17)]
        // 没找到2x/3x图
        // 本来想着resize一下图片，想想又懒得写缓存
        // 就采用customView吧，设置一下大小就可以了
        // leftBarButtonItem
        let backBarButton = UIButton()
        backBarButton.size = CGSize(width: 26, height: 26)
        backBarButton.setImage(UIImage(nameInBundle: "detailBackBtn"), for: .normal)
        backBarButton.addTarget(self, action: #selector(popViewControllerAnimated), for: .touchUpInside)
        fd.navigationItem.leftBarButtonItem = FDBarButtonItem(customView: backBarButton)
        // rightBarButtonItems
        let shareBarButton = UIButton()
        shareBarButton.size = CGSize(width: 28, height: 28)
        shareBarButton.setImage(UIImage(nameInBundle: "detailShare"), for: .normal)
        shareBarButton.addTarget(self, action: #selector(shareComic), for: .touchUpInside)
        let downloadBarButton = UIButton()
        downloadBarButton.size = CGSize(width: 28, height: 28)
        downloadBarButton.setImage(UIImage(nameInBundle: "detailDownBtn"), for: .normal)
        downloadBarButton.addTarget(self, action: #selector(downloadComics), for: .touchUpInside)
        fd.navigationItem.rightBarButtonItems = [FDBarButtonItem(customView: shareBarButton),
                                                 FDBarButtonItem(customView: downloadBarButton)]
    }
    
    private func buildUI() {
        view.backgroundColor = .white
        // 使用FDNavigationBar以后
        // controller的第一个subview是FDNavigationBar
        // 这个本身就是失效的 写不写也就那样了
        automaticallyAdjustsScrollViewInsets = false
        
        view.addSubview(coverImageView)
        coverImageView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            // 附加的10pt是用来显示圆角的
            make.height.equalTo(155 + 10 + fd.fullNavbarHeight)
        }
        
        view.addSubview(toolBar)
        toolBar.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
            make.height.equalTo(55)
        }
        
        tableView.backgroundView = previewView
        // 60是剩余部分, 155 + fd.fullNavbarHeight是图片高度
        tableView.contentInset = UIEdgeInsets(top: 155 + 60, left: 0, bottom: 0, right: 0)
        tableView.setContentOffset(CGPoint(x: 0, y: -(155 + 60)), animated: false)
        // 避免挡住阴影
        view.insertSubview(tableView, belowSubview: toolBar)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(fd.fullNavbarHeight)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(toolBar.snp.top)
        }
    }
}
