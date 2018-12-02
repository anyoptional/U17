
//
//  Section.swift
//  Bindable
//
//  Created by Archer on 2018/11/21.
//

import RxDataSources

// A wrapper for table/collection view sectioned reload data source
public struct RxTableCollectionViewReloadSection<ItemType: Displayable> {
    public var items: [Item]
    
    public init(items: [Item]) {
        self.items = items
    }
}

extension RxTableCollectionViewReloadSection: SectionModelType {
    public typealias Item = ItemType
}

extension RxTableCollectionViewReloadSection: CustomStringConvertible {
    public var description: String {
        return "RxTableCollectionViewReloadSection(items = \(items))"
    }
}

public extension RxTableCollectionViewReloadSection {
    public init(original: RxTableCollectionViewReloadSection<Item>, items: [Item]) {
        self = original
        self.items = items
    }
}


// A wrapper for table/collection view sectioned animated data source
public struct RxTableCollectionViewAnimatedSection<ItemType: Displayable & IdentifiableType & Equatable> {
    
    public var section: Int
    public var items: [Item]

    public init(section: Int, items: [Item]) {
        self.section = section
        self.items = items
    }
}

extension RxTableCollectionViewAnimatedSection: AnimatableSectionModelType {
    public typealias Item = ItemType
    public typealias Identity = Int.Identity
    
    public var identity: Int.Identity {
        return section
    }
    
    public var hashValue: Int {
        return self.section.identity.hashValue
    }
    
    public init(original: RxTableCollectionViewAnimatedSection<ItemType>, items: [ItemType]) {
        self = original
        self.items = items
    }
}

extension RxTableCollectionViewAnimatedSection: CustomStringConvertible {
    public var description: String {
        return "RxTableCollectionViewAnimatedSection(section: \"\(section)\", items: \(items))"
    }
}
