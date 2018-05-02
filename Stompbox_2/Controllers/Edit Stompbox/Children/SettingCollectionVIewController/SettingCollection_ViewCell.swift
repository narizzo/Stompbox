//
//  SettingCollectionViewCell.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 4/26/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

protocol CollectionCellDelegate: class {
  func didSelectCollectionCell(_ settingCollectionViewCell: SettingCollectionViewCell)
}

class SettingCollectionViewCell: UICollectionViewCell {
  
  // MARK: - Properties
  var templateSettingCell = TemplateSettingCell()
  var delegate: CollectionCellDelegate!
  
  // MARK: - Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    initialize()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initialize()
  }
  
  private func initialize() {
    contentView.addSubview(templateSettingCell)
    
    addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
  }
  
  @objc private func handleTap() {
    delegate.didSelectCollectionCell(self)
  }
  
  // MARK: - Frame
  func setSize(to size: CGSize) {
    bounds.size = size
    templateSettingCell.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
    templateSettingCell.configureKnobViewsRects()
  }
}
