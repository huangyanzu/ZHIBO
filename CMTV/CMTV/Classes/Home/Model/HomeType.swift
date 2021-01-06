//
//  HomeType.swift
//  CMTV
//
//  Created by aZu on 2021/1/5.
//

import UIKit

class HomeType: NSObject {

    @objc var title : String?
    @objc var type : Int = 0 
    
    init(dict : [String : Any]) {
        
        super.init()
        
        setValuesForKeys(dict)
        
    }
    
    override  func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}
