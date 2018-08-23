//
//  HistoryViewController.swift
//  UICollectionView - Starter
//
//  Created by Alexandre Geubelle on 8/22/18.
//  Copyright © 2018 microIT Infrastructure, LLC. All rights reserved.
//

import Foundation
import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var historyTable: UITableView!
    
    // Indentifiers
    let cellIdentifier: String = "historyCell"
    
    // Data source
    let closet = Closet.sharedInstance
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        historyTable.delegate = self
        historyTable.dataSource = self
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return closet.getHistoryNumRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell: HistoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! HistoryTableViewCell
        
        let date: Date = closet.getHistoryDictionaryKeyByInt(index: indexPath.row)
        let clothes: [Clothing] = closet.getHistoryByKey(key: date)
        
        // Set label to the date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        tableCell.dateLabel.text = formatter.string(from: date)
        
        // Set images to the clothing
        let aspectRatio: CGFloat = CGFloat(1.0)
        tableCell.imagesStackView.translatesAutoresizingMaskIntoConstraints = false
        // https://stackoverflow.com/questions/30728062/add-views-in-uistackview-programmatically
        for clothing in clothes {
            let imageView: UIImageView = UIImageView()
            imageView.image = UIImage(named: clothing.imageId!)
            imageView.heightAnchor.constraint(equalToConstant: tableCell.imagesStackView.frame.height).isActive = true
            imageView.widthAnchor.constraint(equalToConstant:
                tableCell.imagesStackView.frame.height * aspectRatio).isActive = true
            tableCell.imagesStackView.addArrangedSubview(imageView)
        }
        return tableCell
    }
}
