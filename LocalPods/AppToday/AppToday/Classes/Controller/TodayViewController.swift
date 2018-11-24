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
import UITableView_FDTemplateLayoutCell

class TodayViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let v = UITableView()
        v.separatorStyle = .none
        v.showsVerticalScrollIndicator = false
        if #available(iOS 11, *) {
            v.contentInsetAdjustmentBehavior = .never
        }
        v.register(TodayRecommandCell.self, forCellReuseIdentifier: "cell")
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
            .map { Reactor.Action.getRecommandList }
            .bind(to: reactor.action)
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
    
    private func tableViewSectionedReloadDataSource() -> RxTableViewSectionedReloadDataSource<TodayRecommandSection> {
        return RxTableViewSectionedReloadDataSource(configureCell: { (ds, tv, ip, item) in
            let cell = tv.dequeueReusableCell(withIdentifier: "cell") as! TodayRecommandCell
            if case let .dayItemData(display) = ds[ip] {
                cell.display = display
            }
            return cell
        })
    }
}

extension TodayViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.fd_heightForCell(withIdentifier: "cell", cacheBy: indexPath, configuration: { [weak self] (cell) in
            guard let `self` = self else { return }
            let cell = cell as! TodayRecommandCell
            if case let .dayItemData(display) = self.dataSource[indexPath] {
                cell.display = display
            }
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
