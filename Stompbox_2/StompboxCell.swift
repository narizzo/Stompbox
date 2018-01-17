//
//  StompboxCell.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 1/5/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

class StompboxCell: UITableViewCell {

  // MARK: - IBOutlets
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var typeLabel: UILabel!
  @IBOutlet weak var manufacturerLabel: UILabel!
  @IBOutlet weak var stompboxImageView: UIImageView!
  
  // MARK: - View Life Cycle
  override func prepareForReuse() {
    super.prepareForReuse()
    
    nameLabel.text = nil
    typeLabel.text = nil
    manufacturerLabel.text = nil
    stompboxImageView.image = nil
  }

}
