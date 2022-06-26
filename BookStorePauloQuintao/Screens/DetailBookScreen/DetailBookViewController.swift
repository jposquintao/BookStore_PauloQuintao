//
//  DetailBookViewController.swift
//  BookStorePauloQuintao
//
//  Created by João Quintão on 26/06/2022.
//

import Foundation
import UIKit

protocol DetailBookViewControllerDelegate : AnyObject{
    func didCloseDetails(vc:DetailBookViewController)
}

class DetailBookViewController : UIViewController{
   
    @IBOutlet weak var imageViewBook: UIImageView!
    @IBOutlet weak var labelBookTitle: UILabel!
    @IBOutlet weak var labelBookAuthor: UILabel!
    @IBOutlet weak var labelBookDescription: UILabel!
    @IBOutlet weak var buttonBuyBook: UIButton!
    @IBOutlet weak var customHeaderView: CustomHeaderView!
    
    weak var delegate : DetailBookViewControllerDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    @IBAction func onBuyBookPressed(_ sender: Any) {
   
    }
    
    @IBAction func onFavoriteButtonPressed(_ sender: Any) {
    
    }
    
    func setupView(){
        customHeaderView.delegate = self
        customHeaderView.setupForDetails()
        
        buttonBuyBook.setTitle(Utils.translate("buy_link"), for: .normal)
    }
}

extension DetailBookViewController : CustomHeaderViewDelegate{
    func didGoBack() {
        self.delegate?.didCloseDetails(vc: self)
    }
}
