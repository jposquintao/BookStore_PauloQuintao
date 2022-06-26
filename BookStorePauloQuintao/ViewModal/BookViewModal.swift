//
//  BookViewModal.swift
//  BookStorePauloQuintao
//
//  Created by João Quintão on 26/06/2022.
//

import Foundation

class BookViewModal : NSObject{
    private var booksService: BookServiceProtocol
    
    // Var to check request on going
    var isLoding:Bool = false
    // Has no more results to load
    var listEmpty:Bool = false
    
    var reloadCollectionView: (() -> (Void))?
    
    var books = Books()
    
    var bookCellViewModals = [BookCellViewModal]() {
        didSet {
            reloadCollectionView?()
        }
    }
    
    init(bookService: BookServiceProtocol = BookService()) {
        self.booksService = bookService
    }
    
    // Get book from request 
    func getBooks() {
        self.isLoding = true
        self.booksService.getBooks(offset: "\(books.count)") { success, books, error in
            self.isLoding = false
            if success{
                if let books = books{
                    if books.isEmpty{
                        self.listEmpty = true
                    }
                    self.fetchData(books: books)
                }
            }else{
                print("Error request \(error ?? "")")
            }
        }
    }
    
    // fetch books from request
    func fetchData(books: Books){
        self.books.append(contentsOf: books)
        setupListBookCellModal(books: self.books)
    }
    
    // reload list books
    func resetBooks(){
        self.listEmpty = false
        self.isLoding = false
        self.books = []
    }
    
    // Set book opened new info
    func reloadListBooks(book:Book){
        if let auxbook = books.filter({$0.id == book.id}).first{
            auxbook.favorite = book.favorite
        }
    }
    
    // Filter books by favorites
    func filterByFavorite(isFavorites:Bool){
        if isFavorites{
            let books = Book.getBooks()
            setupListBookCellModal(books: books)
        }else{
            setupListBookCellModal(books: self.books)
        }
    }
    
    func setupListBookCellModal(books:Books){
        var vms = [BookCellViewModal]()
        for book in books {
            vms.append(createBookCellModel(book: book))
        }
        bookCellViewModals = vms
    }
    
    func createBookCellModel(book: Book) -> BookCellViewModal {
        return BookCellViewModal(id: book.id, thumbnail: book.thumbnail, title: book.title)
    }
    
    func getBookCellViewModel(at indexPath: IndexPath) -> BookCellViewModal {
        return bookCellViewModals[indexPath.row]
    }
}
