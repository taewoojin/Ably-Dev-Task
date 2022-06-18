//
//  Constant.swift
//  Ably-Dev-Task
//
//  Created by 진태우 on 2022/06/18.
//


import Foundation
import UIKit


struct Constant {
    
    enum BuildType {
        case release
        case debug
    }
    
    static let `default` = Constant(type: .release)
    
    let domain: Domain
    
    
    init(type: BuildType = .release) {
        domain = Domain(type: type)
    }
    
    
    struct Domain {
        
        let url: String
        
        
        init(type: BuildType = .release) {
            switch type {
            case .release:
                url = "http://d2bab9i9pr8lds.cloudfront.net"
                
            case .debug:
                url = "http://d2bab9i9pr8lds.cloudfront.net"
                
            }
        }
    }
        
}
