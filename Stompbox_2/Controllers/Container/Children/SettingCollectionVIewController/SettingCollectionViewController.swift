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
    
    collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
    
    collectionView.delegate = self
    collectionView.dataSource = self
    
    let collectionCellNib = UINib(nibName: Constants.settingCollectionCellNib, bundle: nil)
    collectionView.register(collectionCellNib, forCellWithReuseIdentifier: Constants.settingCollectionCellReuseID)
    view.addSubview(collectionView)
  }
  
  func updateView() {
    view.setNeedsLayout()
    view.layoutIfNeeded()
    
    collectionView.frame = view.bounds
    collectionView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - 21)
    /* 21 is a magic number to offset the collectionView's height.  For some reason it's too tall by exactly 21 points on every size phone */
    collectionView.setNeedsLayout()
    collectionView.layoutIfNeeded()
    
    collectionView.reloadData()
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
    return 24
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.settingCollectionCellReuseID, for: indexPath) as? SettingCollectionViewCell {
      
      // Shade cell backgrounds using bit mask 1001 as the shading pattern
      let mask = [1,0,0,1]
      mask[indexPath.row % 4] == 1 ? (cell.backgroundColor = darkerGray) : (cell.backgroundColor = lighterGray)
      cell.templateSettingCell.knobLayoutStyle = indexPath.row
      return cell
    }
    return UICollectionViewCell()
  }
}

// MARK: UICollectionViewDelegateFlowLayout
extension SettingCollectionViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//    let spacing: CGFloat = 3.0
//    layout.minimumLineSpacing = spacing
//    layout.minimumInteritemSpacing = spacing
//    let buffer = layout.minimumInteritemSpacing / 2.0
    let spacing: CGFloat = 0.0
    layout.minimumLineSpacing = spacing
    layout.minimumInteritemSpacing = spacing
    let buffer = layout.minimumInteritemSpacing / 2.0
    
    let size = CGSize(width: self.view.bounds.width / 2.0 - buffer, height: self.view.bounds.height / 2.0)
    
    // propagate size changes : redraw knob layers
    if let genericCell = collectionView.cellForItem(at: indexPath) {
      if let cell = genericCell as? SettingCollectionViewCell {
        cell.setSize(to: size)
      }
    }
    return size
  }
  
  /*
   func  collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) {
   } */
}
