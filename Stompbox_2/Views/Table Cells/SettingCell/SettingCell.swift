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
  //var numberOfKnobViews: Int { get set }
  var knobLayoutStyle: Int16 { get set }
  
  
  func calculateNumberOfKnobViews() -> Int
  func populateKnobViews()
  func populateContentView()
  func configureKnobViews()
  func calculateKnobViewRects(for bounds: CGRect) -> [CGRect]
}

// MARK: - Cell Extension
extension SettingCell where Self: UITableViewCell {
  
  func calculateNumberOfKnobViews() -> Int {
    switch knobLayoutStyle {
    case 0:
      return 3
    case 1:
      return 3
    case 2:
      return 3
    default:
      return 1
    }
  }
  
  func calculateKnobViewRects(for bounds: CGRect) -> [CGRect] {
    let knobSide = bounds.size.height / 2.0
    let halfKnobSide = knobSide / 2.0
    let halfCellWidth = bounds.size.width / 2.0
    let halfCellHeight = bounds.size.height / 2.0
    
    var knobViewPositions = [CGPoint]()
    var knobViewRects = [CGRect]()
    
    switch knobLayoutStyle {
    case 0:
      // Upside-down Triangle
      knobViewPositions = [CGPoint(x: halfCellWidth - halfKnobSide * 3.0, y: 0),
                           CGPoint(x: halfCellWidth - halfKnobSide,       y: knobSide),
                           CGPoint(x: halfCellWidth + halfKnobSide,       y: 0),]
    case 1:
      // Right-side-up Triangle
      knobViewPositions = [CGPoint(x: halfCellWidth - halfKnobSide * 3.0, y: knobSide),
                           CGPoint(x: halfCellWidth - halfKnobSide,       y: 0),
                           CGPoint(x: halfCellWidth + halfKnobSide,       y: knobSide),]
    case 2:
      // Three Horizontal
      knobViewPositions = [CGPoint(x: halfCellWidth - halfKnobSide * 3.0, y: halfCellHeight - halfKnobSide),
                           CGPoint(x: halfCellWidth - halfKnobSide,       y: halfCellHeight - halfKnobSide),
                           CGPoint(x: halfCellWidth + halfKnobSide,       y: halfCellHeight - halfKnobSide),]
    default:
      knobViewPositions = [CGPoint(x: halfCellWidth - halfKnobSide,       y: halfCellHeight - halfKnobSide),]
    }
    
    let size = CGSize(width: knobSide, height: knobSide)
    for point in knobViewPositions {
      knobViewRects.append(CGRect(origin: point, size: size))
    }
    
    return knobViewRects
  }
}


// MARK: - Extension for Simple
extension SettingCell where knobViewType == SimpleKnobView {
  
  //REDUNDANT
  func populateContentView() {
    for knobView in knobViews {
      contentViewRef.addSubview(knobView)
    }
  }
  
  func populateKnobViews() {
    let targetCount = calculateNumberOfKnobViews()
    while knobViews.count < targetCount {
      knobViews.append(SimpleKnobView())
    }
  }
}


// MARK: - Extension for Complex
extension SettingCell where knobViewType == ComplexKnobView {
  
  //REDUNDANT
  func populateContentView() {
    for knobView in knobViews {
      contentViewRef.addSubview(knobView)
    }
  }
  
  func populateKnobViews() {
    print("populateKnobViews()")
    let targetCount = calculateNumberOfKnobViews()
    while knobViews.count < targetCount {
      knobViews.append(ComplexKnobView())
    }
  }
}
