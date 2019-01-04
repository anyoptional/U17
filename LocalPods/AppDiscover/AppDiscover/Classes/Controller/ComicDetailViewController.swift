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
import RxSwiftExt
import ReactorKit
import RxAppState

class ComicDetailViewController: UIViewController {

    /// 漫画ID
    var comicId = ""
    
    override var prefersNavigationBarStyle: UINavigationBarStyle {
        return .custom
    }
    
    private lazy var previewView = ComicPreviewView()
    private lazy var scrollView = UIScrollView()
    private lazy var containerView = UIView()
    private lazy var toolBar = ComicToolBar()
    
    private lazy var placeholderView = U17PlaceholderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        buildNavbar()
    }
    
    deinit { NSLog("\(className()) is deallocating...") }
}

extension ComicDetailViewController: View {
    func bind(reactor: ComicDetailViewReactor) {
        
        // MARK: 跳转分类
        previewView.rx.showsCategory
            .subscribeNext(weak: self) { (self) in
                return self.showsCategory
            }.disposed(by: disposeBag)
        
        // MARK: 查看其他作品
        previewView.rx.showsOtherWork
            .subscribeNext(weak: self) { (self) in
                return { _ in
                    SwiftyHUD.show("其他作品是不可能给你看滴~")
                }
            }.disposed(by: disposeBag)
        
        // MARK: 投月票
        toolBar.rx.sendTicket
            .subscribeNext(weak: self) { (self) in
                return { _ in
                    SwiftyHUD.show("月票是不可能给投月票滴~")
                }
            }.disposed(by: disposeBag)
        
        // MARK: 评论区
        toolBar.rx.sendComment
            .subscribeNext(weak: self) { (self) in
                return { _ in
                    SwiftyHUD.show("评论是不可能给评论滴~")
                }
            }.disposed(by: disposeBag)
        
        // MARK: 请求数据
        rx.viewDidLoad
            .map { [weak self] _ in Reactor.Action.getStaticDetail(self?.comicId) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        // MARK: 绑定数据
        reactor.state
            .map { $0.previewViewDisplay }
            .filterNil()
            .bind(to: previewView.rx.display)
            .disposed(by: disposeBag)
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
}

extension ComicDetailViewController {
    private func buildNavbar() {
        fd.navigationBar.barTintColor = .clear
        fd.navigationBar.contentMargin = FDMargin(left: 10, right: 9)
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
        
        view.addSubview(previewView)
        previewView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            // 60是剩余部分
            // 155 + fd.fullNavbarHeight是图片高度
            make.height.equalTo(155 + fd.fullNavbarHeight + 60)
        }
        
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        scrollView.contentInset = UIEdgeInsets(top: 155 + 60, left: 0, bottom: 0, right: 0)
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(fd.fullNavbarHeight)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(toolBar.snp.top)
        }
        
//        scrollView.addSubview(containerView)
//        containerView.snp.makeConstraints { (make) in
//            make.edges.width.equalToSuperview()
//            make.height.greaterThanOrEqualTo(scrollView).offset(1)
//        }
        
        
    }
}
