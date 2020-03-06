//
//  ViewController.swift
//  Stories
//
//  Created by iim jobs on 02/03/20.
//  Copyright © 2020 iim jobs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var arrayDemoHomeImages = ["logo0", "logo1", "logo2", "logo3", "logo4"]
    var arrayDemoPreviewImages = [["image0", "image1"], ["image2", "image3"], ["image4","image0"], ["image1", "image2"], ["image3","image4"]]
    
    var TEST_DATA_COUNT = 5
    
    var arrayStory: [StoryCellModel] = []
    
    let screenWidth  = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    private let sectionInsets = UIEdgeInsets(top: 0,
    left: 8.0,
    bottom: 0,
    right: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.frame = CGRect(x: 0, y: 50, width: screenWidth, height: screenHeight * 0.15)
        
        //demo create data
        for i in 0...TEST_DATA_COUNT - 1 {
            arrayStory.append(StoryCellModel(title: "User \(i + 1)", image: arrayDemoHomeImages[i], stories: StoryPreviewCellModel(story: arrayDemoPreviewImages[i])))
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "showStory" {
                let storyViewController = segue.destination as! StoryViewController
                if let sender = sender as? UICollectionViewCell {
                    let indexPath = self.collectionView.indexPath(for: sender)
                    storyViewController.currentMainStoryIndex = indexPath!.section
                }
                storyViewController.arrayStory = arrayStory
            }
        }
    }
}


extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        arrayStory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellStory", for: indexPath) as! StoryPhotoCell
        
        let height = collectionView.frame.height
        let width = height * 0.7
        
        cell.imageView.layer.cornerRadius = width / 2
        cell.imageView.frame = CGRect(x: 0, y: 0, width: width, height: height * 0.7 )
        
        cell.imageView.image = UIImage(named: arrayStory[indexPath.section].image)
        cell.label.text = arrayStory[indexPath.section].title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Home: index selected = \(indexPath.section)")
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height
        let width = height * 0.7
        return CGSize(width: width, height: height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
      return sectionInsets
    }
}
