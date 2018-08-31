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
    var clothingHistory: [ClothingHistory] = [ClothingHistory]()
    var filteredHistory: [ClothingHistory] = [ClothingHistory]()
    let limit: Int64 = 10
    
    var isSearching = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        historyTable.delegate = self
        historyTable.dataSource = self
        
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        
        reloadHistoryData()
    }
    
    private func reloadHistoryData() {
        do {
            clothingHistory = try ClothingHistoryService.getHistory(limit: limit)
            filteredHistory = [ClothingHistory]()
        } catch {
            print("Error in loading history data")
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredHistory.count
        } else {
            return clothingHistory.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell: HistoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! HistoryTableViewCell
        
        let tempCloset: [ClothingHistory]!
        if isSearching {
            tempCloset = filteredHistory
        } else {
            tempCloset = clothingHistory
        }
        
        let date: Date = tempCloset[indexPath.row].date
        let clothingImageIds: [String] = tempCloset[indexPath.row].clothingImageIds
        
        // Set label to the date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        tableCell.dateLabel.text = formatter.string(from: date)
        
        // Set images to the clothing
        tableCell.imagesStackView.subviews.forEach({ $0.removeFromSuperview() }) //Remove previous.
        let aspectRatio: CGFloat = CGFloat(1.0)
        tableCell.imagesStackView.translatesAutoresizingMaskIntoConstraints = false
        // https://stackoverflow.com/questions/30728062/add-views-in-uistackview-programmatically
        for imageId: String in clothingImageIds {
            let imageView: UIImageView = UIImageView()
            // TODO: delete me
//            imageView.image = UIImage(named: imageId)
            do {
                imageView.image = try ImageUtils.getImage(imageName: imageId)
            } catch {
                print("Failed to get image with id: \(imageId) \(error)")
            }
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
            filteredHistory = filterHistory(byClothingName: searchBar.text!)
            historyTable.reloadData()
        }
    }
    
    private func filterHistory(byClothingName searchName: String) -> [ClothingHistory] {
        var filteredReturn: [ClothingHistory] = [ClothingHistory]()
        for historyObject in clothingHistory {
            for name in historyObject.clothingNames {
                if name.lowercased().contains(searchName.lowercased()) {
                    filteredReturn.append(historyObject)
                    break
                }
            }
        }
        return filteredReturn
    }
}
