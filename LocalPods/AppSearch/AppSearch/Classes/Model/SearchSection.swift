//
//  SearchSection.swift
//  AppSearch
//
//  Created by Archer on 2018/12/6.
//

import RxDataSources

enum SearchSection {
    /// 在第几段 有哪些item
    case hot(section: Int, items: [SearchSectionItem])
    case history(section: Int, items: [SearchSectionItem])
}

enum SearchSectionItem {
    /// 在第几行 是哪个item
    case hot(row: Int, item: U17HotSearchCellDisplay)
    case history(row: Int, item: U17HistorySearchCellDisplay)
}

extension SearchSectionItem: IdentifiableType, Equatable {
    typealias Identity = Int
    
    var identity: Int {
        switch self {
        case .hot(row: let row, item: _):
            return row
        case .history(row: let row, item: _):
            return row
        }
    }
}

extension SearchSection: AnimatableSectionModelType {
    typealias Item = SearchSectionItem
    typealias Identity = Int.Identity
    
    var items: [SearchSectionItem] {
        switch self {
        case .hot(section: _, items: let items):
            return items
        case .history(section: _, items: let items):
            return items
        }
    }
    
    var identity: Int.Identity {
        switch self {
        case .hot(section: let section, items: _):
            return section
        case .history(section: let section, items: _):
            return section
        }
    }
    
    init(original: SearchSection, items: [SearchSectionItem]) {
        switch original {
        case .hot(section: let section, items: _):
            self = .hot(section: section, items: items)
        case .history(section: let section, items: _):
            self = .history(section: section, items: items)
        }
    }
}

