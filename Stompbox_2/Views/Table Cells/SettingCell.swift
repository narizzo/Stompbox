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
  
//  let knobFrame0 = CGRect(x: 0, y: 0, width: 100, height: 100)
//  let knobFrame1 = CGRect(x: 0, y: 100, width: 100, height: 100)
  
  // gets called if the cell is NOT designed in storyboard
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()
  }
  
  // gets called if the cell is ONLY designed in storyboard
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  func setup() {
  
    let testKnob = KnobView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    testKnob.changeFillColor(to: UIColor.clear)
    testKnob.changeStrokeColor(to: UIColor.white)
    knobViews.append(testKnob)
    contentView.addSubview(testKnob)
    
    print("About to attempt setting knob value")
    if let settingsArray = settings {
      print("settingsArray exists...")
      if let aSetting = settingsArray.first as? Setting {
        print("aSetting in the array exists...")
        testKnob.setValue(value: (aSetting.knobs?.knobsList[0].continuousValue)!, animated: true)
      }
    }
    
    
    //      let settingsArray = stompbox.settings?.allObjects
    //      if let settingsArray = settingsArray {
    //        if let aSetting = settingsArray.first as? Setting {
    //         // print("Number of knobs \(aSetting.knobs?.knobsList.count)")
    //         // print("\(aSetting.knobs?.knobsList[0].continuousValue)")
    //        }
    //      }
  }
}
