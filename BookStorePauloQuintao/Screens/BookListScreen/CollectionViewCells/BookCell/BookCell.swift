//
//  BookCell.swift
//  BookStorePauloQuintao
//
//  Created by João Quintão on 26/06/2022.
//

import Foundation
import UIKit

class BookCell : UICollectionViewCell{
    
    @IBOutlet weak var imageViewBook: UIImageView!
    @IBOutlet weak var labelBookTitle: UILabel!
    @IBOutlet weak var loadImage: UIActivityIndicatorView!
    
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    var cellViewModel: BookCellViewModal? {
        didSet {
            labelBookTitle.text = cellViewModel?.title
            imageViewBook.cacheImage(urlString: cellViewModel?.thumbnail, loadImage: loadImage, defaultImage: "book.closed.fill")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
