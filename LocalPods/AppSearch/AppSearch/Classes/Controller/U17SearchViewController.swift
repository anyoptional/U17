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
        let searchBar = U17SearchBar(size: CGSize(width: width, height: height))
        navigationItem.titleView = searchBar
        return searchBar
    }()
    
    private lazy var tableView: UITableView = {
        let v = UITableView(frame: .zero, style: .grouped)
        v.estimatedRowHeight = 40
        v.separatorStyle = .none
        v.backgroundColor = .white
        v.keyboardDismissMode = .onDrag
        v.rowHeight = UITableView.automaticDimension
        v.fate.register(cellClass: U17HotSearchCell.self)
        v.fate.register(cellClass: U17HistorySearchCell.self)
        v.fate.register(cellClass: U17KeywordRelativeCell.self)
        if #available(iOS 11, *) {
            v.contentInsetAdjustmentBehavior = .never
        }
        return v
    }()
    
    private lazy var placeholderView = U17PlaceholderView()
    
    private lazy var dataSource = tableViewSectionedAnimatedDataSource()
    
    /// 是否正在搜索
    private lazy var isSearching = false
    
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
            // 点击的时候切换到加载状态(菊花转)
            .do(onNext: { [weak self] _ in self?.placeholderView.state = .loading })
            .map { _ in Reactor.Action.getHotKeywords }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: 占位图状态变化
        reactor.state
            .map { $0.placeholderState }
            .bind(to: placeholderView.rx.state)
            .disposed(by: disposeBag)
        
        // MARK: 加载数据
        // NOTE: searchBar.rx.text在bind时会发出当前的text
        // searchBar默认是没有文字的 所以flatMap之后会触发getHotKeywords
        // 这里的就不需要了
//        rx.viewDidLoad
//            .map { Reactor.Action.getHotKeywords }
//            .bind(to: reactor.action)
//            .disposed(by: disposeBag)
        
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
        
        // MARK: 清空时加载热门关键词
        // NOTE: searchBar.rx.text监听的时text editing event
        // 并不包含手动赋值 所以这里清除时需要手动刷新
        searchBar.rx.clear
            .do(onNext: { [weak self] in
                // 标记搜索结束
                self?.isSearching = false
                // 标记正在加载
                self?.placeholderView.state = .loading
            }).map { Reactor.Action.getHotKeywords }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: 搜索
        searchBar
            .rx.text.orEmpty
            // 不重复搜索
            .distinctUntilChanged()
            // 在0.5s内不连续搜索
            .throttle(0.5, scheduler: MainScheduler.instance)
            .flatMap({ [weak self] (keyword) -> Observable<Reactor.Action> in
                // 标记搜索状态
                self?.isSearching = keyword.isNotBlank
                // 标记正在加载
                self?.placeholderView.state = .loading
                // 如果是删光了就加载热门关键词
                // 否则就开始搜索
                let action = keyword.isBlank ? Reactor.Action.getHotKeywords
                                             : Reactor.Action.getKeywordRelative(keyword)
                return .just(action)
            }).bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: cell点击
        tableView
            .rx.modelSelected(SearchSectionItem.self)
            .subscribeNext(weak: self) { (self) in
                return { (sectionItem) in
                    var searchingKeyword = ""
                    switch sectionItem {
                    case let .hot(row: row , item: item):
                        searchingKeyword = item.state.rawValue.hotItems![row].name.filterNil()
                    case .history(row: _, item: let item): break
                        
                    case .relative(row: _, item: let item): break
                        
                    }
                }
            }.disposed(by: disposeBag)
        
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
        return RxTableViewSectionedAnimatedDataSource(
            animationConfiguration: AnimationConfiguration(insertAnimation: .none,
                                                           reloadAnimation: .none,
                                                           deleteAnimation: .none),
            configureCell: { (ds, tv, ip, sectionItem) in
                switch sectionItem {
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
                    
                case .relative(row: _, item: let display):
                    let cell: U17KeywordRelativeCell = tv.fate.dequeueReusableCell(for: ip)
                    cell.display = display
                    return cell
                }
        })
    }
}

extension U17SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {        
        switch dataSource[indexPath] {
        case .hot(row: _, item: let display):
            return tableView.fate.heightForRowAt(indexPath, cellClass: U17HotSearchCell.self, configuration: { (cell) in
                cell.display = display
            })
            
        case .history(row: _, item: let display):
            return tableView.fate.heightForRowAt(indexPath, cellClass: U17HistorySearchCell.self, configuration: { (cell) in
                cell.display = display
            })
            
        case .relative(row: _, item: let display):
            return tableView.fate.heightForRowAt(indexPath, cellClass: U17KeywordRelativeCell.self, configuration: { (cell) in
                cell.display = display
            })
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // 不在搜索状态才有headerView
        guard !isSearching else { return nil }
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
        // 不在搜索状态才有headerView
        guard !isSearching else { return 0 }
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: .plain,
                                                            target: self, action: #selector(popViewController))
        let titleTextAttributes: [NSAttributedString.Key : Any] = [.font : UIFont.systemFont(ofSize: 15),
                                                                   .foregroundColor : U17def.gray_AAAAAA]
        navigationItem.rightBarButtonItem?.setTitleTextAttributes(titleTextAttributes, for: .normal)
        navigationItem.rightBarButtonItem?.setTitleTextAttributes(titleTextAttributes, for: .highlighted)
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
