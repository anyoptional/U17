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
import RxSwiftExt
import ReactorKit
import RxAppState
import RxSkeleton
import RxDataSources

class TodayListViewController: UIViewController {

    // 传递当前页是星期几
    var weekday: String?
    
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
    
    private lazy var dataSource = tableViewSectionedReloadDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        showSkeleton()
    }
    
    private func showSkeleton() {
        collectionView.prepareSkeleton { (flag) in
            self.view.showAnimatedGradientSkeleton()
            // MARK: 请求数据
            guard let reactor = self.reactor else { return }
            Observable.just(Reactor.Action.getRecommendList(self.weekday))
                .bind(to: reactor.action)
                .disposed(by: self.disposeBag)
        }
    }
    
    deinit { NSLog("\(className()) is deallocating...") }
}

extension TodayListViewController: View {
    func bind(reactor: TodayListViewReactor) {
    
        // MARK: 下拉刷新
        collectionView.gifHeader.rx.refresh
            .debounce(1, scheduler: MainScheduler.instance)
            .takeWhen { $0 == .refreshing }
            .discard()
            .map { [weak self] in Reactor.Action.getRecommendList(self?.weekday) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: 修改刷新控件的状态
        reactor.state
            .map { $0.refreshState.downState }
            .bind(to: collectionView.gifHeader.rx.refresh)
            .disposed(by: disposeBag)
        
        // MARK: 绑定数据源
        reactor.state
            .map { $0.sections }
            .filterEmpty()
            .do(onNext: { [weak self] _ in self?.view.hideSkeleton() })
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        // MARK: 处理出错
        reactor.state
            .map { $0.error }
            .filterNil()
            .subscribeNext(weak: self) { (self) in
                return { error in
                    debugPrint("error = \(error)")
                }
            }.disposed(by: disposeBag)
    }
    
    private func tableViewSectionedReloadDataSource() -> RxCollectionViewSkeletonedReloadDataSource<TodayRecommendSection> {
        return RxCollectionViewSkeletonedReloadDataSource(configureCell: { (dataSource, tableView, indexPath, display) in
            let cell: TodayRecommendCell = tableView.fate.dequeueReusableCell(for: indexPath)
            cell.display = display
            return cell
        }, skeletonReuseIdentifierForItemAtIndex: { (ds, tv, ip) in
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
    }
}
