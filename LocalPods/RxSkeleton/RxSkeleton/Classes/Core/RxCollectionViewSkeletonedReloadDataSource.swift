//
//  RxCollectionViewSkeletonedReloadDataSource.swift
//  RxSkeleton
//
//  Created by Archer on 2018/11/30.
//

import UIKit
import RxSwift
import RxCocoa
import Differentiator

public class RxCollectionViewSkeletonedReloadDataSource<S: SectionModelType>
    : CollectionViewSkeletonedReloadDataSource<S>
    , RxCollectionViewDataSourceType {

    public typealias Element = [S]
    
    public func collectionView(_ collectionView: UICollectionView, observedEvent: Event<Element>) {
        Binder(self) { dataSource, element in
            #if DEBUG
            self._dataSourceBound = true
            #endif
            dataSource.setSections(element)
            collectionView.reloadData()
            collectionView.collectionViewLayout.invalidateLayout()
        }.on(observedEvent)
    }
}
