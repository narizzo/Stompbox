//
//  TemplateKnobView.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 4/9/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

class TemplateKnobView: UIControl, KnobViewProtocol {
  
  var simpleKnobLayer = SimpleKnobLayer()
  // Template and Simple are the same thing - this is just for simplicity
  // Might remove TemplateKnobView/Layer altogether
  
  // MARK: - Init & Setup
  public override init(frame: CGRect) {
    super.init(frame: frame)
    initialize()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initialize()
  }
  
  private func initialize() {
    addViewsAndLayers()
  }
  
  // MARK: - Subviews
  func addViewsAndLayers() {
    self.layer.addSublayer(simpleKnobLayer)
    simpleKnobLayer.frame = self.bounds
  }
  
  func set(frame: CGRect?) {
    if let frame = frame {
      self.frame = frame
    }
  
    simpleKnobLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
    simpleKnobLayer.set(size: bounds.size)

  }
  
  // MARK: - Color
  func changeStrokeColor(to color: UIColor) {
    simpleKnobLayer.changeStrokeColor(to: color)
  }
  
}
