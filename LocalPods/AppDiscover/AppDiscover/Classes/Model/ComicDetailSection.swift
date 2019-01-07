//
//  ComicDetailSection.swift
//  AppDiscover
//
//  Created by Archer on 2019/1/7.
//

import RxDataSources

/// 漫画详情
enum ComicDetailSection {
    /// 有哪些item
    case chapter(items: [ComicDetailSectionItem])
    case guessLike(items: [ComicDetailSectionItem])
}

enum ComicDetailSectionItem {
    /// 是哪个item
    case chapter(item: ComicChapterCellDisplay)
    case guessLike(item: ComicGuessLikeCellDisplay)
}

extension ComicDetailSection: SectionModelType {
    typealias Item = ComicDetailSectionItem
    
    var items: [ComicDetailSectionItem] {
        switch self {
        case .chapter(items: let items):
            return items
        case .guessLike(items: let items):
            return items
        }
    }
    
    init(original: ComicDetailSection, items: [ComicDetailSectionItem]) {
        switch original {
        case .chapter(items: _):
            self = .chapter(items: items)
        case .guessLike(items: _):
            self = .guessLike(items: items)
        }
    }
}

