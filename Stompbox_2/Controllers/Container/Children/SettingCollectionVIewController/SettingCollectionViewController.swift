//
//  SettingCollectionViewController.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 4/19/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

class SettingCollectionViewController: UIViewController {
  
  var collectionView: UICollectionView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: view.bounds.width / 2.0, height: view.bounds.height / 2.0)
    collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
    
    self.view.backgroundColor = UIColor.red
    self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
  }
  
  @objc private func handleTap() {
    print("Tap")
  }
}

extension SettingCollectionViewController: UICollectionViewDelegate {
  // interaction
}

extension SettingCollectionViewController: UICollectionViewDataSource {
  // data loading
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 8
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.collectionCellReuseID, for: indexPath)
    cell.contentView.backgroundColor = UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1.0)
    return cell
  }
  
  
}
