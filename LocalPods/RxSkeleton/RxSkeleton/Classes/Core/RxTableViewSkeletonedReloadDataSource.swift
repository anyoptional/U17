//
//  RxTableViewSkeletonedReloadDataSource.swift
//  RxSkeleton
//
//  Created by Archer on 2018/11/30.
//

import UIKit
import RxSwift
import RxCocoa
import Differentiator

public class RxTableViewSkeletonedReloadDataSource<S: SectionModelType>
    : TableViewSkeletonedDataSource<S>
    , RxTableViewDataSourceType {
    
    public typealias Element = [S]
    
    public func tableView(_ tableView: UITableView, observedEvent: Event<Element>) {
        Binder(self) { dataSource, element in
            #if DEBUG
            self._dataSourceBound = true
            #endif
            dataSource.setSections(element)
            tableView.reloadData()
        }.on(observedEvent)
    }
}
