//
//  PaddingLabel.swift
//  Ably-Dev-Task
//
//  Created by 진태우 on 2022/06/20.
//

import UIKit


class PaddingLabel: UILabel {
    
    // MARK: Properties
    
    @IBInspectable var topInset: CGFloat = 5.0
    
    @IBInspectable var bottomInset: CGFloat = 5.0
    
    @IBInspectable var leftInset: CGFloat = 5.0
    
    @IBInspectable var rightInset: CGFloat = 5.0
    
    
    // MARK: Initializing
    
    init(top: CGFloat, right: CGFloat, bottom: CGFloat, left: CGFloat) {
        topInset = top
        bottomInset = bottom
        leftInset = left
        rightInset = right
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    // MARK: Life Cycle Views
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += topInset + bottomInset
        contentSize.width += leftInset + rightInset
        return contentSize
    }
}
