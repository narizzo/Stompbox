//
//  TemplateSettingCell.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 4/24/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

class TemplateSettingCell: UITableViewCell, SettingCell {

  typealias knobViewType = TemplateKnobView
  var knobViews = [knobViewType]()
  var contentViewRef = UIView()
  var knobLayoutStyle: Int = 0
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    initializeCell()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
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
    for rect in rects {
      knobViews[i].set(frame: rect)
      i += 1
    }
//    for knobView in knobViews {
//      knobView.set(frame: rects[i])
//      i += 1
//    }
  }
}
