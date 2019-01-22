//
//  TodayListViewController.swift
//  AppToday
//
//  Created by Archer on 2018/11/29.
//

import Fate
import RxMoya
import RxSwift
import SnapKit
import RxCocoa
import Mediator
import RxSwiftExt
import ReactorKit
import RxAppState
import RxSkeleton
import RxDataSources

class TodayListViewController: UIViewController {

    // 传递当前页是星期几
    var weekday: String?
    // 当前页是否是第一页
    var isFirstPage: Bool = false {
        didSet {
            if isFirstPage {                
                collectionView.todayFooter.displayMode = .normal
            } else {
                collectionView.todayFooter.displayMode = .specific
            }
        }
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
        v.isSkeletonable = true
        v.backgroundColor = .white
        v.delegate = self
        v.showsVerticalScrollIndicator = true
        v.fate.register(TodayRecommendCell.self)
        if #available(iOS 11, *) {
            v.contentInsetAdjustmentBehavior = .never
        }
        return v
    }()
    
    private lazy var placeholderView = U17PlaceholderView()
    
    private lazy var dataSource = collectionViewSkeletonedAnimatedDataSource()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        showSkeleton()
    }
    
    deinit { NSLog("\(className()) is deallocating...") }
}

extension TodayListViewController {
    private func showSkeleton() {
        collectionView.prepareSkeleton { (flag) in
            self.view.showAnimatedGradientSkeleton()
            // MARK: 请求数据
            self.reactor?
                .accept(.pullToRefresh(self.weekday))
                .disposed(by: self.disposeBag)
        }
    }
}

extension TodayListViewController: View {
    func bind(reactor: TodayListViewReactor) {
    
        // MARK: 占位图点击
        placeholderView.rx.tap
            // 点击的时候切换到加载状态(菊花转)
            .do(onNext: { [weak self] _ in self?.placeholderView.state = .loading })
            .map { [weak self] _ in Reactor.Action.pullToRefresh(self?.weekday) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: 占位图状态变化
        reactor.state
            .map { $0.placeholderState }
            .bind(to: placeholderView.rx.state)
            .disposed(by: disposeBag)
        
        // MARK: 下拉刷新
        collectionView.gifHeader.rx.refresh
            .debounce(1, scheduler: MainScheduler.instance)
            // 只在refreshing时才加载
            .takeWhen { $0 == .refreshing }
            .discard()
            .map { [weak self] in Reactor.Action.pullToRefresh(self?.weekday) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: 上拉刷新
        collectionView.todayFooter.rx.refresh
            .debounce(1, scheduler: MainScheduler.instance)
            .takeWhen { $0 == .refreshing }
            .discard()
            .map { [weak self] in Reactor.Action.pullUpToRefresh(self?.weekday) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: 修改下拉状态
        reactor.state
            .map { $0.refreshState.downState }
            .bind(to: collectionView.gifHeader.rx.refresh)
            .disposed(by: disposeBag)
        
        // MARK: 修改上拉状态
        reactor.state
            .map { $0.refreshState.upState }
            .bind(to: collectionView.todayFooter.rx.refresh)
            .disposed(by: disposeBag)
        
        // MARK: 绑定数据源
        reactor.state
            .map { $0.sections }
            // 有数据回来时不显示skeletonView
            .do(onNext: { [weak self] _ in self?.view.hideSkeleton() })
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        // MARK: 处理出错
        reactor.state
            .map { $0.error }
            .filterNil()
            .subscribeNext(weak: self) { (self) in
                return { error in
                    // 由占位图显示
                    // 不需要skeletonView
                    self.view.hideSkeleton()
                    SwiftyHUD.show(error.message)
                }
            }.disposed(by: disposeBag)
    }
    
    private func collectionViewSkeletonedAnimatedDataSource() -> RxCollectionViewSkeletonedAnimatedDataSource<TodayRecommendSection> {
        /// 注意这个闭包对self的引用
        return RxCollectionViewSkeletonedAnimatedDataSource(configureCell: { [weak self] (ds, cv, ip, display) in
            let cell: TodayRecommendCell = cv.fate.dequeueReusableCell(for: ip)
            // 解决cell重用时取消订阅的问题
            cell.disposeBag = DisposeBag()
            cell.display = display
            // 查看全集
            cell.rx.showComics
                .subscribe(onNext: { (comicId) in
                    withExtendedLifetime(self, { (self) in
                        /// 在我看来，涉及大组件的访问才有路由/中介的必要
                        /// 一个组件内的页面间跳转采用路由的形式真的是多此一举
                        /// 直接用导航控制器跳转就好了啊，干嘛整那么复杂呢~~~
                        /// URL字符串写起来它是真的烦呐
                        if let vc = Mediator.getComicDetailViewController(withComicId: comicId) {
                            self?.navigationController?.pushViewController(vc, animated: true)
                        }
                    })
                }).disposed(by: cell.disposeBag)
            return cell
            
        }, reuseIdentifierForItemAtIndexPath: { (ds, cv, ip) in
            return TodayRecommendCell.reuseIdentifier
        })
    }
}

extension TodayListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.width, height: 315)
    }
}

extension TodayListViewController {
    private func buildUI() {
        view.isSkeletonable = true
        automaticallyAdjustsScrollViewInsets = false
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(placeholderView)
        placeholderView.snp.makeConstraints { (make) in
            make.edges.equalTo(collectionView)
        }
    }
}
