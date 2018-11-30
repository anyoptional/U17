//
//  TableViewSkeletonedDataSource.swift
//  RxSkeleton
//
//  Created by Archer on 2018/11/30.
//

import UIKit
import SkeletonView
import RxDataSources

public class TableViewSkeletonedDataSource<S: SectionModelType>
    : TableViewSectionedDataSource<S>
    , SkeletonTableViewDataSource {
    
    public typealias SkeletonNumberOfSections = (TableViewSkeletonedDataSource<S>, UITableView) -> Int
    public typealias SkeletonNumberOfRowsInSection = (TableViewSkeletonedDataSource<S>, UITableView, Int) -> Int
    public typealias SkeletonReuseIdentifierForRowAtIndex = (TableViewSkeletonedDataSource<S>, UITableView, IndexPath) -> String
    
    #if os(iOS)
    public init(configureCell: @escaping ConfigureCell,
                titleForHeaderInSection: @escaping  TitleForHeaderInSection = { _, _ in nil },
                titleForFooterInSection: @escaping TitleForFooterInSection = { _, _ in nil },
                canEditRowAtIndexPath: @escaping CanEditRowAtIndexPath = { _, _ in false },
                canMoveRowAtIndexPath: @escaping CanMoveRowAtIndexPath = { _, _ in false },
                sectionIndexTitles: @escaping SectionIndexTitles = { _ in nil },
                sectionForSectionIndexTitle: @escaping SectionForSectionIndexTitle = { _, _, index in index },
                skeletonNumberOfSections: @escaping SkeletonNumberOfSections,
                skeletonNumberOfRowsInSection: @escaping SkeletonNumberOfRowsInSection,
                skeletonReuseIdentifierForRowAtIndex: @escaping SkeletonReuseIdentifierForRowAtIndex) {
        self.skeletonNumberOfSections = skeletonNumberOfSections
        self.skeletonNumberOfRowsInSection = skeletonNumberOfRowsInSection
        self.skeletonReuseIdentifierForRowAtIndex = skeletonReuseIdentifierForRowAtIndex
        super.init(configureCell: configureCell,
                   titleForHeaderInSection: titleForHeaderInSection,
                   titleForFooterInSection: titleForFooterInSection,
                   canEditRowAtIndexPath: canEditRowAtIndexPath,
                   canMoveRowAtIndexPath: canMoveRowAtIndexPath,
                   sectionIndexTitles: sectionIndexTitles,
                   sectionForSectionIndexTitle: sectionForSectionIndexTitle)
    }
    #else
    public init(configureCell: @escaping ConfigureCell,
                titleForHeaderInSection: @escaping  TitleForHeaderInSection = { _, _ in nil },
                titleForFooterInSection: @escaping TitleForFooterInSection = { _, _ in nil },
                canEditRowAtIndexPath: @escaping CanEditRowAtIndexPath = { _, _ in false },
                canMoveRowAtIndexPath: @escaping CanMoveRowAtIndexPath = { _, _ in false },
                skeletonNumberOfSections: @escaping SkeletonNumberOfSections,
                skeletonNumberOfRowsInSection: @escaping SkeletonNumberOfRowsInSection,
                skeletonReuseIdentifierForRowAtIndex: @escaping SkeletonReuseIdentifierForRowAtIndex) {
        self.skeletonNumberOfSections = skeletonNumberOfSections
        self.skeletonNumberOfRowsInSection = skeletonNumberOfRowsInSection
        self.skeletonReuseIdentifierForRowAtIndex = skeletonReuseIdentifierForRowAtIndex
        super.init(configureCell: configureCell,
                   titleForHeaderInSection: titleForHeaderInSection,
                   titleForFooterInSection: titleForFooterInSection,
                   canEditRowAtIndexPath: canEditRowAtIndexPath,
                   canMoveRowAtIndexPath: canMoveRowAtIndexPath)
    }
    #endif
    
    #if DEBUG
    // If data source has already been bound, then mutating it
    // afterwards isn't something desired.
    // This simulates immutability after binding
    var _dataSourceBound: Bool = false
    
    private func ensureNotMutatedAfterBinding() {
        assert(!_dataSourceBound, "Data source is already bound. Please write this line before binding call (`bindTo`, `drive`). Data source must first be completely configured, and then bound after that, otherwise there could be runtime bugs, glitches, or partial malfunctions.")
    }
    
    #endif
    
    public var skeletonNumberOfSections: SkeletonNumberOfSections {
        didSet {
            #if DEBUG
            ensureNotMutatedAfterBinding()
            #endif
        }
    }
    
    public var skeletonNumberOfRowsInSection: SkeletonNumberOfRowsInSection {
        didSet {
            #if DEBUG
            ensureNotMutatedAfterBinding()
            #endif
        }
    }
    
    public var skeletonReuseIdentifierForRowAtIndex: SkeletonReuseIdentifierForRowAtIndex {
        didSet {
            #if DEBUG
            ensureNotMutatedAfterBinding()
            #endif
        }
    }
    
    public func numSections(in collectionSkeletonView: UITableView) -> Int {
        return skeletonNumberOfSections(self, collectionSkeletonView)
    }
    
    public func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return skeletonNumberOfRowsInSection(self, skeletonView, section)
    }
    
    public func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> String {
        return skeletonReuseIdentifierForRowAtIndex(self, skeletonView, indexPath)
    }
}
