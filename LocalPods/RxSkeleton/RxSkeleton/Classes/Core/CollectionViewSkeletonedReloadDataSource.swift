//
//  CollectionViewSkeletonedReloadDataSource.swift
//  RxSkeleton
//
//  Created by Archer on 2018/11/30.
//

import UIKit
import SkeletonView
import RxDataSources

public class CollectionViewSkeletonedReloadDataSource<S: SectionModelType>
    : CollectionViewSectionedDataSource<S>
    , SkeletonCollectionViewDataSource {    
 
    public typealias SkeletonNumberOfSections = (CollectionViewSkeletonedReloadDataSource<S>, UICollectionView) -> Int
    public typealias SkeletonNumberOfItemsInSection = (CollectionViewSkeletonedReloadDataSource<S>, UICollectionView, Int) -> Int
    public typealias SkeletonReuseIdentifierForItemAtIndex = (CollectionViewSkeletonedReloadDataSource<S>, UICollectionView, IndexPath) -> String
    
    public init(configureCell: @escaping ConfigureCell,
                configureSupplementaryView: ConfigureSupplementaryView? = nil,
                moveItem: @escaping MoveItem = { _, _, _ in () },
                canMoveItemAtIndexPath: @escaping CanMoveItemAtIndexPath = { _, _ in false },
                skeletonNumberOfSections: @escaping SkeletonNumberOfSections,
                skeletonNumberOfItemsInSection: @escaping SkeletonNumberOfItemsInSection,
                skeletonReuseIdentifierForItemAtIndex: @escaping SkeletonReuseIdentifierForItemAtIndex) {
        self.skeletonNumberOfSections = skeletonNumberOfSections
        self.skeletonNumberOfItemsInSection = skeletonNumberOfItemsInSection
        self.skeletonReuseIdentifierForItemAtIndex = skeletonReuseIdentifierForItemAtIndex
        super.init(configureCell: configureCell,
                   configureSupplementaryView: configureSupplementaryView,
                   moveItem: moveItem, canMoveItemAtIndexPath: canMoveItemAtIndexPath)
    }
    
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
    
    public var skeletonNumberOfItemsInSection: SkeletonNumberOfItemsInSection {
        didSet {
            #if DEBUG
            ensureNotMutatedAfterBinding()
            #endif
        }
    }
    
    public var skeletonReuseIdentifierForItemAtIndex: SkeletonReuseIdentifierForItemAtIndex {
        didSet {
            #if DEBUG
            ensureNotMutatedAfterBinding()
            #endif
        }
    }
    
    public func numSections(in collectionSkeletonView: UICollectionView) -> Int {
        return skeletonNumberOfSections(self, collectionSkeletonView)
    }
    
    public func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return skeletonNumberOfItemsInSection(self, skeletonView, section)
    }
    
    public func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> String {
        return skeletonReuseIdentifierForItemAtIndex(self, skeletonView, indexPath)
    }
}
