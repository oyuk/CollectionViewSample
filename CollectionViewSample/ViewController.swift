//
//  ViewController.swift
//  CollectionViewSample
//
//  Created by oyuk on 2016/04/17.
//  Copyright © 2016年 okysoft. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDataSource {

    var animator:UIDynamicAnimator?
    var collectionView:UICollectionView!

    private let  customLayout:CustomLayout = {
        let flowLayout = CustomLayout()
        flowLayout.scrollDirection = .Vertical
        return flowLayout
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView = UICollectionView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height), collectionViewLayout: customLayout)
        collectionView.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.brownColor()
        self.view.addSubview(collectionView)
        
    }
    
    override func viewDidLayoutSubviews() {
        customLayout.itemSize = CGSize(width: 50, height: 100)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! CollectionViewCell
        cell.textLabel?.text = String(indexPath.row)
        return cell
    }

}

