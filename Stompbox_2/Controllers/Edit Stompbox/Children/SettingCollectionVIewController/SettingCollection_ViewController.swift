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
    
    // layout properties
    let spacing: CGFloat = 0.0
    layout.minimumLineSpacing = spacing
    layout.minimumInteritemSpacing = spacing
    
    // initialize collectionView and its properties
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
    
    collectionView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - 21)
    /* 21 is a magic number to offset the collectionView's height.  For some reason it's too tall by exactly 21 points on every size phone */
    collectionView.setNeedsLayout()
    collectionView.layoutIfNeeded()
    
    updateItemSize()
    collectionView.reloadData()
  }
  
  private func updateItemSize() {
    /* 21 is a magical vertical offset number.  The view height is too large by 21. */ 
    layout.itemSize = CGSize(width: view.bounds.width / 2.0, height: (view.bounds.height - 21) / 2.0)
  }
}

// MARK: UICollectionView
extension SettingCollectionViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: false)
  }
}

extension SettingCollectionViewController: UICollectionViewDataSource {
  // data loading
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 8
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.settingCollectionCellReuseID, for: indexPath) as? SettingCollectionViewCell {
      // Shade cell backgrounds using bit mask 1001 as the shading pattern
      let mask = [1,0,0,1]
      mask[indexPath.row % 4] == 1 ? (cell.backgroundColor = darkerGray) : (cell.backgroundColor = lighterGray)
      
      // propagate size changes : redraw knob layers
      cell.templateSettingCell.knobLayoutStyle = indexPath.row
      cell.setSize(to: layout.itemSize) // custom knob drawing redraws according to the new size
      cell.delegate = collectionCellDelegate
      
      return cell
    }
    return UICollectionViewCell()
  }
}
