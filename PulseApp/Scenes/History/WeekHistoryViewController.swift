//
//  WeekHistoryViewController.swift
//  PulseApp
//
//  Created by Константин Киски on 16.02.2021.
//

import Foundation

// MARK: - NewsViewController

class NewsCollectionCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Structure

    struct ItemNews {
        var image: String?
        var title: String
        var text: String
    }
    
    // MARK: - UI Elements

    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Closure
    
    var currentNew: (ItemNews) -> Void = { _ in }
    var controller: UIViewController!
    
    // MARK: - Variables
    
    var newsArray: [ItemNews]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - UITableViewDelegate, UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemNewsCell", for: indexPath) as! DefaultTableViewCell
        if let currentItem = newsArray?[indexPath.row] {
            cell.setDataWithAction(data: currentItem, controller: controller)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        currentNew(newsArray?[indexPath.row] ?? ItemNews(title: "Ошибка", text: "попробуйте позже"))
        return indexPath
    }
}
