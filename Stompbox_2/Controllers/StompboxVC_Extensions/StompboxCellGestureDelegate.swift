//
//  StompboxCellGestureDelegate.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 3/20/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import Foundation

extension StompboxViewController: StompboxGestureDelegate {
  // BUG: Does not edit exisiting -> goes to add Stompbox
  func StompboxGestureSingleTap(_ stompboxCell: StompboxCell) {
    editStompbox(for: stompboxCell)
  }
  
  func StompboxGestureDoubleTap(_ stompboxCell: StompboxCell) {
    
  }
}
