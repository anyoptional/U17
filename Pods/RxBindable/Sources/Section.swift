
//
//  Section.swift
//  Bindable
//
//  Created by Archer on 2018/11/21.
//

import RxDataSources

// A wrapper for table/collection view sectioned reload data source
public struct RxTableCollectionViewReloadSection<ItemType: Displayable> {
    public var items: [ItemType]
    
    public init(items: [ItemType]) {
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
    public init(original: RxTableCollectionViewReloadSection<ItemType>, items: [Item]) {
        self = original
        self.items = items
    }
}


// A wrapper for table/collection view sectioned animated data source
public struct RxTableCollectionViewAnimatedSection<Section: IdentifiableType, ItemType: Displayable & IdentifiableType & Equatable> {
    
    public var tag: Section
    public var items: [ItemType]
    
    public init(tag: Section, items: [ItemType]) {
        self.tag = tag
        self.items = items
    }
}

extension RxTableCollectionViewAnimatedSection: AnimatableSectionModelType {
    public typealias Item = ItemType
    public typealias Identity = Section.Identity
    
    public var identity: Identity {
        return tag.identity
    }
    
    public var hashValue: Int {
        return tag.identity.hashValue
    }
    
    public init(original: RxTableCollectionViewAnimatedSection<Section, ItemType>, items: [ItemType]) {
        self.tag = original.tag
        self.items = items
    }
}

extension RxTableCollectionViewAnimatedSection: CustomStringConvertible {
    public var description: String {
        return "RxTableCollectionViewAnimatedSection(tag: \"\(tag)\", items: \(items))"
    }
}
