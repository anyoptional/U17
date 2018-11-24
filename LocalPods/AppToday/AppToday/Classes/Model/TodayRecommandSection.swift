//
//  TodayRecommandSection.swift
//  AppToday
//
//  Created by Archer on 2018/11/23.
//

import RxDataSources

enum TodayRecommandSection {
    case dayItemDataList(items: [TodayRecommandSectionItem])
}

enum TodayRecommandSectionItem {
    case dayItemData(item: TodayRecommandCellDisplay)
}

extension TodayRecommandSection: SectionModelType {
    
    typealias Item = TodayRecommandSectionItem
    
    var items: [TodayRecommandSectionItem] {
        switch self {
        case let .dayItemDataList(items):
            return items
        }
    }
    
    init(original: TodayRecommandSection, items: [TodayRecommandSectionItem]) {
        switch original {
        case .dayItemDataList:
            self = .dayItemDataList(items: items)
        }
    }
}
