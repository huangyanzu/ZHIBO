//
//  HomeViewController.swift
//  CMTV
//
//  Created by aZu on 2020/12/29.
//

import UIKit



class HomeViewController: UIViewController {
    
    
    
//    lazy var pageView :JCPageView = {
//
//        let titles = ["以令人难以","限时购","车的流畅轻","明锐动感","只需一眼","新方案现已上线","就足","车","当轿跑灵遇上"]
//        let style = JCTitleStyle()
//
//        style.titleHeight = 30
//
//        style.isScrollEnable = true
//
//        style.isShowScrollLine = true
//
//        var childVcs = [UIViewController]()
//        for _ in  0..<titles.count {
//
//            let vc = UIViewController()
//            vc.view.backgroundColor = UIColor.randomColor()
//            childVcs.append(vc)
//        }
//
//
//
//
//        let pageFrame = CGRect(x: 0, y: 91 , width: view.bounds.width, height: view.bounds.height - 91 )
//
//        let pageView = JCPageView(frame: pageFrame, titles: titles, childVcs: childVcs, parentVc: self, style: style)
//
//        return pageView
//
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    
        setupUI()
    }
    
   
   
}

extension HomeViewController{
    
    
    private func setupUI(){
        
        view.backgroundColor = UIColor.white
        
        setupNavigationBar()
        
        setupContentView()
        
    }
    
    private func setupNavigationBar(){
        
        
        let logoImage = UIImage(named: "home-logo")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: logoImage, style: .plain, target: nil, action: nil)
        
        let collectImage = UIImage(named: "search_btn_follow")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: collectImage, style: .plain, target: self, action: #selector(collectItemClick))
        
//        
//        let searchFrame = CGRect(x: 0, y: 0, width: 200, height: 15)
//        let searchBar = UISearchBar(frame: searchFrame)
//       
//      
//        searchBar.placeholder = "search"
//        navigationItem.titleView = searchBar
//        searchBar.searchBarStyle = .minimal
// 
//       
//        searchBar.placeholder = "search"
//    
//       let targetView  = findViewWithClassName(className: "UITextField", inView: searchBar) as? UITextField
//        
//        targetView?.textColor = UIColor.red
        
    }
    
    private func setupContentView(){
        
        let homeTypes = loadTypesData()
        
        let style = JCTitleStyle()
        style.isScrollEnable = true
        style.isShowScrollLine = true 
        let pageFrame = CGRect(x: 0, y: KNavigationHeight + 3  , width: kScreenWidth, height: kScreenHeight -  KNavigationHeight  - KTabBarHeight - 3 )
        
        guard let titles = homeTypes.map({ $0.title}) as? [String] else{return}
        
        var childVcs = [AnchorViewController]()
        for type in homeTypes{
            let anchorVc = AnchorViewController()
            anchorVc.homeType = type
            childVcs.append(anchorVc)
            
        }
        
        let pageView = JCPageView(frame: pageFrame, titles: titles, childVcs: childVcs, parentVc: self, style: style)
        
        view.addSubview(pageView)
        
        
        
        
    }
    
    
}



extension HomeViewController {
    
    @objc private func collectItemClick(){
        
    }
    
    func  findViewWithClassName(className:String,inView view:UIView) -> UIView? {
       
        guard let  specificView = NSClassFromString(className)  else { return nil }
        if view.isKind(of: specificView){
            return view
        }
        if view.subviews.count > 0 {
           
            for subView in view.subviews {
                let targetView = findViewWithClassName(className: className, inView: subView)
                if targetView != nil{
                    return targetView
                }
            }
            
        }
        return nil
        
    }
    
    private func loadTypesData()-> [HomeType]{
        
       guard let path = Bundle.main.path(forResource: "types.plist", ofType: nil),
             let dataArray = NSArray(contentsOfFile: path) as? [[String:Any]] else
             { return [] }
        
        var tempArray = [HomeType]()
        
        for dict in dataArray{
            tempArray.append(HomeType(dict: dict))
        }
        
        return tempArray
    }
    
    
}


