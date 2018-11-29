
//
//  Section.swift
//  Bindable
//
//  Created by Archer on 2018/11/21.
//

import RxDataSources

// A wrapper for table/collection view sectioned data source
public struct RxDataSourcesSection<ItemType: Displayable> {
    public var items: [Item]
    
    public init(items: [Item]) {
        self.items = items
    }
}

extension RxDataSourcesSection: SectionModelType {
    public typealias Item = ItemType
}

extension RxDataSourcesSection: CustomStringConvertible {
    public var description: String {
        return "items = \(items)"
    }
}

public extension RxDataSourcesSection {
    public init(original: RxDataSourcesSection<Item>, items: [Item]) {
        self = original
        self.items = items
    }
}

// A wrapper for table/collection view sectioned data source
public struct RxDataSourcesOriginalSection<ItemType> {
    public var items: [Item]

    public init(items: [Item]) {
        self.items = items
    }
}

extension RxDataSourcesOriginalSection: SectionModelType {
    public typealias Item = ItemType
}

extension RxDataSourcesOriginalSection: CustomStringConvertible {
    public var description: String {
        return "items = \(items)"
    }
}

public extension RxDataSourcesOriginalSection {
    public init(original: RxDataSourcesOriginalSection<Item>, items: [Item]) {
        self = original
        self.items = items
    }
}
