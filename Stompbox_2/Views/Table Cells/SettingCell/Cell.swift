//
//  SettingCell.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 4/12/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

protocol Cell {
  
  associatedtype knobViewType
  var knobViews: [knobViewType] { get set }
  var contentViewRef: UIView { get set }
  var numberOfKnobViews: Int { get set }
  var knobLayoutStyle: Int16 { get set }
  
  
  func calculateNumberOfKnobViews() -> Int
  func populateKnobViews()
  func populateContentView()
 // func clearKnobViewsFromContentView()
  func configureKnobViews()
}

// MARK: - Cell Extension
extension Cell {
  func calculateNumberOfKnobViews() -> Int {
    switch knobLayoutStyle {
    case 0:
      return 3
    default:
      return 0
    }
  }
}

// MARK: - Extension for Simple
extension Cell where knobViewType == SimpleKnobView {
  
  func populateContentView() {
    for knobView in knobViews {
      contentViewRef.addSubview(knobView)
    }
  }
  
  mutating func populateKnobViews() {
    let targetCount = calculateNumberOfKnobViews()
   
    while knobViews.count < targetCount {
      knobViews.append(SimpleKnobView())
    }
  }
}


// MARK: - Extension for Complex
extension Cell where knobViewType == ComplexKnobView {
  
  func populateContentView() {
    for knobView in knobViews {
      contentViewRef.addSubview(knobView)
    }
  }
  
  mutating func populateKnobViews() {
    let targetCount = calculateNumberOfKnobViews()
    
    while knobViews.count < targetCount {
      knobViews.append(ComplexKnobView())
    }
  }
}
