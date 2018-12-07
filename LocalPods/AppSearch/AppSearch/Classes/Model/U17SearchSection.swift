//
//  U17SearchSection.swift
//  AppSearch
//
//  Created by Archer on 2018/12/6.
//

import RxDataSources

enum U17SearchSection {
    /// 在第几段 有哪些item
    case hot(section: Int, items: [U17SearchSectionItem])
    case history(section: Int, items: [U17SearchSectionItem])
    case relative(section: Int, items: [U17SearchSectionItem])
}

enum U17SearchSectionItem {
    /// 在第几行 是哪个item
    case hot(row: Int, item: U17HotSearchCellDisplay)
    case history(row: Int, item: U17HistorySearchCellDisplay)
    case relative(row: Int, item: U17KeywordRelativeCellDisplay)
}

extension U17SearchSectionItem: IdentifiableType, Equatable {
    typealias Identity = Int
    
    var identity: Int {
        switch self {
        case .hot(row: let row, item: _):
            return row
        case .history(row: let row, item: _):
            return row
        case .relative(row: let row, item: _):
            return row
        }
    }
}

extension U17SearchSection: AnimatableSectionModelType {
    typealias Item = U17SearchSectionItem
    typealias Identity = Int.Identity
    
    var items: [U17SearchSectionItem] {
        switch self {
        case .hot(section: _, items: let items):
            return items
        case .history(section: _, items: let items):
            return items
        case .relative(section: _, items: let items):
            return items
        }
    }
    
    var identity: Int.Identity {
        switch self {
        case .hot(section: let section, items: _):
            return section
        case .history(section: let section, items: _):
            return section
        case .relative(section: let section, items: _):
            return section
        }
    }
    
    init(original: U17SearchSection, items: [U17SearchSectionItem]) {
        switch original {
        case .hot(section: let section, items: _):
            self = .hot(section: section, items: items)
        case .history(section: let section, items: _):
            self = .history(section: section, items: items)
        case .relative(section: let section, items: _):
            self = .relative(section: section, items: items)
        }
    }
}

