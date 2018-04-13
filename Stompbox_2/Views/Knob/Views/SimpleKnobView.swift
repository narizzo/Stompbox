//
//  SimpleKnobView.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 4/9/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

class SimpleKnobView: UIControl, Gestureable, KnobViewProtocol {

  var gestureRecognizer: UIGestureRecognizer = UITapGestureRecognizer()
  var simpleKnobLayer = SimpleKnobLayer()
  
  // MARK: - Init & Setup
  public override init(frame: CGRect) {
    super.init(frame: frame)
    set(frame: frame)
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    set(frame: nil)
  }
  
  func set(frame: CGRect?) {
    if let frame = frame {
      self.frame = frame
    }
    
    addSubviews()
    addGesture()
  }
  
  func addSubviews() {
    self.layer.addSublayer(simpleKnobLayer)
    simpleKnobLayer.frame = self.bounds
  }
  
  func addGesture() {
    gestureRecognizer.addTarget(self, action: #selector(handleGesture))
    self.addGestureRecognizer(gestureRecognizer)
  }
  
  @objc private func handleGesture() {
    print("Tap Registered")
  }
  
  // not needed?
  func removeGesture() {
    self.removeGestureRecognizer(gestureRecognizer)
  }
  
  // MARK: - Color
  func changeStrokeColor(to color: UIColor) {
    simpleKnobLayer.changeStrokeColor(to: color)
  }
  
}
