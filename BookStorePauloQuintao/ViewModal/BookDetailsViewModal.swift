//
//  BookDetailsViewModal.swift
//  BookStorePauloQuintao
//
//  Created by João Quintão on 26/06/2022.
//

import Foundation

class BookDetailsViewModal : NSObject{
    
    var reloadViewInfo: (() -> (Void))?
    
    func setupBookFavorite(book:Book){
        book.favorite = !book.favorite
        
        var favoriteBooks = Book.getBooks()
        if book.favorite{
            if !favoriteBooks.contains(where: {$0.id == book.id}){
                favoriteBooks.append(book)
                Book.saveBooks(books: favoriteBooks)
            }
        }else{
            if let index = favoriteBooks.firstIndex(where: {$0.id == book.id}){
                favoriteBooks.remove(at: index)
                Book.saveBooks(books: favoriteBooks)
            }
        }
        
        reloadViewInfo?()
    }
}
