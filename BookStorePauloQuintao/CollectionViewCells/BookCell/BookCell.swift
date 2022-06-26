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
    
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
