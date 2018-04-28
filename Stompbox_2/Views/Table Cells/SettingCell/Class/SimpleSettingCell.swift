//
//  SimpleSettingCell.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 4/11/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

class SimpleSettingCell: UITableViewCell, SettingCell {
  
  typealias knobViewType = SimpleKnobView
  var knobViews = [knobViewType]()
  var contentViewRef = UIView()
  var knobLayoutStyle: Int = 0 {
    didSet {
      configureKnobViewsRects()
    }
  }
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    initializeCell()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initializeCell()
  }
  
  override func awakeFromNib() {
    frame.size.width = UIScreen.main.bounds.width
    layoutIfNeeded()
    initializeCell()
  }
  
  // MARK: - Custom Init
  private func initializeCell() {
    contentViewRef = contentView
    configureKnobViewsRects()
  }
  
  // REDUNDANT
  func configureKnobViewsRects() {
    clearExistingKnobViews()
    populateKnobViews()
    populateContentView()
    let rects = calculateKnobViewRects(with: self.bounds)
    var i = 0
    for knobView in knobViews {
      knobView.set(frame: rects[i])
      i += 1
    }
  }
}
