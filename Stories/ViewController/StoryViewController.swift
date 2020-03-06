//
//  StroyViewController.swift
//  Stories
//
//  Created by iim jobs on 03/03/20.
//  Copyright © 2020 iim jobs. All rights reserved.
//

import UIKit

class StoryViewController: UIViewController {
    
    let screenWidth  = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var arrayStory: [StoryCellModel] = []
    
    var currentMainStoryIndex = 0
    
    var firstLaunch = false
    
    //CollectionView
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout();
        layout.scrollDirection = .horizontal; //set scroll direction to horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout);
        cv.register(StoryPreviewCell.self, forCellWithReuseIdentifier: "cell")
        cv.translatesAutoresizingMaskIntoConstraints = false;
        return cv;
    }();
    
    override func loadView() {
        super.loadView()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let indexPath = IndexPath(item: currentMainStoryIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         //Do any additional setup after loading the view.
        
        view.addSubview(collectionView)
        
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true; //set the location of collection view
        collectionView.rightAnchor.constraint(equalTo:  view.rightAnchor).isActive = true; // top anchor of collection view
        collectionView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true; // height
        collectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true; // width
        
        collectionView.isScrollEnabled = true
        collectionView.isPagingEnabled = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}



extension StoryViewController:  UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
      
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! StoryPreviewCell
        
        print("Changing index = \(indexPath.row)")
        
        cell.arrayStory = self.arrayStory
        cell.parentStory = indexPath.row
        
        let progFrame = CGRect(x: 0, y: 5, width: screenWidth, height: 20)
        cell.progressBar.frame = progFrame
    
        //Pass collectionview reference
        cell.parentCollectionView = self.collectionView
        
        cell.myImage.image = UIImage(named: arrayStory[indexPath.row].image)
        cell.myLabel.text = arrayStory[indexPath.row].title
        
        print("Image naem = \(arrayStory[indexPath.row].image)")
        return cell
    }
}

extension StoryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()

        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size

        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)

        guard let indexPath = collectionView.indexPathForItem(at: visiblePoint) else { return }

        print("decel index = \(indexPath.row)")
        
        let cell = collectionView.cellForItem(at: indexPath) as! StoryPreviewCell
        cell.progressBar.layoutSubviews()
        cell.progressBar.animate(index: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}
