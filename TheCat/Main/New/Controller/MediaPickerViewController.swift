//
//  MediaPickerViewController.swift
//  DogSay
//
//  Created by jewelz on 2017/5/3.
//  Copyright © 2017年 jewelz. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD
import Photos
import SwiftlyKit

private let cellWidth = (ScreenW - 6 ) / 4

class MediaPickerViewController: UIViewController {
    
    lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        let collectionV  = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionV.backgroundColor = UIColor.white
        collectionV.dataSource = self
        collectionV.delegate = self
//        collectionV.registerClass(ThumbnailCell.self)
//        collectionV.registerReusableSectionHeader(ProfileHeader.self)
        return collectionV
    }()

    fileprivate var selectedItem: Int = -1
    
    var allPhotos: PHFetchResult<PHAsset>!
    
    
    let imageManager = PHCachingImageManager()
    
    
    lazy var targetSize: CGSize = {
        let scale = UIScreen.main.scale
        let wH = cellWidth * scale
        return CGSize(width: wH, height: wH)
    }()
    
    lazy var options: PHImageRequestOptions = {
        let ops = PHImageRequestOptions()
        ops.isSynchronous = false
        //options.deliveryMode = .fastFormat
        ops.resizeMode = .exact
        return ops
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(MediaPickerViewController.cancelButtonClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "下一步", style: .plain, target: self, action: #selector(MediaPickerViewController.nextStep))
       
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(collectionView.superview!)
        }
//        collectionView.registerClass(ThumbnailCell.self)

        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        allPhotos =  PHAsset.fetchAssets(with: allPhotosOptions)

        PHPhotoLibrary.shared().register(self)
        
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        imageManager.stopCachingImagesForAllAssets()
    }

    
    // MARK: - Action
    
    @objc func cancelButtonClicked() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func nextStep() {
        
        guard selectedItem >= 0, let asset = allPhotos?[selectedItem] else {
            SVProgressHUD.showInfo(withStatus: "请选择一张照片")
            return
        }
        
        let vc = MediaEditingViewController()
        vc.asset = asset
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
   // private lazy var allPhotosCollection = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil).lastObject
    
//    private func getAllPhotos() {
//            
////        guard let  camerRoll = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil).lastObject else {
////            //self.getPhotos(in: camerRoll)
////            return
////        }
//        
//        
//        collectionView.reloadData()
//    }
    
    
    
}

extension MediaPickerViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        fatalError()
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let allPhotos = allPhotos else {
            return 0
        }
        return allPhotos.count
    }
    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(for: indexPath) as ThumbnailCell
//        cell.isPickerThumbnail = true
//        if let asset = allPhotos?[indexPath.item] {
//            cell.representedAssetIdentifier = asset.localIdentifier
//            
//            imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .default, options: options, resultHandler: { image, _ in
//                if let image = image, cell.representedAssetIdentifier == asset.localIdentifier {
//                    cell.thumanail.image = image
//                }
//            })
//        }
//        
//        return cell
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItem = indexPath.item
    }
    
    
}

extension MediaPickerViewController: PHPhotoLibraryChangeObserver {
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        // Change notifications may be made on a background queue. Re-dispatch to the
        // main queue before acting on the change as we'll be updating the UI.
        DispatchQueue.main.sync {
            // Check each of the three top-level fetches for changes.
           
            if let changeDetails = changeInstance.changeDetails(for: allPhotos) {
                allPhotos = changeDetails.fetchResultAfterChanges
                collectionView.reloadData()
               
            }
            
        }
    }
}

