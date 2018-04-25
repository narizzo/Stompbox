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
  var knobLayoutStyle: Int16 { get set }
  
  
  func calculateNumberOfKnobViews() -> Int
  func populateKnobViews()
  func populateContentView()
  func configureKnobViewsRects()
  func calculateKnobViewRects(with bounds: CGRect) -> [CGRect]
}

// MARK: - Cell Extension
extension SettingCell where Self: UITableViewCell {
  
  // default inits in protocol?
  
  // replace with a dictionary?
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
  
  func calculateKnobViewRects(with bounds: CGRect) -> [CGRect] {
    let centerY = bounds.midY
    let centerX = bounds.midX
    let knobSide = centerY
    let halfKnobSide = knobSide / 2.0
    
    let verticalBuffer = bounds.height * 0.05
    
    var knobViewPositions = [CGPoint]()
    var knobViewRects = [CGRect]()
    
    switch knobLayoutStyle {
    case 0:
      // Upside-down Triangle
      knobViewPositions = [CGPoint(x: centerX - halfKnobSide * 3.0, y: verticalBuffer),
                           CGPoint(x: centerX - halfKnobSide,       y: knobSide - verticalBuffer),
                           CGPoint(x: centerX + halfKnobSide,       y: verticalBuffer),]
    case 1:
      // Triangle
      knobViewPositions = [CGPoint(x: centerX - halfKnobSide * 3.0,                 y: knobSide),
                           CGPoint(x: centerX - halfKnobSide,       y: 0),
                           CGPoint(x: centerX + halfKnobSide,       y: knobSide),]
    case 2:
      // Three Horizontal
      knobViewPositions = [CGPoint(x: centerX - halfKnobSide * 3.0, y: centerY - halfKnobSide),
                           CGPoint(x: centerX - halfKnobSide,       y: centerY - halfKnobSide),
                           CGPoint(x: centerX + halfKnobSide,       y: centerY - halfKnobSide),]
    default:
      // One Centered
      knobViewPositions = [CGPoint(x: centerX - halfKnobSide,       y: centerY - halfKnobSide),]
    }
    
    let size = CGSize(width: knobSide, height: knobSide)
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
  
  //REDUNDANT
  func populateContentView() {
    for knobView in knobViews {
      contentViewRef.addSubview(knobView)
    }
  }
}
