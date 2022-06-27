//
//  BookService.swift
//  BookStorePauloQuintao
//
//  Created by João Quintão on 26/06/2022.
//

import Foundation

protocol BookServiceProtocol {
    func getBooks(offset:String, completion: @escaping (_ success: Bool,_ books: Books?, _ error: String?) -> ())
}

class BookService: BookServiceProtocol {
    
    // Request List of books from API
    func getBooks(offset:String, completion: @escaping (Bool, Books?, String?) -> ()){
        RequestHandler.RequestBooks.getBooks(offset: offset) { books, status, error in
            if let error = error {
                completion(false, nil, error.localizedDescription)
            }else {
                if (200...300) ~= status{
                    completion(true, books, nil)
                }else{
                    completion(false, nil, "Error Requesting Books")
                }
            }
        }
    }
}
