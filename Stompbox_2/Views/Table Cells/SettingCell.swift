//
//  SettingCell.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 2/6/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit
import CoreData

class SettingCell: UITableViewCell {
  
  var knobViews = [KnobView]()
  var coreDataStack: CoreDataStack!
  var setting: Setting! {
    didSet {
      setupSetting()
    }
  }
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
  }
  
  func configureKnobViews() {
   // print("configureKnobViews()")
    let sideLength = self.frame.size.height / 2.0
    let size = CGSize(width: sideLength, height: sideLength)
    
    let halfSideLength = sideLength / 2.0
    let halfWidth = self.frame.size.width / 2.0
    let knobViewPositions = [CGPoint(x: halfWidth - halfSideLength * 3.0, y: 0),
                             CGPoint(x: halfWidth - halfSideLength, y: sideLength),
                             CGPoint(x: halfWidth + halfSideLength, y: 0)]
    var index = 0
    for knobView in knobViews {
      knobView.set(frame: CGRect(origin: knobViewPositions[index], size: size))
     
      knobView.changeKnobLabelText(to: "Default")
      if index == 1 { knobView.moveKnobLabelAbove() }
      knobView.setValue(value: setting.knobs!.knobsList[index].value, animated: false)
      
      print("Saved value is: \(setting.knobs!.knobsList[index].value)")
      
      knobView.delegate = self
      knobView.changeFillColor(to: UIColor.clear)
      
      contentView.addSubview(knobView)
  
      index += 1
    }
  }
  
  func setupSetting() {
    if let _ = setting.knobs {
      populateKnobViews()
    } else {
      populateKnobs()
    }
    configureKnobViews()
  }
  
  func populateKnobViews() {
    while knobViews.count < setting.knobs!.count {
      knobViews.append(KnobView(frame: frame))
    }
  }
  
  func populateKnobs() {
    setting.knobs = Knobs()
  
    setting.knobs?.addKnob()
    setting.knobs?.addKnob()
    setting.knobs?.addKnob()
    
    populateKnobViews()
  }
}

extension SettingCell: KnobViewDelegate {
  func knobView(_ knobView: KnobView, saveKnobValue value: Float) {
    let index = knobViews.index(of: knobView)
    if let knob = setting.knobs?.knobsList[index!] {
      //knob.setValue(value, forKey: "value")
      knob.value = value
      print("knob value set")
    }
    //self.setting!.knobs?.knobsList[index!].setValue(value, forKey: "value")
    print("The knob value in coredata: \(setting.knobs?.knobsList[index!].value)")
    // fractional values causing value label to read as 1?
    
    coreDataStack.saveContextWithoutCheckingForChanges()
  }
}
