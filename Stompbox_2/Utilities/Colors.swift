//
//  Colors.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 5/1/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

struct AppColors {
  static let blue = UIColor(red: 4/255, green: 169/255, blue: 255/255, alpha: 1.0)
  static let black = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
  
  static let lightGray = UIColor(red: 25/255, green: 25/255, blue: 30/255, alpha: 1.0)
  static let lighterGray = UIColor(red: 35/255, green: 35/255, blue: 40/255, alpha: 1.0)
  static let lightestGray = UIColor(red: 60/255, green: 60/255, blue: 70/255, alpha: 1.0)
  static let systemLightGray = UIColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 1.0)
  
  static let darkerGray = UIColor(red: 20/255, green: 20/255, blue: 25/255, alpha: 1.0)
  
  
  
  static var foregroundColor: UIColor { get { return blue } }
  static var trackLayerHighlight: CGColor { get { return UIColor.white.cgColor } }
  static var trackLayerDefault: CGColor { get { return foregroundColor.cgColor } }
  static var clockLayerHighlight: CGColor { get { return UIColor.white.cgColor } }
  static var clockLayerDefault: CGColor { get { return foregroundColor.cgColor } }
  static var knobText: UIColor { get { return systemLightGray } }
}
