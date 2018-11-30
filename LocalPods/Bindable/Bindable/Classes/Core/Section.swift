
//
//  Section.swift
//  Bindable
//
//  Created by Archer on 2018/11/21.
//

import RxDataSources

// A wrapper for table/collection view sectioned data source
public struct RxTableCollectionViewSection<ItemType: Displayable> {
    public var items: [Item]
    
    public init(items: [Item]) {
        self.items = items
    }
}

extension RxTableCollectionViewSection: SectionModelType {
    public typealias Item = ItemType
}

extension RxTableCollectionViewSection: CustomStringConvertible {
    public var description: String {
        return "items = \(items)"
    }
}

public extension RxTableCollectionViewSection {
    public init(original: RxTableCollectionViewSection<Item>, items: [Item]) {
        self = original
        self.items = items
    }
}
