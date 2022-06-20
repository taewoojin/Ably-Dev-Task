//
//  Int+Extensions.swift
//  Ably-Dev-Task
//
//  Created by 진태우 on 2022/06/19.
//

import Foundation


extension Int {
       
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value: self))!
    }
    
}
