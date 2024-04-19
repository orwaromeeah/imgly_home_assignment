//
//  UICollectionViewCell.swift
//  imgly_home_assignment
//
//  Created by Orwa Romeeah on 4/19/24.
//

import Foundation
import UIKit

class photoCollectionViewCell : UICollectionViewCell{
    @IBOutlet weak var  photoImageView : UIImageView!
    
    var source:UIImage!{
        didSet {
          
            photoImageView.image = source
        }
    }
    
}
