//
//  RequestHandler.swift
//  BookStorePauloQuintao
//
//  Created by João Quintão on 26/06/2022.
//

import Foundation
import Alamofire

class RequestHandler{
    
    static func getHeader() -> HTTPHeaders{
        
        let headers = [HTTPHeader(name: "Content-Type", value: "application/json"),
                       HTTPHeader(name: "Cache-Control", value: "no-cache")]
        
        return HTTPHeaders(headers)
    }
    
    class RequestBooks{
        fileprivate class func _default_ctor(_ json:[String:AnyObject]) -> Book?{
            return Book(json: json)
        }
        
        @discardableResult
        final class func getBooks(offset:String, constructor:@escaping ([String:AnyObject]) -> Book? = RequestBooks._default_ctor, completion:@escaping (Books?, Int, Error?) -> ()) -> Request{
            
            var parameter = [String:AnyObject]()
            parameter["maxResults"] = LIMITS.limit20.rawValue as AnyObject?
            parameter["startIndex"] = offset as AnyObject
            parameter["q"] = "ios" as AnyObject
            
            let rec = AF.request(URLREQUEST.base.rawValue, method: .get, parameters: parameter, encoding:URLEncoding.default, headers: RequestHandler.getHeader())
            
            rec.responseJSON(options: JSONSerialization.ReadingOptions.allowFragments, completionHandler: {
                response in
                
                switch(response.result){
                case let .failure(error):
                    print("FAILURE \(error)")
                    completion(nil, response.response?.statusCode ?? 0, error)
                    
                case let .success(value):
                    print("SUCCESS \(value)")
                    var books:Books = []
                    
                    if let values = value as? [String:AnyObject], let items = values["items"] as? [[String:AnyObject]]{
                        for item in items{
                            if let book = constructor(item){
                                books.append(book)
                            }
                        }
                    }
                    
                    completion(books, response.response?.statusCode ?? 0, nil)
                }
            })
            return rec
        }
    }
}
