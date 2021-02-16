//
//  HistoryViewController.swift
//  PulseApp
//
//  Created by Viacheslav Tolstopiatenko on 5/01/21.
//

import UIKit

class HistoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UI Elements
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var menuBar: MenuBar!

    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detectClosure()
        setupViews()
    }
    
    // MARK: - UI Actions

    
    // MARK: - UICollectionViewDelegate, UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        switch indexPath.row {
        case 0:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "infoCell", for: indexPath) as! InfoCollectionCell
        case 1:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath) as! CalendarCollectionCell
        case 2:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newsCell", for: indexPath) as! NewsCollectionCell
            (cell as! NewsCollectionCell).controller = self
            (cell as! NewsCollectionCell).newsArray = [NewsCollectionCell.ItemNews(title: "🔥 Новые реквизиты", text: "В сентябре этого года редакция снова опубликовала карикатуры, чтобы отметить начало суда над подозреваемыми. После этого они начали получать угрозы"), NewsCollectionCell.ItemNews(title: "Нападение", text: "Напомним, в 2015 году на редакцию газеты напали из-за карикатур с изображением пророка Мухаммеда, тогда погибли 12 человек.")]
        default:
            break
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath = collectionView.indexPathForItem(at: visiblePoint)
        switch visibleIndexPath?.row {
        case 0:
            menuBar.setTodayButtonActive()
        case 1:
            menuBar.setEventsButtonActive()
        case 2:
            menuBar.setNewsButtonActive()
        default:
            break
        }
    }
    
    // MARK: - Private functions
    
    private func setupViews() {
        self.view.backgroundColor = PulseColor.background
        self.title = PulseTabsName.history
        
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
    }
    
    private func detectClosure() {
        menuBar.todayAction = {
            self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: true)
        }
        menuBar.eventsAction = {
            self.collectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .centeredHorizontally, animated: true)
            self.collectionView.reloadData()
        }
        menuBar.newsAction = {
            let newPage = IndexPath(row: 2, section: 0)
            DispatchQueue.main.async {
                self.collectionView.scrollToItem(at: newPage, at: .centeredHorizontally, animated: true)
            }
        }
    }
}

