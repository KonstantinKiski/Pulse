//
//  DayHistoryViewController.swift
//  PulseApp
//
//  Created by Константин Киски on 16.02.2021.
//

import Foundation

// MARK: - InfoViewController

class InfoCollectionCell: UICollectionViewCell {
    
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

extension InfoCollectionCell: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = DefaultTableViewCell()
        cell = tableView.dequeueReusableCell(withIdentifier: "oneCell", for: indexPath) as! OneRateTableViewCell
        (cell as! OneRateTableViewCell).setData(date: Date(), pulse: (25*(indexPath.row+1)), icon: UIImage(named: "tired") ?? UIImage())
//        switch indexPath.row {
//        case 1:
//            cell = tableView.dequeueReusableCell(withIdentifier: "monthsCell", for: indexPath) as! DefaultTableViewCell
//        case 2:
//            cell = tableView.dequeueReusableCell(withIdentifier: "paymentCell", for: indexPath) as! DefaultTableViewCell
//            cell.setBorderColor(color: UIColor(red: 0.93, green: 0.36, blue: 0.32, alpha: 1.00))
//        case 3:
//            cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! DefaultTableViewCell
//            cell.setBorderColor(color: UIColor(red: 0.00, green: 0.48, blue: 1.00, alpha: 1.00))
//        case 4:
//            cell = tableView.dequeueReusableCell(withIdentifier: "managerCell", for: indexPath) as! DefaultTableViewCell
//        default:
//            cell = tableView.dequeueReusableCell(withIdentifier: "oneCell", for: indexPath) as! OneRateTableViewCell
//            (cell as! OneRateTableViewCell).setData(date: Date(), pulse: 20*indexPath.row, icon: UIImage(named: "tired") ?? UIImage())
//        }
        return cell
    }
}
