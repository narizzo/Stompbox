//
//  ContainerViewControllerDelegate.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 4/21/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

extension StompboxViewController: ContainerViewControllerDelegate {
  /*
   The coreDataStack reset is called here, while saveContext() is called in StompboxDetailViewController because
   that controller has to construct a Stompbox in the event that the underlying entity doesn't exist.
   StompboxViewController does not know about the StompboxCell, therefore, saving/constructing can't be done in it.
  */
  
  func didCancelChanges(_ controller: ContainerViewController) {
    coreDataStack.moc.reset()
    navigationController?.popViewController(animated: true)
  }
  
  func didAcceptChanges(_ controller: ContainerViewController) {
    coreDataStack.saveContext()
    navigationController?.popViewController(animated: true)
  }
}
