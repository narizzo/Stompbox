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
    if let indexPath = tableView.indexPath(for: stompboxCell) {
      addSetting(at: indexPath)
    }
  }
}
