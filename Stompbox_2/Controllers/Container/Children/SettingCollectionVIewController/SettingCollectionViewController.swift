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
    view.addSubview(collectionView)
  }
}

extension SettingCollectionViewController: UICollectionViewDelegate {
  
}

//extension SettingCollectionViewController: UICollectionViewDataSource {
//  
//}
