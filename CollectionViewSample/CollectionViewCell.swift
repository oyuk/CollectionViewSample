//
//  CollectionViewCell.swift
//  CollectionViewSample
//
//  Created by oyuk on 2016/04/17.
//  Copyright © 2016年 okysoft. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    var textLabel : UILabel?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // UILabelを生成.
        textLabel = UILabel(frame: CGRectMake(0, 0, frame.width, frame.height))
        textLabel?.text = "nil"
        textLabel?.backgroundColor = UIColor.whiteColor()
        textLabel?.textAlignment = NSTextAlignment.Center
        
        // Cellに追加.
        self.contentView.addSubview(textLabel!)
    }
    
}
