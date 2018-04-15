//
//  StompboxViewController.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 1/5/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit
import CoreData

class StompboxViewController: UIViewController {
  
  // MARK: - Properties
  struct Constants {
    static let addStompboxSegue = "AddStompboxSegue"
    static let stompboxCache = "stompboxCache"
    
    static let stompboxCellHeight: CGFloat = 200
    static let settingCellHeight: CGFloat = 200
    static let stompboxCellReuseID = "stompboxCellReuseID"
    static let complexSettingReuseID = "complexSettingReuseID"
  }

  weak var coreDataStack: CoreDataStack!
  var selectedStompbox: Stompbox?
  
  lazy var fetchedResultsController: NSFetchedResultsController<Stompbox> = {
    let fetchRequest: NSFetchRequest<Stompbox> = Stompbox.fetchRequest()
    let nameSort = NSSortDescriptor(key: #keyPath(Stompbox.name), ascending: true)
    let typeSort = NSSortDescriptor(key: #keyPath(Stompbox.type), ascending: true)
    let manufacturerSort = NSSortDescriptor(key: #keyPath(Stompbox.manufacturer), ascending: true)
    fetchRequest.sortDescriptors = [nameSort, typeSort, manufacturerSort]
    
    let fetchedResultsController = NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: coreDataStack.moc,
      sectionNameKeyPath: #keyPath(Stompbox.name),
      cacheName: Constants.stompboxCache)
    
    fetchedResultsController.delegate = self
    
    return fetchedResultsController
  }()
  
  // MARK: - IBOutlets
  @IBOutlet weak var tableView: UITableView!
  
  
  // MARK: - ViewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.backgroundColor = black
    do {
      try fetchedResultsController.performFetch()
    } catch let error as NSError {
      print("Fetching error: \(error), \(error.userInfo)")
    }
    
    let stompboxNib = UINib(nibName: "StompboxCell", bundle: nil)
    tableView.register(stompboxNib, forCellReuseIdentifier: Constants.stompboxCellReuseID)
    
    let settingNib = UINib(nibName: "ComplexSettingCell", bundle: nil)
    tableView.register(settingNib, forCellReuseIdentifier: Constants.complexSettingReuseID)
  }
  
  @IBAction func addStompbox(_ sender: AnyObject) {
    selectedStompbox = nil
    performSegue(withIdentifier: Constants.addStompboxSegue, sender: nil)
  }
  
  // MARK: - Methods
  func configure(_ cell: UITableViewCell, for indexPath: IndexPath) {
    if let cell = cell as? StompboxCell {
      configureStompboxCell(cell, for: indexPath)
    }
    if let cell = cell as? ComplexSettingCell {
      configureSettingCell(cell, for: indexPath)
    }
  }
  
  // Configure helper method
  private func configureStompboxCell(_ cell: StompboxCell, for indexPath: IndexPath) {
    let stompbox = fetchedResultsController.object(at: indexPath)
    cell.nameLabel.text = stompbox.name
    cell.typeLabel.text = stompbox.type
    cell.manufacturerLabel.text = stompbox.manufacturer
    
    // refactor to helper function?
    var image: UIImage?
    if let imageFilePath = stompbox.imageFilePath {
      image = UIImage(contentsOfFile: imageFilePath.path)
    }
    if image != nil {
      cell.stompboxImageView.image = image
    } else {
      cell.stompboxImageView.image = #imageLiteral(resourceName: "BD2-large")
    }
    
    cell.delegate = self
    cell.backgroundColor = darkerGray
    
    // Configure delta button
    if stompbox.settings == nil || stompbox.settings!.count < 1 {
      cell.hideDeltaButton()
    } else {
      cell.showDeltaButton()
      // prevents didSet from firing when not necessary - this should be made simpler
      if cell.isExpanded != stompbox.isExpanded {
        cell.isExpanded = stompbox.isExpanded
      }
    }
  }
  
  // Configure helper method
  private func configureSettingCell(_ cell: ComplexSettingCell, for indexPath: IndexPath) {
    let stompbox = fetchedResultsController.object(at: IndexPath(row: 0, section: indexPath.section))
    if cell.coreDataStack == nil {
      cell.coreDataStack = coreDataStack
    }
    if cell.stompboxVCView == nil {
      cell.stompboxVCView = self.view
    }
    if cell.viewController == nil {
      cell.viewController = self
    }
    if cell.delegate == nil {
      if let stompboxCell = tableView.cellForRow(at: IndexPath(row: 0, section: indexPath.section)) as? StompboxCell {
        cell.delegate = stompboxCell
      }
    }
    cell.setting = stompbox.settings?[indexPath.row - 1] as? Setting
    
    // Color Cell
    indexPath.row % 2 == 0 ? cell.changeBackgroundColor(to: darkerGray) : cell.changeBackgroundColor(to: lightGray)
  }
  
  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == Constants.addStompboxSegue {
      let controller = segue.destination as! StompboxDetailViewController
      controller.delegate = self
      controller.coreDataStack = self.coreDataStack
      if let selectedStompbox = selectedStompbox {
        controller.stompboxToEdit = selectedStompbox
      }
    }
  }
  
  public func showStompboxDetailView() {
    performSegue(withIdentifier: Constants.addStompboxSegue, sender: nil)
  }
}
