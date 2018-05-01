//
//  ContainerViewControllerDelegate.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 4/21/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

extension StompboxViewController: ContainerViewControllerDelegate {
  
  func didCancelChanges(_ controller: ContainerViewController) {
    coreDataStack.moc.reset()
    navigationController?.popViewController(animated: true)
  }
  
  func didAcceptChanges(_ controller: ContainerViewController) {
    coreDataStack.saveContext()
    navigationController?.popViewController(animated: true)
  }
}
