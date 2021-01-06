//
//  AnchorViewController.swift
//  CMTV
//
//  Created by aZu on 2021/1/6.
//

import UIKit

private let kEdgeMargin : CGFloat = 8
private let kAnchorCellID = "kAnchorCellID"

class AnchorViewController: UIViewController {

    // MARK: 对外属性
    var homeType : HomeType?
    
    
    private lazy var collectionView :UICollectionView = {
        
        let layout = JCWaterfallLayout()
        layout.sectionInset = UIEdgeInsets(top: kEdgeMargin, left: kEdgeMargin, bottom: kEdgeMargin, right: kEdgeMargin)
        
        layout.minimumLineSpacing = kEdgeMargin
        layout.minimumInteritemSpacing = kEdgeMargin
        
        layout.dataSource = self
        
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        
       // collectionView.dataSource = self
      //  collectionView.delegate = self
        
        
        collectionView.backgroundColor = UIColor.white
        
        
        return  collectionView
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    

    
}

extension AnchorViewController{
    
    private func setupUI(){
        
        view.addSubview(collectionView)
        
    }
    
    
}


extension AnchorViewController : JCWaterfallLayoutDataSource{
    func numberOfCols(_ waterfall: JCWaterfallLayout) -> Int {
        return 2
    }
    
    func waterfallLayout(_ waterfall: JCWaterfallLayout, item: Int) -> CGFloat {
        return 200
    }
    
    
}
