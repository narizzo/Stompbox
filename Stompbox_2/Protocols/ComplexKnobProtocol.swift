//
//  AdvancedKnobProtocol.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 4/6/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

protocol ComplexKnobRenderer: SimpleKnobProtocol {
  
  var valueLabel: KnobPositionLabel { get }
  var knobLabel: UILabel { get }
  
}
