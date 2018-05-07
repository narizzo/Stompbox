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
    super.viewWillAppear(animated)
    UIApplication.shared.statusBarStyle = .lightContent
    // stop unnecessary reload of table elements
    // make method that takes the stompbox that was modified and only reload that section?
    if tableNeedsReload {
      tableView.reloadData()
      tableNeedsReload = false
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    tableNeedsReload = true
  }
  
  override var preferredStatusBarStyle : UIStatusBarStyle {
    return .lightContent
  }
  
  // MARK: - ViewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.backgroundColor = AppColors.black
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
