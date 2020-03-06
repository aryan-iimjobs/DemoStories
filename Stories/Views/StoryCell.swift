//
//  StoryCell.swift
//  Stories
//
//  Created by iim jobs on 05/03/20.
//  Copyright © 2020 iim jobs. All rights reserved.
//

import UIKit

class StoryCell: UICollectionViewCell {
    
    var myImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        setupViews()
    }
    
    func setupViews() {
        myImage.contentMode = .scaleAspectFill
        myImage.clipsToBounds = true
        self.addSubview(myImage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
