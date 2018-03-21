//
//  StompboxCellGestureDelegate.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 3/20/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import Foundation

extension StompboxViewController: StompboxGestureDelegate {
  func StompboxGestureSingleTap(_ stompboxCell: StompboxCell) {
    collapseExpandSection(for: stompboxCell)
  }
  
  func StompboxGestureDoubleTap(_ stompboxCell: StompboxCell) {
    addSetting(for: stompboxCell)
  }
}
