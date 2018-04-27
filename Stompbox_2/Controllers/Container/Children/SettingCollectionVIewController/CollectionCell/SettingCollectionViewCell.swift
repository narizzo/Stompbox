//
//  SettingCollectionViewCell.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 4/26/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

class SettingCollectionViewCell: UICollectionViewCell {
  
  var templateSettingCell = TemplateSettingCell()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initialize()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initialize()
  }
  
  private func initialize() {
    //templateSettingCell = TemplateSettingCell(frame: bounds)
    contentView.addSubview(templateSettingCell)
    contentView.backgroundColor = UIColor.orange
    self.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
  }
  
  @objc private func handleTap() {
    print("Collection View Cell Tapped")
  }
  
  func setSize(to size: CGSize) {
    bounds.size = size
    templateSettingCell.bounds.size = size
    templateSettingCell.configureKnobViewsRects()
    
    
  }
  
}
