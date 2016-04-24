//
//  CustomLayout.swift
//  CollectionViewSample
//
//  Created by oyuk on 2016/04/17.
//  Copyright © 2016年 okysoft. All rights reserved.
//

import UIKit

class CustomLayout: UICollectionViewFlowLayout {
    
    private var animator:UIDynamicAnimator!
    private var visibleIndexPathsSet:Set<NSIndexPath>!
    private var addedBehaviour = [NSIndexPath: UIAttachmentBehavior]()
    private var latestDelta:CGFloat = 0
    
    override init() {
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup(){
        self.minimumInteritemSpacing = 10
        self.minimumLineSpacing = CGFloat(10)
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        animator = UIDynamicAnimator(collectionViewLayout: self)
        visibleIndexPathsSet = Set()
    }
    
    override func prepareLayout() {
        super.prepareLayout()
        
        guard let collectionView = self.collectionView else {
            return
        }
        
        let visibleRect = CGRectInset(CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size), -100, -100)
        guard let itemsInVisibleRectArray = super.layoutAttributesForElementsInRect(visibleRect) else {
            return
        }
        
        let visibleIndexPaths = itemsInVisibleRectArray.map{$0.indexPath}
        let noLongerVisibleBehaviours = self.visibleIndexPathsSet.subtract(visibleIndexPaths)
        self.visibleIndexPathsSet = Set(visibleIndexPaths)
        
        noLongerVisibleBehaviours.forEach { (indexPath) in
            if let behavior = self.addedBehaviour[indexPath] {
                self.animator.removeBehavior(behavior)
                self.addedBehaviour.removeValueForKey(indexPath)
            }
        }
        
        let touchLocation = collectionView.panGestureRecognizer.locationInView(collectionView)
        
        for item in itemsInVisibleRectArray {
            guard self.addedBehaviour[item.indexPath] == nil else {continue}
            
            let behavior = UIAttachmentBehavior(item: item, attachedToAnchor: item.center)
            behavior.length = 0
            behavior.damping = 0.8
            behavior.frequency = 1.0
            
            if (CGPointZero == touchLocation) {
                let xDistanceFromTouch = fabs(touchLocation.x - behavior.anchorPoint.x)
                let yDistanceFromTouch = fabs(touchLocation.y - behavior.anchorPoint.y)
                let scrollResistance = (yDistanceFromTouch + xDistanceFromTouch)/1500.0
                
                if (self.latestDelta < 0) {
                    item.center.y += max(self.latestDelta,self.latestDelta * scrollResistance)
                }else {
                    item.center.y += min(self.latestDelta,self.latestDelta * scrollResistance)
                }
            }
            
            self.animator.addBehavior(behavior)
            self.addedBehaviour[item.indexPath] = behavior
        }
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        guard let collectionView = self.collectionView else {return false}
        let delta = newBounds.origin.y - collectionView.bounds.origin.y
        

        print("\(newBounds.origin.y) \(collectionView.bounds.origin.y)")
        
        self.latestDelta = delta
        let touchLocation = collectionView.panGestureRecognizer.locationInView(collectionView)
        
        for behavior in self.animator.behaviors {
            if let behavior = behavior as? UIAttachmentBehavior, let item = behavior.items.first {
                let xDistanceFromTouch = fabs(touchLocation.x - behavior.anchorPoint.x)
                let yDistanceFromTouch = fabs(touchLocation.y - behavior.anchorPoint.y)
                let scrollResistance = (yDistanceFromTouch + xDistanceFromTouch)/1500.0
                
                if (self.latestDelta < 0) {
                    item.center.y += max(self.latestDelta,self.latestDelta * scrollResistance)
                }else {
                    item.center.y += min(self.latestDelta,self.latestDelta * scrollResistance)
                }
                
                self.animator.updateItemUsingCurrentState(item)
            }
        }
        return false
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.animator.itemsInRect(rect) as? [UICollectionViewLayoutAttributes]
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return self.animator.layoutAttributesForCellAtIndexPath(indexPath)
    }
}
