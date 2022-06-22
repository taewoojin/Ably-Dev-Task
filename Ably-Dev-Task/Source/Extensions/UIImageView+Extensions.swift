//
//  UIImageView+Extensions.swift
//  Ably-Dev-Task
//
//  Created by 진태우 on 2022/06/20.
//

import UIKit


extension UIImageView {
    
    func loadImage(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        self.sd_imageIndicator?.startAnimatingIndicator()
        
        // TODO: SDWebImageRetryFailed (RETRY 옵션 추가)
        self.sd_setImage(with: url) { [weak self] image, error, type, url in
            if error != nil {
                // TODO: 로드 실패 로직  ex) default 이미지 설정..
            }
            
            self?.sd_imageIndicator?.stopAnimatingIndicator()
        }
    }
    
}
