//
//  JCPageView.swift
//  JCPageView
//
//  Created by aZu on 2020/12/30.
//

import UIKit



class JCPageView: UIView {

    private var titles : [String]
    
    private var childVcs :[UIViewController]
    
    private var parentVc : UIViewController
    
    private var style :JCTitleStyle
    
    private var titleView : JCTitleView!
    
    
   
    init(frame: CGRect,titles :[String] ,childVcs:[UIViewController],parentVc: UIViewController , style : JCTitleStyle) {
        
        self.titles = titles
        self.childVcs = childVcs
        self.parentVc = parentVc
        self.style = style
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

extension JCPageView{
    
    private func setupUI(){
        
        setupTitleView()
        setupContentView()
        
    }
    
    private func setupTitleView(){
        
        let titleFrame = CGRect(x: 0, y: 0, width: bounds.width, height: style.titleHeight)
        
        titleView = JCTitleView(frame: titleFrame , titles:titles , style:  style )
        
        titleView.backgroundColor = UIColor.white
        
        
        addSubview(titleView)
        
        
    }
    
    private func setupContentView(){
        
        let contentFrame = CGRect(x: 0, y: titleView.frame.maxY, width: bounds.width, height: bounds.height - titleView.frame.height)
        
        let contentView = JCContentView(frame: contentFrame, childVcs: childVcs, parentVc: parentVc)
        
        contentView.backgroundColor = UIColor.white
        
        addSubview(contentView)
        
        titleView.delegate = contentView
        contentView.delegate = titleView 
    }
    
    
    
}
