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
  var settings: [Any]!
  var stompboxVCView: UIView! {
    didSet {
      for knob in knobViews {
        knob.stompboxVCView = stompboxVCView
      }
    }
  }
  
  // gets called if the cell is NOT designed in storyboard
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
  }
  
  // gets called if the cell is ONLY designed in storyboard
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
  }
  
  override func awakeFromNib() {
    frame.size.width = UIScreen.main.bounds.width
    layoutIfNeeded()
    setup()
  }
  
  func setup() {
    let sideLength = self.frame.size.height / 2.0
    let halfSideLength = sideLength / 2.0

    let halfWidth = self.frame.size.width / 2.0
    
//    let testKnob0 = KnobView(frame: CGRect(x: oneThirdWidth - halfSideLength, y: 0, width: sideLength, height: sideLength))
    let testKnob0 = KnobView(frame: CGRect(x: halfWidth - halfSideLength * 3.0, y: 0, width: sideLength, height: sideLength))
    testKnob0.changeFillColor(to: UIColor.clear)
    testKnob0.changeStrokeColor(to: UIColor.black)
    
    let testKnob1 = KnobView(frame: CGRect(x: halfWidth - halfSideLength, y: sideLength, width: sideLength, height: sideLength))
    testKnob1.changeFillColor(to: UIColor.clear)
    testKnob1.changeStrokeColor(to: UIColor.black)
    testKnob1.moveKnobLabelAbove()
    
    let testKnob2 = KnobView(frame: CGRect(x: halfWidth + halfSideLength, y: 0, width: sideLength, height: sideLength))
    //testKnob2.backgroundColor = UIColor.blue
    testKnob2.changeFillColor(to: UIColor.clear)
    testKnob2.changeStrokeColor(to: UIColor.black)
    
    knobViews.append(testKnob0)
    knobViews.append(testKnob1)
    knobViews.append(testKnob2)
    
    contentView.addSubview(testKnob0)
    contentView.addSubview(testKnob1)
    contentView.addSubview(testKnob2)
    
    testKnob0.setValue(value: 0, animated: false)
    testKnob1.setValue(value: 0, animated: false)
    testKnob2.setValue(value: 0, animated: false)
    
    testKnob0.changeKnobLabelText(to: "Level")
    testKnob1.changeKnobLabelText(to: "Tone")
    testKnob2.changeKnobLabelText(to: "Gain")
    
    print("About to attempt setting knob value")
    if let settingsArray = settings {
      print("settingsArray exists...")
      if let aSetting = settingsArray.first as? Setting {
        print("aSetting in the array exists...")
        testKnob0.setValue(value: (aSetting.knobs?.knobsList[0].continuousValue)!, animated: true)
      }
    } else {
      
    }
  }
}
