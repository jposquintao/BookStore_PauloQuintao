//
//  Utils.swift
//  BookStorePauloQuintao
//
//  Created by João Quintão on 26/06/2022.
//

import Foundation

class Utils{
    
    // Translate string
    class func translate(_ key : String!) -> String!{
        return NSLocalizedString(key, value: key, comment: "")
    }
}
