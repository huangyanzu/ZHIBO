//
//  UIColor+Extension.swift
//  CMTV
//
//  Created by aZu on 2020/12/29.
//

import UIKit


extension UIColor{
    
    convenience  init(r:CGFloat ,g:CGFloat,b:CGFloat,alpha:CGFloat = 1.0){
        
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0 , alpha: alpha)
        
        
    }
    
    convenience init?(hex:String,alpha :CGFloat = 0){
        
        guard hex.count >= 6 else {
            return nil
        }
        
        var tempHex = hex.uppercased()
        
        if tempHex.hasPrefix("0x") || tempHex.hasPrefix("##"){
            tempHex = (tempHex as NSString) .substring(from: 2)
        }
        
        if tempHex.hasPrefix("#"){
            tempHex = (tempHex as NSString).substring(from: 1)
        }
        
        var range = NSRange(location: 0, length: 2)
        
        let rHex = (tempHex as NSString).substring(with: range)
        
        range.location = 2
        let gHex = (tempHex as NSString ).substring(with: range)
        
        range.location = 4
        let bHex = (tempHex as NSString).substring(with: range)
        
        var r : UInt32 = 0, g :UInt32 = 0  ,b : UInt32  = 0
        
        Scanner(string: rHex).scanHexInt32(&r)
        Scanner(string: gHex).scanHexInt32(&g)
        Scanner(string: bHex).scanHexInt32(&b)
        
        
        
        self.init(r:CGFloat(r),g:CGFloat(g),b:CGFloat(b))
        
    }
    
    class func randomColor() ->UIColor{
       return UIColor(r: CGFloat(arc4random_uniform(256)), g: CGFloat(arc4random_uniform(256)), b: CGFloat(arc4random_uniform(256)))
    }
    
    
}
