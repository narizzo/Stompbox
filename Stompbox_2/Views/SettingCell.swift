//
//  SettingCell.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 2/6/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

class SettingCell: UITableViewCell {
  
  var knobViews = [KnobView]()
  var parentStompbox: Stompbox!
  
  // gets called if the cell is NOT designed in storyboard
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()
  }
  
  // gets called if the cell is ONLY designed in storyboard
  required init?(coder aDecoder: NSCoder) {
//    print("SettingCell")
//   fatalError("init(coder:) has not been implemented")
    super.init(coder: aDecoder)
    setup()
  }
  
  func setup() {
    knobViews.append(KnobView(frame: self.bounds))
    print(knobViews.first!.debugDescription)
    contentView.addSubview(knobViews.first!)
    //addSubview(knobViews.first!)
  }
}
