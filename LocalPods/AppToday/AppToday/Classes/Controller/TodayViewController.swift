//
//  TodayViewController.swift
//  AppToday
//
//  Created by Archer on 2018/11/20.
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

class TodayViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let v = UITableView()
        v.separatorStyle = .none
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
        buildNavbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    deinit { NSLog("TodayViewController is deallocating...") }
}

extension TodayViewController: View {
    func bind(reactor: TodayViewReactor) {
        
        // MARK: 请求数据
        rx.viewDidLoad
            .map { Reactor.Action.getRecommendList }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: 下拉刷新
        tableView.gifHeader.rx.refresh
            .debounce(1, scheduler: MainScheduler.instance)
            .takeWhen { $0 == .refreshing }
            .map { _ in Reactor.Action.getRecommendList }
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

extension TodayViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.fate.heightForRowAt(indexPath, cellClass: TodayRecommendCell.self, configuration: { (cell) in
            cell.display = self.dataSource[indexPath]
        })
    }
}

extension TodayViewController {
    private func buildNavbar() {
        
    }
    
    private func buildUI() {
        automaticallyAdjustsScrollViewInsets = false
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(fate.statusBarHeight)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(0)
        }
    }
}
