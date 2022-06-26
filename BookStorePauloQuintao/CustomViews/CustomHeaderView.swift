//
//  CustomHeaderView.swift
//  BookStorePauloQuintao
//
//  Created by João Quintão on 26/06/2022.
//

import Foundation
import UIKit

@objc protocol CustomHeaderViewDelegate : AnyObject{
    @objc optional func didGoBack()
    @objc optional func filterByFavorites(isFavorite:Bool)
}

class CustomHeaderView : UIView{
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var labelHeader: UILabel!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var buttonFavorites: UIButton!
    
    weak var delegate : CustomHeaderViewDelegate? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("CustomHeaderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @IBAction func onBackButtonPressed(_ sender: Any) {
        self.delegate?.didGoBack?()
    }
    
    @IBAction func onFavoriteButtonPressed(_ sender: Any) {
        if buttonFavorites.currentImage == UIImage(systemName: "star"){
            buttonFavorites.setImage(UIImage(systemName: "star.fill"), for: .normal)
            self.delegate?.filterByFavorites?(isFavorite: true)
        }else{
            buttonFavorites.setImage(UIImage(systemName: "star"), for: .normal)
            self.delegate?.filterByFavorites?(isFavorite: false)
        }
    }
    
    // Setups header view in the list VC
    func setupForList(){
        labelHeader.text = Utils.translate("book_store")
        buttonBack.isHidden = true
    }
    
    // Setups header view for details VC
    func setupForDetails(){
        buttonFavorites.isHidden = true
    }
}
