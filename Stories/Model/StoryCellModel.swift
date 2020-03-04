//
//  StoryCell.swift
//  Stories
//
//  Created by iim jobs on 03/03/20.
//  Copyright © 2020 iim jobs. All rights reserved.
//

import UIKit

class StoryCellModel: NSObject {
    var title: String
    var image: String
    var stories: StoryPreviewCellModel
    
    init(title: String, image: String,stories: StoryPreviewCellModel) {
        self.title = title
        self.image = image
        self.stories = stories
    }
}
