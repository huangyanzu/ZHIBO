//
//  JCWaterfallLayout.swift
//  瀑布流
//
//  Created by aZu on 2021/1/4.
//

import UIKit

protocol JCWaterfallLayoutDataSource: class {
    
    func numberOfCols(_ waterfall : JCWaterfallLayout) -> Int
    
    func waterfallLayout(_ waterfall : JCWaterfallLayout,  item : Int) -> CGFloat
    
}

class JCWaterfallLayout: UICollectionViewFlowLayout {
    
    weak var dataSource : JCWaterfallLayoutDataSource?

    private lazy var cellAttrs:[UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    private lazy var cols : Int = {
        return self.dataSource?.numberOfCols(self) ?? 2
    }()
    
    private lazy  var totalHeights : [CGFloat] = Array(repeating: sectionInset.top, count: cols)
    
}

extension JCWaterfallLayout{
    override func prepare() {
        
        super.prepare()
        
        guard let itemCount = collectionView?.numberOfItems(inSection: 0) else{return}
        
        let cellW :CGFloat = (collectionView!.bounds.width - sectionInset.left - sectionInset.right - CGFloat(cols - 1) * minimumInteritemSpacing ) / CGFloat(cols)
        
        for i in 0..<itemCount{
            
            let indexPath = IndexPath(item: i, section: 0)
            
            let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            
            guard let  cellH: CGFloat = dataSource?.waterfallLayout(self, item: i) else{
                fatalError("请实现对应的数据源方法，并且返回Cell的高度")
            }
            
            let minH = totalHeights.min()!
            
            let minIndex = totalHeights.firstIndex(of: minH)!
            
            
            let  cellX :CGFloat = sectionInset.left + (minimumInteritemSpacing + cellW) * CGFloat(minIndex)
            let  cellY :CGFloat = minH + minimumLineSpacing
            attr.frame = CGRect(x: cellX, y: cellY, width: cellW, height: cellH)
            
            cellAttrs.append(attr)
            
            totalHeights[minIndex] = minH + minimumLineSpacing + cellH
            
        }
        
        
    }
}


extension JCWaterfallLayout{
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        
        
        
        
        return cellAttrs
        
    }
    
    
}


extension JCWaterfallLayout{
    
    override var collectionViewContentSize: CGSize{
        
        return CGSize(width: 0, height: totalHeights.max()! + sectionInset.bottom )
    }
    
    
}
