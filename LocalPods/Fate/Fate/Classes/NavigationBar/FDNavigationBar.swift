//
//  FDNavigationBar.swift
//  Fate
//
//  Created by Archer on 2018/12/10.
//

import UIKit

fileprivate let FDNavigationBarPortraitFixedHeight = 44.0

public class FDNavigationBar: UIView {
    
    private lazy var backgroundView: FDBarBackground = {
        let v = FDBarBackground()
        addSubview(v)
        return v
    }()
    
    private lazy var contentView: FDNavigationBarContentView = {
        let v = FDNavigationBarContentView()
        addSubview(v)
        return v
    }()
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
