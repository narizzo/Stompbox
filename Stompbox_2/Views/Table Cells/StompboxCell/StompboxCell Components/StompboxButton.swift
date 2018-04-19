//
//  StompboxButton.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 4/19/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

protocol StompboxButtonDelegate: class {
  func stompboxButtonTapped(_ button: StompboxButton)
}

class StompboxButton: UIButton {
  
  var delegate: StompboxButtonDelegate!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    customInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    customInit()
  }
  
  private func customInit() {
    imageView?.contentMode = .scaleAspectFit
    isUserInteractionEnabled = true // should be false with full implementation
    self.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
  }
  
  @objc private func handleTap() {
    print("handleTap")
    delegate.stompboxButtonTapped(self)
  }
}
