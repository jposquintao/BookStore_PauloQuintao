//
//  Book.swift
//  BookStorePauloQuintao
//
//  Created by João Quintão on 26/06/2022.
//

import Foundation

typealias Books = [Book]

class Book : Codable{
    var id:String
    var thumbnail:String
    var title:String
    var author:String?
    var description:String?
    var link:String?
    var favorite:Bool
    
    init(_id:String, _thumbnail:String, _title:String, _author:String, _description:String?, _link:String?, _favorite:Bool){
        self.id = _id
        self.thumbnail = _thumbnail
        self.title = _title
        self.author = _author
        self.description = _description
        self.link = _link
        self.favorite = _favorite
    }
    
    init?(json:[String:AnyObject]){
        let favoriteBooks = Book.getBooks()
        
        if let value = json["id"] as? String{
            self.id = value
            self.favorite = favoriteBooks.contains(where: {$0.id == value})
        }else{
            return nil
        }
        
        if let value = json["volumeInfo"] as? [String:AnyObject]{
            if let links = value["imageLinks"] as? [String:AnyObject], let thumbnail = links["thumbnail"] as? String{
                self.thumbnail = thumbnail
            }else{
                return nil
            }
            
            if let title = value["title"] as? String{
                self.title = title
            }else{
                return nil
            }
            
            if let authors = value["authors"] as? [String]{
                self.author = authors.joined(separator: ", ")
            }else{
                self.author = "Unknown"
            }
            
            if let description = value["description"] as? String{
                self.description = description
            }
        }else{
            return nil
        }
        
        if let value = json["saleInfo"] as? [String:AnyObject]{
            if let link = value["buyLink"] as? String{
                self.link = link
            }
        }
    }
    
    public static func saveBooks(books:[Book]){
        let booksData = try! JSONEncoder().encode(books)
        UserDefaults.standard.set(booksData, forKey: "saved_favorite_books")
    }

    public static func getBooks() -> [Book]{
        if let booksData = UserDefaults.standard.data(forKey: "saved_favorite_books"){
            let booksArray = try! JSONDecoder().decode([Book].self, from: booksData)
            return booksArray
        }
        return []
    }
}
