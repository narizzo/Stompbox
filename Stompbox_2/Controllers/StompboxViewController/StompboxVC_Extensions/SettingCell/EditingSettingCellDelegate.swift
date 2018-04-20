//
//  EditingSettingCellDelegate.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 4/15/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import Foundation

extension StompboxViewController: EditingSettingCellDelegate {
  
  func startedEditingSetting(_ complexSettingCell: ComplexSettingCell) {
    if let indexPath = tableView.indexPath(for: complexSettingCell) {
      if let stompboxCell = tableView.cellForRow(at: IndexPath(row: 0, section: indexPath.section)) as? StompboxCell {
        stompboxCell.deltaButton.hide()
        scroll(to: indexPath)
      }
    }
  }
  
  func stoppedEditingSetting(_ complexSettingCell: ComplexSettingCell) {
    if let indexPath = tableView.indexPath(for: complexSettingCell) {
      if let stompboxCell = tableView.cellForRow(at: IndexPath(row: 0, section: indexPath.section)) as? StompboxCell {
        stompboxCell.deltaButton.show()
        tableView.isScrollEnabled = true
      }
    }
  }
  
  private func scroll(to indexPath: IndexPath) {
    tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
    tableView.isScrollEnabled = false
  }
}
