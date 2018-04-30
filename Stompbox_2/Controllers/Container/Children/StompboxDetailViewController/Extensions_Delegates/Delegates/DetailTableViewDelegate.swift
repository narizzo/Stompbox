//
//  TableViewDelegate.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 4/20/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

extension StompboxDetailViewController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
//  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//    if indexPath.row == 0 {
//      return Constants.stompboxCellHeight
//    } else {
//      return Constants.settingCellHeight
//    }
//  }
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return tableView.bounds.height / 2
  }
}
