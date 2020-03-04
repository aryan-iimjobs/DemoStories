//
//  StoryPreviewCell.swift
//  Stories
//
//  Created by iim jobs on 03/03/20.
//  Copyright © 2020 iim jobs. All rights reserved.
//

import UIKit

class StoryPreviewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    var myImage = UIImageView()
    var myLabel = UILabel()

    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        
        let frame = CGRect(x: 20, y: 40, width: 60, height: 60)
        myImage.frame = frame
        myImage.layer.cornerRadius = 30
        myImage.contentMode = .scaleAspectFit
        myImage.clipsToBounds = true
        self.addSubview(myImage)
        
        let frame2 = CGRect(x: 90, y: 40, width: 100, height: 60)
        myLabel.frame = frame2
        myLabel.textColor = .white
        self.addSubview(myLabel)
    }
    
}
