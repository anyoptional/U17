//
//  UITableViewSectionedDataSource.swift
//  Fate
//
//  Created by Archer on 2018/11/29.
//

import SkeletonView
import RxDataSources

public class UITableViewSectionedDataSource<S: SectionModelType>: TableViewSectionedDataSource<S> {
    
    public typealias NumberOfSectionsInSkeletonView = (UITableViewSectionedDataSource<S>, UITableView) -> Int
    public typealias CellIdentifierForRowAtIndexPath = (UITableViewSectionedDataSource<S>, UITableView, IndexPath) -> String
    
    public var numberOfSectionsInSkeletonView: NumberOfSectionsInSkeletonView
    public var cellIdentifierForRowAtIndexPath: CellIdentifierForRowAtIndexPath
    
    public init(
        configureCell: @escaping ConfigureCell,
        titleForHeaderInSection: @escaping  TitleForHeaderInSection = { _, _ in nil },
        titleForFooterInSection: @escaping TitleForFooterInSection = { _, _ in nil },
        canEditRowAtIndexPath: @escaping CanEditRowAtIndexPath = { _, _ in false },
        canMoveRowAtIndexPath: @escaping CanMoveRowAtIndexPath = { _, _ in false },
        sectionIndexTitles: @escaping SectionIndexTitles = { _ in nil },
        sectionForSectionIndexTitle: @escaping SectionForSectionIndexTitle = { _, _, index in index },
        numberOfSectionsInSkeletonView: @escaping UITableViewSectionedDataSource<S>.NumberOfSectionsInSkeletonView = { _, _ in return 1 },
        cellIdentifierForRowAtIndexPath: @escaping UITableViewSectionedDataSource<S>.CellIdentifierForRowAtIndexPath
    ) {
        self.numberOfSectionsInSkeletonView = numberOfSectionsInSkeletonView
        self.cellIdentifierForRowAtIndexPath = cellIdentifierForRowAtIndexPath
        super.init(configureCell: configureCell, titleForHeaderInSection: titleForHeaderInSection, titleForFooterInSection: titleForFooterInSection, canEditRowAtIndexPath: canEditRowAtIndexPath, canMoveRowAtIndexPath: canMoveRowAtIndexPath, sectionIndexTitles: sectionIndexTitles, sectionForSectionIndexTitle: sectionForSectionIndexTitle)

    }
}

extension UITableViewSectionedDataSource: SkeletonTableViewDataSource {
    public func numSections(in collectionSkeletonView: UITableView) -> Int {
        return numberOfSectionsInSkeletonView(self, collectionSkeletonView)
    }
    
    public func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return cellIdentifierForRowAtIndexPath(self, skeletonView, indexPath)
    }
}
