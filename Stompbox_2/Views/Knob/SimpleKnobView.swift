//
//  SimpleKnobView.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 4/9/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

class SimpleKnobView: UIControl, SimpleKnobRenderer, Tappable {
  
  // SimpleKnobRenderer
  var startAngle = -CGFloat(Double.pi * 11.0 / 8.0)
  var endAngle = CGFloat(Double.pi * 3.0 / 8.0)

  var lineWidth: CGFloat = 2.0
  var trackLayer = CAShapeLayer()
  var strokeColor = UIColor()
  
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
    createSublayers()
    configureRenderer()
  }
  
  func configureRenderer() {
    strokeColor = tintColor
  }
  
  func addGesture() {
    tapRecognizer.addTarget(self, action: #selector(handleTap))
    self.addGestureRecognizer(tapRecognizer)
  }
  
  @objc private func handleTap() {
    print("Tap Registered")
  }
  
  // not needed
  func removeGesture() {
    self.removeGestureRecognizer(tapRecognizer)
  }
  
  func createSublayers() {
    layer.addSublayer(trackLayer)
  }
  

}
