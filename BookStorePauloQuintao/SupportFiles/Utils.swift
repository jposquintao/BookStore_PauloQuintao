//
//  Utils.swift
//  BookStorePauloQuintao
//
//  Created by João Quintão on 26/06/2022.
//

import Foundation
import UIKit

class Utils{
    
    // Translate string
    class func translate(_ key : String!) -> String!{
        return NSLocalizedString(key, value: key, comment: "")
    }
    
    // Open a URL
    class func didOpenURL(url:String){
        guard let url = URL(string: url) else { return }
        UIApplication.shared.open(url)
    }
}
