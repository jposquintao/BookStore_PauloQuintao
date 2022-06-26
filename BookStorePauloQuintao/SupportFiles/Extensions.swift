//
//  Extensions.swift
//  BookStorePauloQuintao
//
//  Created by João Quintão on 26/06/2022.
//

import Foundation
import UIKit

extension UINavigationController {

    public func pushViewController(viewController: UIViewController,
                                   animated: Bool,
                                   completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
    
    public func popViewController(animated: Bool,
                                   completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popViewController(animated: animated)
        CATransaction.commit()
    }
    
    public func closeItemTransaction() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .reveal
        transition.subtype = .fromBottom
        self.view.layer.add(transition, forKey: nil)
    }
    
    public func openItemTransaction() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .moveIn
        transition.subtype = .fromTop
        self.view.layer.add(transition, forKey: nil)
    }
}

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func cacheImage(urlString: String?, loadImage:UIActivityIndicatorView?, defaultImage:String){
        
        if let load = loadImage{
            load.isHidden = false
            load.startAnimating()
        }
        
        image = nil
        
        if let us = urlString, let url = URL(string: us){
            if let imageFromCache = imageCache.object(forKey: us as AnyObject) as? UIImage {
                DispatchQueue.main.async {
                    self.image = imageFromCache
                    if let load = loadImage{
                        load.stopAnimating()
                    }
                }
                return
            }
            
            URLSession.shared.dataTask(with: url) {
                data, response, error in
                if let response = data {
                    DispatchQueue.main.async {
                        if let imageToCache = UIImage(data: response){
                            imageCache.setObject(imageToCache, forKey: us as AnyObject)
                            self.image = imageToCache
                            if let load = loadImage{
                                load.stopAnimating()
                            }
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        self.image = UIImage(systemName: defaultImage)
                        if let load = loadImage{
                            load.stopAnimating()
                        }
                    }
                    
                }
                }.resume()
        }else{
            self.image = UIImage(systemName: defaultImage)
            if let load = loadImage{
                load.stopAnimating()
            }
        }
    }
}
