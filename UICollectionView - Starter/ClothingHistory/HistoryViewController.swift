//
//  HistoryViewController.swift
//  UICollectionView - Starter
//
//  Created by Alexandre Geubelle on 8/22/18.
//  Copyright © 2018 microIT Infrastructure, LLC. All rights reserved.
//

import Foundation
import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var historyTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // Indentifiers
    let cellIdentifier: String = "historyCell"
    
    // Data source
    let closet = Closet.sharedInstance
    var filteredCloset: [Date: [Clothing]] = [Date: [Clothing]]()
    
    var isSearching = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        historyTable.delegate = self
        historyTable.dataSource = self
        
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredCloset.count
        } else {
            return closet.getHistory().count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell: HistoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! HistoryTableViewCell
        
        let tempCloset: [Date: [Clothing]]!
        if isSearching {
            tempCloset = filteredCloset
        } else {
            tempCloset = closet.getHistory()
        }
        
        let date: Date = Array(tempCloset.keys).sorted(by: >)[indexPath.row]
        let clothes: [Clothing] = tempCloset[date]!
        
        // Set label to the date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        tableCell.dateLabel.text = formatter.string(from: date)
        
        // Set images to the clothing
        tableCell.imagesStackView.subviews.forEach({ $0.removeFromSuperview() }) //Remove previous.
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
    
    // MARK - Search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            view.endEditing(true)
            historyTable.reloadData()
        } else {
            isSearching = true
            filteredCloset = filterCloset(byClothingName: searchBar.text!)
            historyTable.reloadData()
        }
    }
    
    private func filterCloset(byClothingName searchName: String) -> [Date: [Clothing]] {
        var filteredReturn: [Date: [Clothing]] = [Date: [Clothing]]()
        for (date, clothingList) in closet.getHistory() {
            print(date)
            for clothingItem in clothingList {
                if clothingItem.name!.lowercased().contains(searchName.lowercased()) {
                    print("FILTER FOUND: " + String(describing: date))
                    print(clothingList)
                    filteredReturn[date] = clothingList
                    break
                }
            }
        }
        return filteredReturn
    }
}
