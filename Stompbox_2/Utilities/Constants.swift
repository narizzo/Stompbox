//
//  Constants.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 4/18/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

public struct Constants {
  
  // Misc
  static let stompboxDetailSegue = "stompboxDetailSegue"
  static let stompboxCache = "stompboxCache"
  
  // Reusable Cells
  static let stompboxCellReuseID = "stompboxCellReuseID"
  static let simpleSettingReuseID = "simpleSettingReuseID"
  static let complexSettingReuseID = "complexSettingReuseID"
  static let settingCollectionCellReuseID = "collectionCellReuseID"
  
  // Nibs
  static let stompboxNib = "StompboxCell"
  static let settingCellSimpleNib = "SimpleSettingCell"
  static let settingCellComplexNib = "ComplexSettingCell"
  static let settingCollectionCellNib = "SettingCollectionCell"
  
  // Cell Dimensions
  static let stompboxCellHeight: CGFloat = 200
  static let settingCellHeight: CGFloat = 200
}
