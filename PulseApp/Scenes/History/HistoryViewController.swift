//
//  HistoryViewController.swift
//  PulseApp
//
//  Created by Viacheslav Tolstopiatenko on 5/01/21.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UI Elements
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var menuBar: MenuBar!

    // MARK: - Variables
    
    private var grahpsColor: UIColor = .gray
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detectClosure()
        setupViews()
    }
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = DefaultTableViewCell()
        switch indexPath.row {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "graphCell", for: indexPath) as! DefaultTableViewCell
            cell.backgroundColor = grahpsColor
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "oneCell", for: indexPath) as! OneRateTableViewCell
            (cell as! OneRateTableViewCell).setData(date: Date(), pulse: 25*indexPath.row, icon: UIImage(named: "tired") ?? UIImage())
        }
        return cell
    }
    
    // MARK: - Private functions
    
    private func setupViews() {
        self.view.backgroundColor = PulseColor.background
        self.title = PulseTabsName.history
    }
    
    private func detectClosure() {
        menuBar.todayAction = {
            self.grahpsColor = .black
            self.tableView.reloadData()
        }
        menuBar.eventsAction = {
            self.grahpsColor = .green
            self.tableView.reloadData()
        }
        menuBar.newsAction = {
            self.grahpsColor = .red
            self.tableView.reloadData()
        }
    }
}

