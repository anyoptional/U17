//
//  SwipeMenuTabView.swift
//  Fate
//
//  Created by Archer on 2018/11/29.
//

import Foundation

public class SwipeMenuTabView: UIView {
    
    public lazy var titles: [String] = []
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
        v.delegate = self
        v.dataSource = self
        v.register(SwipeMenuTabItemView.self, forCellWithReuseIdentifier: "cell")
        return v
    }()
    
    private lazy var indicator: SwipeMenuIndicator = {
        let v = SwipeMenuIndicator()
        v.backgroundColor = .red
        return v
    }()
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        let origin = CGPoint.zero
        let size = CGSize(width: bounds.width, height: bounds.height - 5)
        collectionView.frame = CGRect(origin: origin, size: size)
    }
    
    
}

extension SwipeMenuTabView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: collectionView.bounds.height)
    }
}

public protocol SwipeMenuTabViewDelegate: class {
    
}
