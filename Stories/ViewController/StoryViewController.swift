//
//  StroyViewController.swift
//  Stories
//
//  Created by iim jobs on 03/03/20.
//  Copyright © 2020 iim jobs. All rights reserved.
//

import UIKit

class StoryViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let screenWidth  = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var arrayStory: [StoryCellModel] = []
    
    var currentMainStoryIndex = 0
    
    // Init ProgressBar
    var arrayCount = 5
    
    //image name array
    var arrayImage: [String] = ["image0", "image1", "image2", "image3", "image4",]
    
    
    
    var progressBar: MyProgressView!
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.isScrollEnabled = false;
        collectionView.isPagingEnabled = true
        
        collectionView.frame = CGRect(x: 0, y: 0, width: self.screenWidth, height: self.screenHeight)
        
        // Add tap recognizer to collection view
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.touch(_:)))
        recognizer.numberOfTapsRequired = 1
        recognizer.numberOfTouchesRequired = 1
        collectionView.addGestureRecognizer(recognizer)
        
        
        // Init ProgressBar
        progressBar = MyProgressView(arrayStories: arrayCount)
        
        progressBar.frame = CGRect(x: 0, y: 20, width: view.frame.width, height: 20)
        
        progressBar.delegate = self
        
        view.addSubview(progressBar)
        progressBar.animate(index: 0)
        
    }
    
    @objc func touch(_ sender: UITapGestureRecognizer) {
        let touch = sender.location(in: self.collectionView)
        
        let screenWidthOneThird = screenWidth / 3
        let screenWidthTwoThird = screenWidthOneThird * 2
        
        // removing scroll offset
        let absoluteTouch = touch.x - collectionView.contentOffset.x
        
        if absoluteTouch < screenWidthOneThird {
            
            progressBar.rewind()
            
        } else if absoluteTouch > screenWidthOneThird && absoluteTouch < screenWidthTwoThird {
            progressBar.pause()
        } else {
            progressBar.skip()
        }
    }
}

extension StoryViewController: SegmentedProgressBarDelegate {
    
    func segmentedProgressBarChangedIndex(index: Int) {
        print("ProgressBar index changed")
        let indexPath = IndexPath(item: index, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func segmentedProgressBarFinished() {
        print("Progress Bar finished")
        self.dismiss(animated: true, completion: nil)
    }
}

extension StoryViewController:  UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayCount
    }
      
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellPreviewStory", for: indexPath) as! StoryPreviewCell
        
        cell.imageView.image = UIImage(named: arrayImage[indexPath.row])
        cell.imageView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        
        cell.myImage.image = UIImage(named: arrayStory[self.currentMainStoryIndex].image)
        cell.myLabel.text = arrayStory[self.currentMainStoryIndex].title
        return cell
    }
}


extension StoryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.screenWidth, height: self.screenHeight)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}
