//
//  DeltaButton.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 3/29/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

protocol DeltaButtonDelegate: class {
  func deltaButtonTapped(_ button: DeltaButton)
}

class DeltaButton: UIButton {
  
  var deltaLayer = DeltaShapeLayer()
  weak var delegate: DeltaButtonDelegate!
  
  func initializeButton() {
    self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    let sideLength: CGFloat = 44.0
    let size = CGSize(width: sideLength, height: sideLength)
    let origin = CGPoint(x: superview!.frame.width - sideLength, y: superview!.frame.height - sideLength)
    self.frame = CGRect(origin: origin, size: size)
    
    initializeLayer()
  }
  
  @objc func buttonTapped() {
    delegate.deltaButtonTapped(self)
    deltaLayer.animate()
  }
  
  public func setIsExpanded(to bool: Bool) {
    deltaLayer.syncWithStompboxExpansionState(bool)
  }
  
  private func initializeLayer() {
    print("initializeLayer()")
    self.layer.addSublayer(deltaLayer)
    deltaLayer.initialize()
  }
  
  func show() {
    self.isHidden = false
    deltaLayer.show()
  }
  
  func hide() {
    self.isHidden = true
    deltaLayer.hide()
  }
  
}
