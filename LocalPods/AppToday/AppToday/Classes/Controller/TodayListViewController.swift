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
import RxDataSources

class TodayListViewController: UIViewController {

    // 传递当前页是星期几
    var weekday: String?
    
    private lazy var tableView: UITableView = {
        let v = UITableView()
        v.separatorStyle = .none
        v.estimatedRowHeight = 280
        v.showsVerticalScrollIndicator = true
        v.fate.register(cellClass: TodayRecommendCell.self)
        if #available(iOS 11, *) {
            v.contentInsetAdjustmentBehavior = .never
        }
        return v
    }()
    
    private lazy var dataSource = tableViewSectionedReloadDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
    }
    
    deinit { NSLog("\(className()) is deallocating...") }
}

extension TodayListViewController: View {
    func bind(reactor: TodayListViewReactor) {
            
        // MARK: 请求数据
        rx.viewDidLoad
            .map { [weak self] in Reactor.Action.getRecommendList(self?.weekday) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: 下拉刷新
        tableView.gifHeader.rx.refresh
            .debounce(1, scheduler: MainScheduler.instance)
            .takeWhen { $0 == .refreshing }
            .discard()
            .map { [weak self] in Reactor.Action.getRecommendList(self?.weekday) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: 修改刷新控件的状态
        reactor.state
            .map { $0.refreshState.downState }
            .bind(to: tableView.gifHeader.rx.refresh)
            .disposed(by: disposeBag)
        
        // MARK: 绑定数据源
        reactor.state
            .map { $0.sections }
            .bind(to: tableView.rx.items(dataSource: dataSource))
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
    
    private func tableViewSectionedReloadDataSource() -> RxTableViewSectionedReloadDataSource<TodayRecommendSection> {
        return RxTableViewSectionedReloadDataSource(configureCell: { (dataSource, tableView, indexPath, display) in
            let cell: TodayRecommendCell = tableView.fate.dequeueReusableCell(for: indexPath)
            cell.display = display
            return cell
        })
    }
}

extension TodayListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.fate.heightForRowAt(indexPath, cellClass: TodayRecommendCell.self, configuration: { (cell) in
            cell.display = self.dataSource[indexPath]
        })
    }
}

extension TodayListViewController {
    private func buildUI() {
        automaticallyAdjustsScrollViewInsets = false
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
