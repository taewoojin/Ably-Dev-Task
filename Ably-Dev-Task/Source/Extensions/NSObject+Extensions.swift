//
//  NSObject+Extensions.swift
//  Ably-Dev-Task
//
//  Created by 진태우 on 2022/06/18.
//

import Foundation


extension NSObject {
    
    static var typeName: String {
        return String(describing: self)
    }
    
    func className() -> String {
        return type(of: self).description().components(separatedBy: ".").last ?? ""
    }
    
}
