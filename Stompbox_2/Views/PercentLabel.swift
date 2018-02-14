//
//  PercentLabel.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 2/14/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

class PercentLabel: UILabel {
  
  func update(text: Float) {
    self.text = NumberFormatter.localizedString(from: NSNumber(value: text), number: .percent)
    textColor = UIColor.black
    backgroundColor = UIColor.clear
    textAlignment = .center
  }

}
