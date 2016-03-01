//
//  SoundboardOverview.swift
//  soundboardFramework
//
//  Created by Peter Alserda on 01/03/16.
//  Copyright © 2016 Peter Alserda. All rights reserved.
//

import UIKit
import RealmSwift

class SoundboardOverview: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let realm = try! Realm()
    let soundboards = try! Realm().objects(Soundboard)

    init() {
        let layout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        print(__FUNCTION__)
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }

    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (soundboards.count != 0) {
            return soundboards.count
        }
        return 0
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        print(__FUNCTION__, indexPath.row + 1, soundboards[indexPath.row])
        let soundboard = soundboards[indexPath.row]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
        
        let image = UIImage(data: soundboard.backgroundImage!)
        let backgroundImage = UIImageView(image: image)
        backgroundImage.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)
        backgroundImage.contentMode = .ScaleAspectFill
        cell.addSubview(backgroundImage)
//        cell.backgroundColor = UIColor.redColor()
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print(__FUNCTION__, indexPath)
    }
    
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let size = self.view.frame.size.width / 2
        
        return CGSizeMake(size, size)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
}
