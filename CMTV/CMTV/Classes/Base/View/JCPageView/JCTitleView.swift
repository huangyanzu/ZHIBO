//
//  JCTitleView.swift
//  JCPageView
//
//  Created by aZu on 2020/12/30.
//

import UIKit


protocol JCTitleViewDelegate : class {
    
    func titleView(_ titleView : JCTitleView,targetIndex : Int)
}


class JCTitleView: UIView {

    private var titles :[String]
    private var style : JCTitleStyle
    private lazy var titleLabels :[UILabel] = [UILabel]()
    private  var currentIndex : Int = 0
    
    weak var delegate : JCTitleViewDelegate?
    
    private lazy var scrollView : UIScrollView = { 
        
        let scrollView = UIScrollView(frame: self.bounds)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        
        
        return scrollView
    }()
    
    private lazy var bottomLine :UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = self.style.scrollLineColor
        bottomLine.frame.size.height = self.style.scrollLineHeight
        bottomLine.frame.origin.y = self.bounds.height - self.style.scrollLineHeight
        return bottomLine
    }()
    
    init(frame: CGRect,titles:[String],style : JCTitleStyle) {
        
        self.titles = titles
        self.style = style 
        
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


extension JCTitleView{
    
    private func setupUI(){
        
       addSubview(scrollView)
        
       setupTitleLabels()
        
       setupTitleLabelsFrame()
        
        if style.isShowScrollLine{
            scrollView.addSubview(bottomLine)
        }
    }
    
    private func setupTitleLabels(){
     
        for (i,title) in titles.enumerated(){
            let titleLabel = UILabel()
            
            titleLabel.text = title
            titleLabel.textColor = style.normalColor
            titleLabel.font = UIFont.systemFont(ofSize: style.fontSize)
            titleLabel.tag = i
            titleLabel.textAlignment = .center
            titleLabel.textColor = i == 0 ? style.selectedColor : style.normalColor 
            
            
            
            scrollView.addSubview(titleLabel)
            
            titleLabels.append(titleLabel)
            
            let tapGes = UITapGestureRecognizer()
            
            titleLabel.addGestureRecognizer(tapGes)
            
            tapGes.addTarget(self, action: #selector(titleLabelClick(_:)))
            
            titleLabel.isUserInteractionEnabled = true
            
        }
        
    }
    
    private func setupTitleLabelsFrame(){
        
        let count = titles.count
        
        for (i , label) in titleLabels.enumerated(){
            
            var w : CGFloat = 0
            let  h : CGFloat = bounds.height
            var x : CGFloat = 0
            let  y : CGFloat = 0
            
            if style.isScrollEnable {
                
                w =  (titles[i] as NSString ).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : label.font ?? 15.0 ], context: nil).width
                
                if i == 0 {
                    x = style.itemMargin * 0.5
                   
                    if style.isScrollEnable{
                        bottomLine.frame.origin.x = x
                        bottomLine.frame.size.width = w 
                    }
                    
                }else{
                 
                    x = titleLabels[i - 1].frame.maxX + style.itemMargin
                }
                
                
                
            }else{
                w = bounds.width / CGFloat(count)
                x = w * CGFloat(i)
                
                if i == 0 && style.isShowScrollLine  {
                    bottomLine.frame.origin.x = 0
                    bottomLine.frame.size.width = w
                }
                
            }
            
            label.frame = CGRect(x: x, y: y, width: w, height: h)
            
        }
        
        guard let label = titleLabels.last else {
            return
        }
        
        scrollView.contentSize = style.isScrollEnable ?  CGSize(width: label.frame.maxX + style.itemMargin * 0.5, height: 0) : CGSize.zero
        
    }
    
   
    
    
}

extension JCTitleView{
    
    @objc private func titleLabelClick(_ tapGes : UITapGestureRecognizer){
        
        guard let targetLabel = tapGes.view  as? UILabel else{ return }
        
        
        adjustTitleLabel(targetIndex: targetLabel.tag)
        
        if style.isShowScrollLine {
            UIView.animate(withDuration: 0.25) {
                
                self.bottomLine.frame.origin.x = targetLabel.frame.origin.x
                self.bottomLine.frame.size.width  = targetLabel.frame.width
            }
        }
        
        delegate?.titleView(self, targetIndex: targetLabel.tag)
        
    }
    
    private func adjustTitleLabel(targetIndex : Int){
        
        if targetIndex == currentIndex { return }
      
        let targetLabel = titleLabels[targetIndex]
        
        let sourceLabel = titleLabels[currentIndex]
        
        targetLabel.textColor = style.selectedColor

        sourceLabel.textColor = style.normalColor
        
        
       
        
        currentIndex = targetIndex
        
        if style.isScrollEnable {
            var offsetX = targetLabel.center.x - scrollView.bounds.width * 0.5
            
            if offsetX < 0 {
                offsetX = 0
            }
            
            if offsetX > (scrollView.contentSize.width - scrollView.bounds.width){
                offsetX = scrollView.contentSize.width - scrollView.bounds.width
            }
            
            scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        }
        
    }
    
    
}


extension JCTitleView : JCContentViewDelegate{
    
    func contentView(_ contentView: JCContentView, targetIndex: Int) {
        
        adjustTitleLabel(targetIndex: targetIndex)
       
    }
    
    
    func contentView(_ contentView: JCContentView, targetIndex: Int, progress: CGFloat) {
        
        let targetLabel = titleLabels[targetIndex]
        
        let sourceLabel = titleLabels[currentIndex]
        
        let deltaRGB = UIColor.getRGBDelta(style.selectedColor, style.normalColor)
        
        let selectedRGB = style.selectedColor.getRGB()
        
        let normalRGB = style.normalColor.getRGB()
        
        targetLabel.textColor = UIColor(r: normalRGB.0 + deltaRGB.0 * progress , g: normalRGB.1 + deltaRGB.1 * progress, b: normalRGB.2 + deltaRGB.2 * progress)
        
        sourceLabel.textColor = UIColor(r: selectedRGB.0 + deltaRGB.0 * progress , g: selectedRGB.1 + deltaRGB.1 * progress, b: selectedRGB.2 + deltaRGB.2 * progress)
        
        if style.isShowScrollLine {
            
            let deltaX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
            let deltaW = targetLabel.frame.width - sourceLabel.frame.width
            
            bottomLine.frame.origin.x = sourceLabel.frame.origin.x + deltaX * progress
            bottomLine.frame.size.width = sourceLabel.frame.width + deltaW * progress
            
            
            
            
        }
        
        
        
    }
    
    
    
}
