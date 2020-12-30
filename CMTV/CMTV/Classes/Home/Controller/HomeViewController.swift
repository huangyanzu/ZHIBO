//
//  HomeViewController.swift
//  CMTV
//
//  Created by aZu on 2020/12/29.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.randomColor()
        
       
        
        setupUI()
    }
    
   
   
}

extension HomeViewController{
    
    
    private func setupUI(){
        
       // setupNavigationBar()
        
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
    
}


/*
 - (UIView *)findViewWithClassName:(NSString *)className inView:(UIView *)view{
     Class specificView = NSClassFromString(className);
     if ([view isKindOfClass:specificView]) {
         return view;
     }
  
     if (view.subviews.count > 0) {
         for (UIView *subView in view.subviews) {
             UIView *targetView = [self findViewWithClassName:className inView:subView];
             if (targetView != nil) {
                 return targetView;
             }
         }
     }
     
     return nil;
 }
  
 // 调用方法
  UITextField *textField = [self findViewWithClassName:@"UITextField" inView:_searchBar];

 
 
 
 
 */
