
//
//  Section.swift
//  Bindable
//
//  Created by Archer on 2018/11/21.
//

import RxDataSources

// A wrapper for table/collection view sectioned data source
public struct UITableCollectionViewSection<ItemType: Displayable> {
    public var items: [Item]
}

extension UITableCollectionViewSection: SectionModelType {
    public typealias Item = ItemType
}

extension UITableCollectionViewSection: CustomStringConvertible {
    public var description: String {
        return "items = \(items)"
    }
}

public extension UITableCollectionViewSection {
    public init(original: UITableCollectionViewSection<Item>, items: [Item]) {
        self = original
        self.items = items
    }
}
