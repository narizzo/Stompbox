//
//  KnobLayout_Delegate.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 5/17/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

extension StompboxViewController: KnobLayoutDelegate {
  func reloadCells(for stompbox: Stompbox) {
    if let indexPath = fetchedResultsController.indexPath(forObject: stompbox) {
      let indexSet = IndexSet(integer: indexPath.section)
      tableView.reloadSections(indexSet, with: .automatic)
    }
  }
  
}
