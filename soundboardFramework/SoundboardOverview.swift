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
    let backendConnection = BackendConnection.sharedInstance

    init() {
        let layout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        print(__FUNCTION__)
        collectionView!.backgroundColor = UIColor(hexString: "#bdc3c7")
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        let addSoundboardButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addSoundboardButtonPressed:")
        self.navigationItem.rightBarButtonItem = addSoundboardButton
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
        let soundboard = soundboards[indexPath.row]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
        
        let image = UIImage(data: soundboard.backgroundImage!)
        let backgroundImage = UIImageView(image: image)
        backgroundImage.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)
        backgroundImage.contentMode = .ScaleAspectFill
        cell.addSubview(backgroundImage)
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print(__FUNCTION__, indexPath)
        
        
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromRight
        self.navigationController!.view.layer.addAnimation(transition, forKey: nil)
//        let writeView : SoundboardDetail = soundboards[indexPath.row]
//        self.navigationController?.pushViewController(writeView, animated: false)
        
        
        
        
        
        
        
        
        let soundboardDetail = SoundboardDetail()
        soundboardDetail.soundboard = soundboards[indexPath.row]
        self.navigationController?.pushViewController(soundboardDetail, animated: false)
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
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
    
    func addSoundboardButtonPressed(sender: UIButton!) {
        print(__FUNCTION__)
        let alertController = UIAlertController(title: "Identifier", message: "Welke soundboard wil je? stuur ID", preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "ID"
        }
        let cancelAction = UIAlertAction(title: "Annuleren", style: .Cancel, handler: nil)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in
            let inputText = ((alertController.textFields?.first)! as UITextField).text!
            self.retrieveSoundboardData(identifier: inputText)
        }
        
        alertController.addAction(OKAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func retrieveSoundboardData(identifier identifier: String) {
        backendConnection.fetchSoundboard(identifier, success: { (response) -> () in
            print(response)
            let loadingScreen = LoadingSoundboard()
            loadingScreen.recievedJSON = response
            self.navigationController?.pushViewController(loadingScreen, animated: true)

            }) { (error) -> () in
                print(error)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        print(__FUNCTION__)
        collectionView?.reloadData()
    }
}
