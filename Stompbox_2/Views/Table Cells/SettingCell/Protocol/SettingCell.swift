//
//  SettingCell.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 4/12/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

protocol SettingCell: class {
  
  associatedtype knobViewType
  var knobViews: [knobViewType] { get set }
  var contentViewRef: UIView { get set }
  var knobLayoutStyle: Int { get set }
  
  
  func calculateNumberOfKnobViews() -> Int
  func clearExistingKnobViews()
  func populateKnobViews()
  func populateContentView()
  func configureKnobViewRects()
  func calculateKnobViewRects(with bounds: CGRect) -> [CGRect]
}

// MARK: - Cell Extension
extension SettingCell where Self: UITableViewCell {
  
  // default inits in protocol?
  
  // replace with a dictionary?
  func calculateNumberOfKnobViews() -> Int {
    switch knobLayoutStyle {
    case 0:
      return 1
    case 1:
      return 2
    case 2:
      return 3
    case 3:
      return 3
    case 4:
      return 3
    case 5:
      return 4
    case 6:
      return 4
    case 7:
      return 4
//    case 6:
//      return 4
    default:
      return 1
    }
  }
  
  func calculateKnobViewRects(with bounds: CGRect) -> [CGRect] {
    let centerY = bounds.midY
    let centerX = bounds.midX
    let quarter = bounds.width / 4.0
    let halfCellHeight = centerY
    let quarterCellHeight = halfCellHeight / 2.0
    
    let verticalBuffer = bounds.height * 0.05
    let smallBuffer = bounds.width * 0.05
    
    var knobViewPositions = [CGPoint]()
    var knobViewRects = [CGRect]()
    
    switch knobLayoutStyle {
    case 0:
      // One Centered
      knobViewPositions = [CGPoint(x: centerX - quarterCellHeight,       y: centerY - quarterCellHeight),]
    case 1:
      knobViewPositions = [CGPoint(x: centerX - halfCellHeight - smallBuffer, y: centerY - quarterCellHeight),
                           CGPoint(x: centerX + smallBuffer,                      y: centerY - quarterCellHeight),]
    case 2:
      // Upside-down Triangle
      knobViewPositions = [CGPoint(x: centerX - quarterCellHeight * 3.0, y: verticalBuffer),
                           CGPoint(x: centerX - quarterCellHeight,       y: halfCellHeight - verticalBuffer),
                           CGPoint(x: centerX + quarterCellHeight,       y: verticalBuffer),]
    case 3:
      // Triangle
      knobViewPositions = [CGPoint(x: centerX - quarterCellHeight * 3.0, y: halfCellHeight - verticalBuffer),
                           CGPoint(x: centerX - quarterCellHeight,       y: verticalBuffer),
                           CGPoint(x: centerX + quarterCellHeight,       y: halfCellHeight - verticalBuffer),]
    case 4:
      // Three: Horizontal
      knobViewPositions = [CGPoint(x: centerX - quarterCellHeight * 3.0 - smallBuffer, y: centerY - quarterCellHeight),
                           CGPoint(x: centerX - quarterCellHeight,                         y: centerY - quarterCellHeight),
                           CGPoint(x: centerX + quarterCellHeight + smallBuffer,       y: centerY - quarterCellHeight),]
    case 5:
      // Four: Across
      knobViewPositions = [CGPoint(x: 0, y: centerY - quarterCellHeight),
                           CGPoint(x: quarter,                         y: centerY - quarterCellHeight),
                           CGPoint(x: quarter * 2.0,       y: centerY - quarterCellHeight),
                           CGPoint(x: quarter * 3.0,       y: centerY - quarterCellHeight),]
    case 6:
      // Four: UpDownUpDown
      knobViewPositions = [CGPoint(x: 0,                    y: centerY - quarterCellHeight - (quarterCellHeight / 2.0)),
                           CGPoint(x: quarter,              y: centerY - quarterCellHeight + (quarterCellHeight / 2.0)),
                           CGPoint(x: quarter * 2.0,        y: centerY - quarterCellHeight - (quarterCellHeight / 2.0)),
                           CGPoint(x: quarter * 3.0,        y: centerY - quarterCellHeight + (quarterCellHeight / 2.0)),]
    case 7:
      // Four: DownUpDownUp
      knobViewPositions = [CGPoint(x: 0,                    y: centerY - quarterCellHeight + (quarterCellHeight / 2.0)),
                           CGPoint(x: quarter,              y: centerY - quarterCellHeight - (quarterCellHeight / 2.0)),
                           CGPoint(x: quarter * 2.0,        y: centerY - quarterCellHeight + (quarterCellHeight / 2.0)),
                           CGPoint(x: quarter * 3.0,        y: centerY - quarterCellHeight - (quarterCellHeight / 2.0)),]
//  case 8:
//      // Four: 2x2
//      knobViewPositions = [CGPoint(x: quarter,              y: centerY - halfKnobSide + (halfKnobSide / 2.0)),
//                           CGPoint(x: quarter,              y: centerY - halfKnobSide - (halfKnobSide / 2.0)),
//                           CGPoint(x: quarter * 2.0,        y: centerY - halfKnobSide + (halfKnobSide / 2.0)),
//                           CGPoint(x: quarter * 2.0,        y: centerY - halfKnobSide - (halfKnobSide / 2.0)),]
    default:
      // One Centered
      knobViewPositions = [CGPoint(x: centerX - quarterCellHeight,       y: centerY - quarterCellHeight),]
    }
    let size: CGSize
    if knobViewPositions.count == 4 {
      let side = bounds.width / 4.0
      size = CGSize(width: side, height: side)
    } else {
      size = CGSize(width: halfCellHeight, height: halfCellHeight)
    }
    for point in knobViewPositions {
      knobViewRects.append(CGRect(origin: point, size: size))
    }
    
    return knobViewRects
  }
}

// MARK: - Extension for Template
extension SettingCell where knobViewType == TemplateKnobView {
  
  func populateKnobViews() {
    let targetCount = calculateNumberOfKnobViews()
    while knobViews.count < targetCount {
      knobViews.append(TemplateKnobView())
    }
  }
  
  func clearExistingKnobViews() {
    for knobView in knobViews {
      knobView.removeFromSuperview()
    }
    knobViews.removeAll()
  }
  
  //REDUNDANT
  func populateContentView() {
    for knobView in knobViews {
      contentViewRef.addSubview(knobView)
    }
  }
}

// MARK: - Extension for Simple
extension SettingCell where knobViewType == SimpleKnobView {
  
  func populateKnobViews() {
    let targetCount = calculateNumberOfKnobViews()
    while knobViews.count < targetCount {
      knobViews.append(SimpleKnobView())
    }
  }
  
  func clearExistingKnobViews() {
    for knobView in knobViews {
      knobView.removeFromSuperview()
    }
    knobViews.removeAll()
  }
  
  //REDUNDANT
  func populateContentView() {
    for knobView in knobViews {
      contentViewRef.addSubview(knobView)
    }
  }
}

// MARK: - Extension for Complex
extension SettingCell where knobViewType == ComplexKnobView {
  
  func populateKnobViews() {
    let targetCount = calculateNumberOfKnobViews()
    while knobViews.count < targetCount {
      knobViews.append(ComplexKnobView())
    }
  }
  
  func clearExistingKnobViews() {
    for knobView in knobViews {
      knobView.removeFromSuperview()
    }
    knobViews.removeAll()
  }
  
  //REDUNDANT
  func populateContentView() {
    for knobView in knobViews {
      contentViewRef.addSubview(knobView)
    }
  }
}
