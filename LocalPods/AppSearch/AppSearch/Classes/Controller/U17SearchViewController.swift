//
//  U17SearchViewController.swift
//  AppSearch
//
//  Created by Archer on 2018/12/4.
//

import Fate
import RxSwift
import RxCocoa
import RxSwiftExt
import ReactorKit
import RxAppState
import RxDataSources

class U17SearchViewController: UIViewController {
    
    private lazy var searchBar: U17SearchBar = {
        let width = view.width - 70
        let height = 25.toCGFloat()
        return U17SearchBar(size: CGSize(width: width, height: height))
    }()
    
    private lazy var tableView: UITableView = {
        let v = UITableView(frame: .zero, style: .grouped)
        v.estimatedRowHeight = 40
        v.separatorStyle = .none
        v.backgroundColor = .white
        v.fate.register(cellClass: U17HotSearchCell.self)
        v.fate.register(cellClass: U17HistorySearchCell.self)
        if #available(iOS 11, *) {
            v.contentInsetAdjustmentBehavior = .never
        }
        return v
    }()
    
    private lazy var placeholderView = U17PlaceholderView()
    
    private lazy var dataSource = tableViewSectionedAnimatedDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        buildNavbar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.resignFirstResponder()
    }
}

extension U17SearchViewController {
    // MARK: 取消搜索
    @objc private func popViewController() {
        self.navigationController?.popViewController(animated: false)
    }
}

extension U17SearchViewController: View {
    func bind(reactor: U17SearchViewReactor) {
        
        // MARK: 设置代理
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        // MARK: 占位图点击
        placeholderView.rx.tap
            .map { _ in Reactor.Action.getHotKeywords }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: 占位图状态变化
        reactor.state
            .map { $0.placeholderState }
            .bind(to: placeholderView.rx.state)
            .disposed(by: disposeBag)
        
        // MARK: 加载数据
        rx.viewDidLoad
            .map { Reactor.Action.getHotKeywords }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: 绑定数据源
        reactor.state
            .map { $0.sections }
            .filterEmpty()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        // MARK: 设置占位文字
        reactor.state
            .map { $0.placeholderText }
            .filterNil()
            .bind(to: searchBar.rx.placeholderText)
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
    
    private func tableViewSectionedAnimatedDataSource() -> RxTableViewSectionedAnimatedDataSource<SearchSection> {
        return RxTableViewSectionedAnimatedDataSource(configureCell: { (ds, tv, ip, item) in
            switch item {
            case .hot(row: _, item: let display):
                let cell: U17HotSearchCell = tv.fate.dequeueReusableCell(for: ip)
                cell.disposeBag = DisposeBag()
                cell.display = display
                cell.rx.tap
                    .subscribeNext(weak: self, { (self) in
                        return { (keyword) in
                            debugPrint(keyword)
                        }
                    }).disposed(by: cell.disposeBag)
                return cell
                
            case .history(row: _, item: let display):
                fatalError()
            }
        })
    }
}

extension U17SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.fate.heightForRowAt(indexPath, cellClass: U17HotSearchCell.self, configuration: { (cell) in
            if case let .hot(row: _, item: display) = self.dataSource[indexPath] {
                cell.display = display
            }
        })
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = U17SearchHeaderView()
        view.disposeBag = DisposeBag()
        view.displayMode = (section == 0) ? .hot : .history
        view.rx.event
            .flatMap { (displayMode) -> Observable<Reactor.Action> in
                switch displayMode {
                case .hot: return .just(Reactor.Action.getHotKeywords)
                    
                case .history: return .empty()
                }
            }.bind(to: reactor!.action) // It's safe to force-unwrap here
            .disposed(by: view.disposeBag)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}

extension U17SearchViewController {
    func buildNavbar() {
        navigationItem.hidesBackButton = true
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: .plain,
                                                            target: self, action: #selector(popViewController))
        let titleTextAttributes: [NSAttributedString.Key : Any] = [.font : UIFont.systemFont(ofSize: 15),
                                                                   .foregroundColor : U17def.gray_9B9B9B]
        navigationItem.rightBarButtonItem?.setTitleTextAttributes(titleTextAttributes, for: .normal)
        navigationItem.rightBarButtonItem?.setTitleTextAttributes(titleTextAttributes, for: .selected)
    }
    
    func buildUI() {
        view.backgroundColor = .white
        automaticallyAdjustsScrollViewInsets = false
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.bottom.equalToSuperview()
        }
        
        placeholderView.contentInset = UIEdgeInsets(top: -fate.fullNavbarHeight,
                                                    left: 0, bottom: 0, right: 0)
        view.addSubview(placeholderView)
        placeholderView.snp.makeConstraints { (make) in
            make.edges.equalTo(tableView)
        }
    }
}
