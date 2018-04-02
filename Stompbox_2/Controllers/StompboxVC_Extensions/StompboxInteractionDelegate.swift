//
//  StompboxCellGestureDelegate.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 3/20/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import Foundation

extension StompboxViewController: StompboxInteractionDelegate {
  func stompboxExpandCollapse(_ stompboxCell: StompboxCell) {
    collapseExpandSection(for: stompboxCell)
  }
  
  func stompboxGestureDoubleTap(_ stompboxCell: StompboxCell) {
    print("2: Delegate: stompboxGestureDoubleTap")
    if let indexPath = tableView.indexPath(for: stompboxCell) {
      print("3: indexPath for stompboxCell: \(indexPath)")
      addSetting(at: indexPath)
    }
  }
}
