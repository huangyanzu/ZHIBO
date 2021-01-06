//
//  JCContentView.swift
//  JCPageView
//
//  Created by aZu on 2020/12/30.
//

import UIKit

protocol JCContentViewDelegate : class  {
    
    func contentView(_ contentView : JCContentView , targetIndex : Int)
    
    func contentView(_ contentView: JCContentView, targetIndex:Int , progress: CGFloat)
}


private let kContentCell = "kContentCell"

class JCContentView: UIView {
    
    
    private var childVcs : [UIViewController]
    private var parentVc : UIViewController
    weak var delegate : JCContentViewDelegate?
    private var isForbidScroll : Bool = false

    private var startOffsetX :CGFloat = 0
    private lazy var collectionView:UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.scrollsToTop = false
        collectionView.showsHorizontalScrollIndicator = false 
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kContentCell)
        return collectionView
        
        
    }()
    
    init(frame: CGRect,childVcs:[UIViewController],parentVc:UIViewController) {
       
        self.childVcs = childVcs
        
        self.parentVc = parentVc
        
        super.init(frame: frame)
        
        
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension JCContentView {
    private func setupUI(){
        
        for childVc in childVcs {
            
            parentVc.addChild(childVc)
        }
        
        addSubview(collectionView)
        
        
    }
}


extension JCContentView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return childVcs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentCell, for: indexPath)
        
        
        //注意：
        for subView in cell.contentView.subviews{
            subView.removeFromSuperview()
        }
        
        
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        
        
        
        
        return cell
        
        
    }
    

}

extension JCContentView : UICollectionViewDelegate{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        contentEndScroll()
        
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if !decelerate{
           
            contentEndScroll()
            
        }

    }
    
    
    
    
    private func contentEndScroll(){
        
       guard  !isForbidScroll else { return }
        
       let currentIndex = Int(collectionView.contentOffset.x / collectionView.bounds.width)
        
        delegate?.contentView(self, targetIndex: currentIndex )
        
      
        
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        startOffsetX = scrollView.contentOffset.x
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
       
        guard startOffsetX != scrollView.contentOffset.x , !isForbidScroll else {
            return
        }
        var targetIndex = 0
        var progress :CGFloat = 0.0
        
        let currentIndex = Int(startOffsetX / scrollView.bounds.width)
        
        if startOffsetX < scrollView.contentOffset.x {//左滑
            targetIndex = currentIndex + 1
            if targetIndex > childVcs.count - 1 {
                targetIndex = childVcs.count - 1
            }
            
            progress = (scrollView.contentOffset.x - startOffsetX ) / scrollView.bounds.width
            
        }else{
            targetIndex = currentIndex - 1
            if targetIndex < 0 {
                targetIndex = 0
            }
            
            progress = (startOffsetX - scrollView.contentOffset.x) / scrollView.bounds.width 
            
        }
        
        
        
        
        delegate?.contentView(self, targetIndex: targetIndex, progress: progress)
        
        
    }
    
    
}


extension JCContentView : JCTitleViewDelegate{
    func titleView(_ titleView: JCTitleView, targetIndex: Int) {
        
        isForbidScroll = true
        
        let indexPath = IndexPath(item: targetIndex, section: 0)
        
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        
    }
    
    
    
    
    
}
