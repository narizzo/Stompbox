//
//  SimpleKnobView.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 4/9/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

class SimpleKnobView: UIControl, Tappable {
  
  var simpleKnobLayer = SimpleKnobLayer()
  var tapRecognizer = UITapGestureRecognizer()
  
  // MARK: - Init & Setup
  public override init(frame: CGRect) {
    super.init(frame: frame)
    set(frame: frame)
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    set(frame: nil)
  }
  
  public func set(frame: CGRect?) {
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
    tapRecognizer.addTarget(self, action: #selector(handleTap))
    self.addGestureRecognizer(tapRecognizer)
  }
  
  @objc private func handleTap() {
    print("Tap Registered")
  }
  
  // not needed?
  func removeGesture() {
    self.removeGestureRecognizer(tapRecognizer)
  }
  
}
