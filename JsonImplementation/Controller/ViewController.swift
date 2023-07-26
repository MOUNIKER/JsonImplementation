//
//  ViewController.swift
//  JsonImplementation
//
//  Created by Siva Mouniker  on 25/07/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var model: AlbumModel = AlbumModel()
    var expandedRows: Set<Int> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchAlbumsData()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
    }
    
    func fetchAlbumsData() {
        model.fetchAlbums { [weak self] error in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return model.userAlbums.keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let userId = model.sortedUserIds[section]
        return expandedRows.contains(userId) ? model.userAlbums[userId]!.count + 1 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let userId = model.sortedUserIds[indexPath.section]
        let userAlbumData = model.userAlbums[userId]!
        
        if indexPath.row == 0 {
            cell.textLabel?.text = "User ID: \(userId)"
        } else {
            let albumData = userAlbumData[indexPath.row - 1]
            cell.textLabel?.text = "ID: \(albumData.id)\nTitle: \(albumData.title)"
            cell.textLabel?.numberOfLines = 0
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userId = model.sortedUserIds[indexPath.section]
        if expandedRows.contains(userId) {
            expandedRows.remove(userId)
        } else {
            expandedRows.insert(userId)
        }
        tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 44 : 80
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
}
