//
//  StoryPreviewCell.swift
//  Stories
//
//  Created by iim jobs on 03/03/20.
//  Copyright © 2020 iim jobs. All rights reserved.
//

import UIKit

class StoryPreviewCell: UICollectionViewCell {
    
    var myImage = UIImageView()
    var myLabel = UILabel()
    
    var progressBar: MyProgressView!
    
    //Parent values ##
    var arrayStory: [StoryCellModel] = []
    var parentStory: Int = 0
    
    var parentCollectionView: UICollectionView?
    
   let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout();
        layout.scrollDirection = .horizontal; //set scroll direction to horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout);
        cv.register(StoryCell.self, forCellWithReuseIdentifier: "cell")
        cv.translatesAutoresizingMaskIntoConstraints = false;
        return cv;
    }();
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        addSubview(collectionView)
        collectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true;
        collectionView.rightAnchor.constraint(equalTo:  rightAnchor).isActive = true;
        collectionView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true;
        collectionView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true;
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = false
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.touch(_:)))
        recognizer.numberOfTapsRequired = 1
        recognizer.numberOfTouchesRequired = 1
        collectionView.addGestureRecognizer(recognizer)
        
        let frame = CGRect(x: 20, y: 40, width: 60, height: 60)
        myImage.frame = frame
        myImage.layer.cornerRadius = 30
        myImage.contentMode = .scaleAspectFit
        myImage.clipsToBounds = true
        addSubview(myImage)
        
        let frame2 = CGRect(x: 90, y: 40, width: 100, height: 60)
        myLabel.frame = frame2
        myLabel.textColor = .white
        addSubview(myLabel)
        
        // Init ProgressBar
        progressBar = MyProgressView(arrayStories: 2)
        progressBar.delegate = self
        
        addSubview(progressBar)
        //progressBar.animate(index: 0)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func touch(_ sender: UITapGestureRecognizer) {
        let touch = sender.location(in: self.collectionView)

        let screenWidthOneThird = self.frame.width / 3
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
    
//    func visibleParentCell() -> Int {
//            let visibleRect = CGRect(origin: parentCollectionView!.contentOffset, size: parentCollectionView!.bounds.size)
//            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
//            let visibleIndexPath = parentCollectionView!.indexPathForItem(at: visiblePoint)
//        return visibleIndexPath!.row
//    }
}

extension StoryPreviewCell: SegmentedProgressBarDelegate {

    func segmentedProgressBarChangedIndex(index: Int) {
        print("ProgressBar index changed")
        let indexPath = IndexPath(item: index, section: 0)
        
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        
        self.collectionView.reloadData()
        self.collectionView.layoutIfNeeded()
    }

    func segmentedProgressBarFinished() {
        var visibleRect = CGRect()
        
        print("ProgressBar ended")
        
        visibleRect.origin = self.parentCollectionView!.contentOffset
        visibleRect.size = self.parentCollectionView!.bounds.size

        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)

        guard let indexPath = self.parentCollectionView!.indexPathForItem(at: visiblePoint) else { return }
        print("YES index = \(indexPath.row)")
        
        
        
        let newIndexPath = IndexPath(row: indexPath.row + 1, section: 0)
        self.parentCollectionView!.scrollToItem(at: newIndexPath, at: .centeredHorizontally, animated: false)
        self.parentCollectionView!.reloadData()
        self.parentCollectionView!.layoutIfNeeded()
        
        self.collectionView.reloadData()
        self.collectionView.layoutIfNeeded()
        self.progressBar.resetBar(index: 0)
        self.progressBar.animate(index: 0)
    }
}

extension StoryPreviewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //arrayStory[parentStory].stories
        return arrayStory[parentStory].stories.story.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! StoryCell
        
        let imageString: String = arrayStory[parentStory].stories.story[indexPath.row]
        
        print("XXXXX = \(imageString)")
        
        cell.myImage.image = UIImage(named: imageString)
        cell.myImage.frame = CGRect(x: 0, y: 0, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
        return cell
    }
}

extension StoryPreviewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
