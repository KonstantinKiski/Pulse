//
//  DayHistoryViewController.swift
//  PulseApp
//
//  Created by Константин Киски on 16.02.2021.
//

import Foundation

// MARK: - InfoViewController

class DayHistoryViewController: UICollectionViewCell {
    
    // MARK: - Structure
    
    struct ItemNews {
        var imgUrl: String?
        var title: String
        var text: String
    }
    
    // MARK: - UI Elements

    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Variables
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension DayHistoryViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = DefaultTableViewCell()
        switch indexPath.row {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "graphCell", for: indexPath) as! DefaultTableViewCell
            cell.backgroundColor = .green
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "oneCell", for: indexPath) as! OneRateTableViewCell
            (cell as! OneRateTableViewCell).setData(date: Date(), pulse: 25*indexPath.row, icon: UIImage(named: "tired") ?? UIImage())
        }
        return cell
    }
    
}
