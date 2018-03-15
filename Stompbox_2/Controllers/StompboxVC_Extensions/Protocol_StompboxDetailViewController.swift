//
//  Protocol_StompboxDetailViewController.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 3/14/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import Foundation

// MARK: - StompboxDetailViewController Protocol
extension StompboxViewController: StompboxDetailViewControllerDelegate {
  func stompboxDetailViewControllerDidCancel(_ controller: StompboxDetailViewController) {
    navigationController?.popViewController(animated: true)
  }
  
  func stompboxDetailViewController(_ controller: StompboxDetailViewController, didFinishAdding stompbox: Stompbox) {
    coreDataStack.saveContext()
    navigationController?.popViewController(animated: true)
  }
  
  func stompboxDetailViewController(_ controller: StompboxDetailViewController, didFinishEditing stompbox: Stompbox) {
    selectedStompbox = stompbox
    coreDataStack.saveContext()
    navigationController?.popViewController(animated: true)
  }
}
