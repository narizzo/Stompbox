//
//  TableView_DataSource.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 3/14/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

// MARK: - UITableViewDataSource
extension StompboxViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    guard let sections = fetchedResultsController.sections else {
      return 0
    }
    return sections.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // Are there any Stompboxes?
    guard fetchedResultsController.sections != nil else {
      return 0
    }
    
    // Are the Stompboxes expanded?
    guard fetchedResultsController.fetchedObjects?[section].isExpanded == true else {
      return 1
    }
    
    // Are there any Settings for the Stompbox?
    guard let numberOfRows = fetchedResultsController.fetchedObjects?[section].settings?.count else {
      return 1
    }
    return numberOfRows + 1
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row == 0 {
      return Constants.stompboxCellHeight
    } else {
      return Constants.settingCellHeight
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row == 0 {
      let stompboxCell = tableView.dequeueReusableCell(withIdentifier: Constants.stompboxCellReuseID, for: indexPath)
      configure(stompboxCell, for: indexPath)
      return stompboxCell
    } else {
      let settingCell = tableView.dequeueReusableCell(withIdentifier: Constants.complexSettingReuseID, for: indexPath)
      configure(settingCell, for: indexPath)
      return settingCell
    }
  }
  
}
