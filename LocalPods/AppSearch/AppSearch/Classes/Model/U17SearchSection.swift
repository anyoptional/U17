//
//  U17SearchSection.swift
//  AppSearch
//
//  Created by Archer on 2018/12/6.
//

import RxDataSources

enum U17SearchSection {
    /// 有哪些item
    case hot(items: [U17SearchSectionItem])
    case history(items: [U17SearchSectionItem])
    case relative(items: [U17SearchSectionItem])
    case searchResult(items: [U17SearchSectionItem])
}

enum U17SearchSectionItem {
    /// 是哪个item
    case hot(item: U17HotSearchCellDisplay)
    case history(item: U17HistorySearchCellDisplay)
    case relative(item: U17KeywordRelativeCellDisplay)
    case searchResult(item: U17SearchResultCellDisplay)
}

extension U17SearchSection: SectionModelType {
    typealias Item = U17SearchSectionItem
    
    var items: [U17SearchSectionItem] {
        switch self {
        case .hot(items: let items):
            return items
        case .history(items: let items):
            return items
        case .relative(items: let items):
            return items
        case .searchResult(items: let items):
            return items
        }
    }
    
    init(original: U17SearchSection, items: [U17SearchSectionItem]) {
        switch original {
        case .hot(items: _):
            self = .hot(items: items)
        case .history(items: _):
            self = .history(items: items)
        case .relative(items: _):
            self = .relative(items: items)
        case .searchResult(items: _):
            self = .searchResult(items: items)
        }
    }
}

