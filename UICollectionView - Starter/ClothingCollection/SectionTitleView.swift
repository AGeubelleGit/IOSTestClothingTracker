//
//  SectionTitleViewCollectionViewCell.swift
//  UICollectionView - Starter
//
//  Created by Alexandre Geubelle on 8/21/18.
//  Copyright © 2018 microIT Infrastructure, LLC. All rights reserved.
//

import UIKit

class SectionTitleView: UICollectionReusableView {
    @IBOutlet weak var sectionTitleLabel: UILabel!
    @IBOutlet weak var sectionHideRecentSwitch: UISwitch!
    
    var sectionTitle: String! {
        didSet {
            sectionTitleLabel.text = sectionTitle
        }
    }
    
    func setBottomBorder() {
        sectionTitleLabel.setBottomBorder()
    }
}

extension UILabel {
    func setBottomBorder() {
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
