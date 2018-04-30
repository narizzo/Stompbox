//
//  SettingCollectionViewController.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 4/19/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

class SettingCollectionViewController: UIViewController {
  
  var collectionCellDelegate: CollectionCellDelegate!
  
  var collectionView: UICollectionView!
  let layout = UICollectionViewFlowLayout()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initialize()
  }
  
  private func initialize() {
    collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
    
    let spacing: CGFloat = 3.0
    layout.minimumLineSpacing = spacing
    layout.minimumInteritemSpacing = spacing
    
    collectionView.delegate = self
    collectionView.dataSource = self
    
    let collectionCellNib = UINib(nibName: "CollectionCell", bundle: nil)
    collectionView.register(collectionCellNib, forCellWithReuseIdentifier: Constants.collectionCellReuseID)
    view.addSubview(collectionView)
  }
}

// MARK: UICollectionView
extension SettingCollectionViewController: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if let collectionCell = collectionView.cellForItem(at: indexPath) as? SettingCollectionViewCell {
      collectionCellDelegate.didSelectCollectionCell(collectionCell)
    }
    collectionView.deselectItem(at: indexPath, animated: false)
  }
}

extension SettingCollectionViewController: UICollectionViewDataSource {
  
  // data loading
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 12
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.collectionCellReuseID, for: indexPath) as? SettingCollectionViewCell {
      
      // Shade cell backgrounds using bit mask 1001 as the shading pattern
      let mask = [1,0,0,1]
      mask[indexPath.row % 4] == 1 ? (cell.backgroundColor = darkerGray) : (cell.backgroundColor = lighterGray)
      
      //cell.collectionCellDelegate = self.collectionCellDelegate
      cell.templateSettingCell.knobLayoutStyle = indexPath.row
      // cell.setSize(to: layout.itemSize)
      return cell
    }
    
    return UICollectionViewCell()
  }
}

// MARK: UICollectionViewDelegateFlowLayout
extension SettingCollectionViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let buffer = layout.minimumInteritemSpacing / 2.0
    let width = collectionView.frame.width / 2.0 - buffer
    let height = collectionView.frame.height / 2.0 - buffer
    let size = CGSize(width: width, height: height)
    if let cell = collectionView.cellForItem(at: indexPath) as? SettingCollectionViewCell {
      cell.setSize(to: size)
    }
    //print("size: \(size)")
    return size
    //layout.itemSize = size
  }
  
  /*
   func  collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) {
   } */
}
