//
//  DoneBarButtonDelegate.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 4/22/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

extension ContainerViewController: DoneBarButtonDelegate {
  func enableDoneBarButton(_ controller: StompboxDetailViewController) {
    if let doneBarButton = navigationItem.rightBarButtonItem {
      doneBarButton.isEnabled = true
    }
  }
  
  func disableDoneBarButton(_ controller: StompboxDetailViewController) {
    if let doneBarButton = navigationItem.rightBarButtonItem {
      doneBarButton.isEnabled = false
    }
  }
  
  
}
