//
//  DetailBookViewController.swift
//  BookStorePauloQuintao
//
//  Created by João Quintão on 26/06/2022.
//

import Foundation
import UIKit

protocol DetailBookViewControllerDelegate : AnyObject{
    func didCloseDetails(book:Book?, vc:DetailBookViewController)
}

class DetailBookViewController : UIViewController{
   
    @IBOutlet weak var imageViewBook: UIImageView!
    @IBOutlet weak var labelBookTitle: UILabel!
    @IBOutlet weak var labelBookAuthor: UILabel!
    @IBOutlet weak var labelBookDescription: UILabel!
    @IBOutlet weak var buttonBuyBook: UIButton!
    @IBOutlet weak var customHeaderView: CustomHeaderView!
    @IBOutlet weak var loadImage: UIActivityIndicatorView!
    @IBOutlet weak var buttonFavorite: UIButton!
    
    weak var delegate : DetailBookViewControllerDelegate? = nil
    
    var book:Book?
    
    lazy var viewModal = {
        BookDetailsViewModal()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupBookInfo()
        initViewModal()
    }
    
    @IBAction func onBuyBookPressed(_ sender: Any) {
        if let book = book, let link = book.link {
            Utils.didOpenURL(url: link)
        }
    }
    
    @IBAction func onFavoriteButtonPressed(_ sender: Any) {
        if let book = book {
            viewModal.setupBookFavorite(book: book)
        }
    }
    
    func initViewModal(){
        viewModal.reloadViewInfo = { [weak self] in
            self?.setupBookInfo()
        }
    }
    
    func setupView(){
        customHeaderView.delegate = self
        customHeaderView.setupForDetails()
        
        buttonBuyBook.setTitle(Utils.translate("buy_link"), for: .normal)
    }
    
    func setupBookInfo(){
        if let book = book {
            imageViewBook.cacheImage(urlString: book.thumbnail, loadImage: loadImage, defaultImage: "book.closed.fill")
            labelBookTitle.text = book.title
            labelBookAuthor.text = book.author
            labelBookDescription.text = book.description
            buttonBuyBook.isHidden = book.link == nil
            buttonFavorite.setImage(UIImage(systemName: book.favorite ? "star.fill" : "star"), for: .normal)
        }
    }
}

extension DetailBookViewController : CustomHeaderViewDelegate{
    func didGoBack() {
        self.delegate?.didCloseDetails(book: book, vc: self)
    }
}
