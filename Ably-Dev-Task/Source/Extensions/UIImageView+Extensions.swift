//
//  UIImageView+Extensions.swift
//  Ably-Dev-Task
//
//  Created by 진태우 on 2022/06/20.
//

import UIKit


//extension UIImageView {
//    
//    func cacheImage(
//        urlString: String?,
//        defaultImage: UIImage? = nil,
//        completeHandler: ((UIImage) -> Void)? = nil,
//        failedHandler: (() -> Void)? = nil
//    ) {
//        guard let urlString = urlString, !urlString.isEmpty else {
//            self.image = defaultImage
//            return
//        }
//        
//        let url = URL(string: urlString)!
//        let retry = DelayRetryStrategy(maxRetryCount: 5, retryInterval: .seconds(2))
//        
//        self.kf.indicatorType = .activity
//        self.kf.setImage(with: url, placeholder: nil, options: [
////            .processor(processor),
////            .scaleFactor(UIScreen.main.scale),
////            .transition(.fade(0.2)),
////            .cacheOriginalImage,
//            .cacheMemoryOnly,
//            .retryStrategy(retry)
//        ], progressBlock: nil) { result in
//            switch result {
//            case .success(let value):
//                completeHandler?(value.image)
//                
//            case .failure(let error):
//                failedHandler?()
//                self.image = defaultImage
//                print("error: \(error)")
//            }
//        }
//    }
//    
//}
