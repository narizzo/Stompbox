//
//  KnobView.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 2/6/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

class KnobView: UIControl {

  public override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = UIColor.lightGray
    layer.borderColor = UIColor.cyan.cgColor
    layer.borderWidth = 2
    print("Knob View init from frame:")
  }
  
  public required init?(coder aDecoder: NSCoder) {
    print("Knob View init from coder:")
    super.init(coder: aDecoder)
  }
}
