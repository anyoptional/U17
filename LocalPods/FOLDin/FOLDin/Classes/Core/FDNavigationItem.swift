//
//  FDNavigationItem.swift
//  FOLDin
//
//  Created by Archer on 2018/12/10.
//

import Foundation

@objc protocol FDNavigationItemDelegate: NSObjectProtocol {
    func navigationItemDidChange(_ item: FDNavigationItem)
}

/// NOTE: animated parameter is not supported.
public class FDNavigationItem: NSObject {

    // Internal use only
    @objc weak var delegate: FDNavigationItemDelegate?
    
    // Title when topmost on the stack. default is nil
    public var title: String? {
        didSet { delegate?.navigationItemDidChange(self) }
    }
    
    // Custom view to use in lieu of a title. May be sized horizontally. Only used when item is topmost on the stack.
    public var titleView: UIView? {
        didSet { delegate?.navigationItemDidChange(self) }
    }
    
    // TitleView相对于navigationItem.leftBarButtonItems/navigationItem.rightBarButtonItems的边距，
    // left对应leftBarButtonItems，right对应rightBarButtonItems
    public var titleViewMargin: FDMargin = .init(left: 12, right: 12) {
        didSet { delegate?.navigationItemDidChange(self) }
    }
    
    // Bar button item to use for the back button in the child navigation item.
    public var backBarButtonItem: FDBarButtonItem? {
        didSet { delegate?.navigationItemDidChange(self) }
    }
    
    // If YES, this navigation item will hide the back button when it's on top of the stack.
    public var hidesBackButton: Bool = false {
        didSet { delegate?.navigationItemDidChange(self) }
    }
    
    /* By default, the leftItemsSupplementBackButton property is NO. In this case,
     the back button is not drawn and the left item or items replace it. If you
     would like the left items to appear in addition to the back button (as opposed to instead of it)
     set leftItemsSupplementBackButton to YES.
     */
    public var leftItemsSupplementBackButton: Bool = false {
        didSet { delegate?.navigationItemDidChange(self) }
    }
    
    /* Use these properties to set multiple items in a navigation bar.
     The older single properties (leftBarButtonItem and rightBarButtonItem) now refer to
     the first item in the respective array of items.
     
     NOTE: You'll achieve the best results if you use either the singular properties or
     the plural properties consistently and don't try to mix them.
     
     leftBarButtonItems are placed in the navigation bar left to right with the first
     item in the list at the left outside edge and left aligned.
     rightBarButtonItems are placed right to left with the first item in the list at
     the right outside edge and right aligned.
     */
    public var leftBarButtonItems: [FDBarButtonItem]? {
        get { return _leftBarButtonItems }
        set { setLeftBarButtonItems(newValue, animated: false) }
    }
    
    public var rightBarButtonItems: [FDBarButtonItem]?  {
        get { return _rightBarButtonItems }
        set { setRightBarButtonItems(newValue, animated: false) }
    }
    
    // Some navigation items want to display a custom left or right item when they're on top of the stack.
    // A custom left item replaces the regular back button unless you set leftItemsSupplementBackButton to YES
    public var leftBarButtonItem: FDBarButtonItem? {
        get { return _leftBarButtonItem }
        set { setLeftBarButton(newValue, animated: false) }
    }
    
    public var rightBarButtonItem: FDBarButtonItem? {
        get { return _rightBarButtonItem }
        set { setRightBarButton(newValue, animated: false) }
    }
     
    private lazy var _leftBarButtonItem: FDBarButtonItem? = nil
    private lazy var _leftBarButtonItems: [FDBarButtonItem]? = nil
    
    public func setLeftBarButton(_ item: FDBarButtonItem?, animated: Bool) {
        _leftBarButtonItem = item
        
        if _leftBarButtonItems == nil {
            _leftBarButtonItems = []
        }
        
        if !_leftBarButtonItems!.isEmpty {
            if let leftBarItem = item {
                _leftBarButtonItems![0] = leftBarItem
            } else {
                _leftBarButtonItems!.remove(at: 0)
            }
        } else {
            if let leftBarItem = item {
                _leftBarButtonItems!.append(leftBarItem)
            }
        }
        
        delegate?.navigationItemDidChange(self)
    }
    
    public func setLeftBarButtonItems(_ items: [FDBarButtonItem]?, animated: Bool) {
        _leftBarButtonItems = items
        
        if let leftBarItems = items, !leftBarItems.isEmpty {
            _leftBarButtonItem = leftBarItems[0]
        } else {
            _leftBarButtonItem = nil;
        }
        
        delegate?.navigationItemDidChange(self)
    }
    
    private lazy var _rightBarButtonItem: FDBarButtonItem? = nil
    private lazy var _rightBarButtonItems: [FDBarButtonItem]? = nil
    
    public func setRightBarButton(_ item: FDBarButtonItem?, animated: Bool) {
        _rightBarButtonItem = item
        
        if _rightBarButtonItems == nil {
            _rightBarButtonItems = []
        }
        
        if !_rightBarButtonItems!.isEmpty {
            if let rightBarItem = item {
                _rightBarButtonItems![0] = rightBarItem
            } else {
                _rightBarButtonItems!.remove(at: 0)
            }
        } else {
            if let rightBarItem = item {
                _rightBarButtonItems!.append(rightBarItem)
            }
        }
        
        delegate?.navigationItemDidChange(self)
    }
    
    public func setRightBarButtonItems(_ items: [FDBarButtonItem]?, animated: Bool) {
        _rightBarButtonItems = items
        
        if let rightBarItems = items, !rightBarItems.isEmpty {
            _rightBarButtonItem = rightBarItems[0]
        } else {
            _rightBarButtonItem = nil
        }
        
        delegate?.navigationItemDidChange(self)
    }
}
