//
//  SettingCell.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 4/12/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

protocol SettingCell {
  
  associatedtype KnobType
  var knobViews: [KnobType] { get set }
  var numberOfKnobViews: Int { get set }
  var knobLayoutStyle: Int16 { get set }
  
  
  func calculateNumberOfKnobViews()
  func populateKnobViews()
  func populateContentView()
  func clearKnobViewsFromContentView()
  func configureKnobViews()
}

// default behavior for configureKnobViews()?
