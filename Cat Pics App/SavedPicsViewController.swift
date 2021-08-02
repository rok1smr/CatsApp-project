//
//  SavedPicsViewController.swift
//  Cat Pics App
//
//  Created by Konstantin on 28.07.2021.
//

import UIKit

// created a new vc for the screen with the saved/liked URLs

class SavedPicsViewController: UIViewController {
    
//    assigned a public property that will receive the saved URLs from the main vc
    public var savedItems:[URL] = []
    
//    attached the table view from storyboard to the code
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Saved Pictures"
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
}

// created the extensions that describe the class SavedPicsViewController
// the delegate addresses the number of instances in the array savedItems and accordingly creates cells
extension SavedPicsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedItems.count
    }
    
// the data source tels the table view what to present in the cell's text  label
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicURLCell", for: indexPath)
        let currentURL = savedItems[indexPath.row]
        cell.textLabel?.text = "\(currentURL)"
        return cell
    }
}
