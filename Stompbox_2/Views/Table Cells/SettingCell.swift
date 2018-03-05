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
  var coreDataStack: CoreDataStack!
  var setting: Setting! {
    didSet {
      print("setting set")
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
    print("initialize setting cell")
  }
  
  // gets called if the cell is ONLY designed in storyboard
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    print("initialize setting cell")
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
      knobView.setValue(value: setting.knobs!.knobsList[index].continuousValue, animated: false)
      
      knobView.delegate = self
      knobView.changeFillColor(to: UIColor.clear)
      knobView.changeStrokeColor(to: UIColor.black)
      contentView.addSubview(knobView)
  
      index += 1
    }
  }
  
  func setupSetting() {
    //print("setupSetting()")
    if let _ = setting.knobs {
      //print("*calling populateKnobViews()")
      populateKnobViews()
    } else {
      //print("**calling populateKnobs()")
      populateKnobs()
    }
    configureKnobViews()
  }
  
  func populateKnobViews() {
    //print("populateKnobViews()")
    while knobViews.count < setting.knobs!.count {
      knobViews.append(KnobView(frame: frame))
    }
  }
  
  func populateKnobs() {
    //print("populateKnobs()")
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
    
    setting.knobs?.knobsList[index!].continuousValue = value
    coreDataStack.saveContext()
  }
}
