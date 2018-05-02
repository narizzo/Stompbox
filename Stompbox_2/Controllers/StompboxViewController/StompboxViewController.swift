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
  
  weak var coreDataStack: CoreDataStack!
  var selectedStompbox: Stompbox?
  
  /* StompboxButtonDelegate vars  */
  // make separate object for this?
  var imagePicker = UIImagePickerController()
  var didPickNewThumbnail = false
  var imageData = Data()
  var selectedStompboxButton: StompboxButton?
  
  var tableNeedsReload = false

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
  
  
  override func viewWillAppear(_ animated: Bool) {
    UIApplication.shared.statusBarStyle = .lightContent
    
    // stop unnecessary reload of table elements
    if tableNeedsReload {
      tableView.reloadData()
      tableNeedsReload = false
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    tableNeedsReload = true
  }
  
  override var preferredStatusBarStyle : UIStatusBarStyle {
    return .lightContent
  }
  
  // MARK: - ViewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.backgroundColor = black
    do {
      try fetchedResultsController.performFetch()
    } catch let error as NSError {
      print("Fetching error: \(error), \(error.userInfo)")
    }
    
    let stompboxNib = UINib(nibName: Constants.stompboxNib, bundle: nil)
    tableView.register(stompboxNib, forCellReuseIdentifier: Constants.stompboxCellReuseID)
    
    let settingNib = UINib(nibName: Constants.settingCellComplexNib, bundle: nil)
    tableView.register(settingNib, forCellReuseIdentifier: Constants.complexSettingReuseID)
  }
  
  @IBAction func addStompbox(_ sender: AnyObject) {
    selectedStompbox = nil
    performSegue(withIdentifier: Constants.stompboxDetailSegue, sender: nil)
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
  
  /* Configure helper method */
  private func configureStompboxCell(_ cell: StompboxCell, for indexPath: IndexPath) {
    let stompbox = fetchedResultsController.object(at: indexPath)
    cell.nameTextField.text = stompbox.name
    cell.typeTextField.text = stompbox.type
    cell.manufacturerTextField.text = stompbox.manufacturer
    
    // load image
    var image: UIImage?
    if let imageFilePath = stompbox.imageFilePath {
      if let data = try? Data(contentsOf: imageFilePath) {
        image = UIImage(data: data)
      }
    }
    if let image = image {
      cell.stompboxButton.setImage(image, for: .normal)
    } else {
      cell.stompboxButton.setImage(#imageLiteral(resourceName: "BD2-large"), for: .normal)
    }
    
    cell.delegate = self
    cell.stompboxButton.delegate = self
    cell.backgroundColor = darkerGray
    
    // Configure delta button
    if stompbox.settings == nil || stompbox.settings!.count < 1 {
      cell.hideDeltaButton()
    } else {
      cell.showDeltaButton()
      // prevents didSet in the cell from firing when not necessary
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
    
    // StompboxViewController is the delegate for ComplexSettingCell because StompboxCell is not guaranteed to exist when editing occurs
    if cell.delegate == nil {
      cell.delegate = self
    }
    
    if cell.setting == nil {
      cell.setting = stompbox.settings?[indexPath.row - 1] as? Setting
    }
    
    indexPath.row % 2 == 0 ? cell.changeBackgroundColor(to: darkerGray) : cell.changeBackgroundColor(to: lighterGray)
    
    // load knob configuration
    cell.knobLayoutStyle = Int(stompbox.knobLayoutStyle)
    print("cell.layout: \(cell.knobLayoutStyle)")
    
    // load knob names
    if let settings = stompbox.settings {
      if let setting = settings.firstObject as? Setting {
        if let knobs = setting.knobs {
          var i = 0
          for knob in knobs {
            if let aKnob = knob as? Knob {
              if i < cell.knobViews.count {
                cell.knobViews[i].knobNameLabel.text = aKnob.name
              }
            }
            i += 1
          }
        }
      }
    }
    
  }
  
  func shadeSettingCells() {
    print("shadeSettingCells()")
    let sections = tableView.numberOfSections
    for section in 0..<sections {
      let rows = tableView.numberOfRows(inSection: section)
      for row in 0..<rows {
        if let cell = tableView.cellForRow(at: IndexPath(row: row, section: section)) as? ComplexSettingCell {
          print("coloring cell")
          row % 2 == 0 ? cell.changeBackgroundColor(to: darkerGray) : cell.changeBackgroundColor(to: lighterGray)
        }
      }
    }
  }
  
  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == Constants.stompboxDetailSegue {
      if let destination = segue.destination as? ContainerViewController {
        // set dependencies
        destination.stompboxToEdit = self.selectedStompbox
        destination.coreDataStack = self.coreDataStack
        // set delegates
        destination.containerViewControllerDelegate = self
        destination.stompboxButtonDelegate = self
      }
    }
  }
  
  public func showStompboxDetailView() {
    performSegue(withIdentifier: Constants.stompboxDetailSegue, sender: nil)
  }
}
