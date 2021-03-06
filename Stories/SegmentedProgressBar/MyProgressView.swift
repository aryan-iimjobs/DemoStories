//
//  MyProgressView.swift
//  SegmentedProgressBar
//
//  Created by iim jobs on 04/03/20.
//  Copyright © 2020 iim jobs. All rights reserved.
//

import UIKit

protocol SegmentedProgressBarDelegate: class {
    func segmentedProgressBarChangedIndex(index: Int)
    func segmentedProgressBarFinished()
}

class MyProgressView: UIView {
    
    weak var delegate: SegmentedProgressBarDelegate?
    
    var arrayBars: [UIProgressView] = []
    
    var padding: CGFloat = 2.0
    
    private var hasDoneLayout = false // prevent layouting again
    
    var currentAnimationIndex = 0
    
    var timer: Timer?
    
    private var paused = false
    
    init(arrayStories: Int) { // future arg: array of stories
        // init var here
        super.init(frame: .zero)
        
        for _ in 0...arrayStories - 1 {
            let bar = UIProgressView()
            arrayBars.append(bar)
            addSubview(bar)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if hasDoneLayout {
            return
        }
        
        let width = (frame.width - (padding * CGFloat(arrayBars.count - 1)) ) / CGFloat(arrayBars.count)
        
        for (index, progressBar) in arrayBars.enumerated() {
            
            let segFrame = CGRect(x: CGFloat(index) * (width + padding), y: 0, width: width, height: 20)
            progressBar.frame = segFrame
            
            progressBar.progress = 0.0
            
            //progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 3)
            
            progressBar.tintColor = .white
            progressBar.backgroundColor = UIColor.black
            progressBar.layer.cornerRadius = progressBar.frame.height / 2
        }
        
        hasDoneLayout = true
    }
    
    func animate(index: Int) {
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(updateProgressBar(_:)), userInfo: index, repeats: true)
        currentAnimationIndex = index
    }
    
    @objc func updateProgressBar(_ timer: Timer) {
        let selectdStoryIndex = timer.userInfo as! Int
        
        let progressBar = arrayBars[selectdStoryIndex]
        progressBar.progress += 0.01
        progressBar.setProgress(progressBar.progress, animated: true)
        
        
        if  progressBar.progress == 1.0 {
            self.next()
        }
    }
    
    private func next() {
        print("invalidate timer")
        
        let newIndex = self.currentAnimationIndex + 1
        if currentAnimationIndex < arrayBars.count - 1 {
            print("next story")
            self.timer?.invalidate()
            self.animate(index: newIndex)
            self.delegate?.segmentedProgressBarChangedIndex(index: newIndex)
        } else {
            print("Story ended")
            self.timer?.invalidate()
            self.delegate?.segmentedProgressBarFinished()
        }
    }
    
    func pause() {
        if paused {
            // resume
            paused = false
            print("resume")
            self.animate(index: currentAnimationIndex)
        } else {
            paused = true
            print("pause")
            self.timer?.invalidate()
        }
    }
    
    func resetBar(index: Int) {
        for i in arrayBars {
            i.progress = 0.0
            print("set to zero")
        }
    }
    
    
    func skip() {
        if paused {
            paused = false
        }
        print("skip")
        let currentBar = arrayBars[currentAnimationIndex]
        currentBar.progress = 1.0
        self.next()
    }
    
    func rewind() {
        print("rewind")
        if paused {
            paused = false
        }
        let currentBar = arrayBars[currentAnimationIndex]
        currentBar.progress = 0.0
        
        let newIndex = max(currentAnimationIndex - 1, 0)
        let prevBar = arrayBars[newIndex]
        prevBar.setProgress(0.0, animated: false)
        
        self.timer?.invalidate()
        self.animate(index: newIndex)
        self.delegate?.segmentedProgressBarChangedIndex(index: newIndex)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


