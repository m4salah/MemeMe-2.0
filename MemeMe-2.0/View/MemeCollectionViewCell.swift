//
//  MemeCollectionViewCell.swift
//  MemeMe-1.0
//
//  Created by Mohamed Abdelkhalek Salah on 4/29/20.
//  Copyright © 2020 Mohamed Abdelkhalek Salah. All rights reserved.
//

import UIKit

class MemeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var memeImage:UIImageView!
    
    func configureMeme(image: UIImage) {
        self.memeImage.image = image
    }
}
