//
//  ViewController.swift
//  UIViewController - Starter
//
//  Created by Andrew Jaffee on 1/14/17.
//  UPDATED: 1/20/2017
//
/*
 
 Copyright (c) 2017 Andrew L. Jaffee, microIT Infrastructure, LLC, and
 iosbrain.com.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 
*/

import UIKit

// Note that this class adopts the UICollectionViewDelegate 
// and UICollectionViewDataSource protocols.
class ClothingCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var showRecentlyWornSwitch: UISwitch!
    
    // Identifiers
    let cellIdentifier: String = "cellItemID"
    let sectionTitleIdentifier: String = "SectionTitleView"
    
    let segueToHistoryIdentifier: String = "FromClothingCollectionToHistory"
    
    // Data source
    var clothingDictionary: [ClothingType: [Clothing]] = [ClothingType: [Clothing]]()
    var filteredClothingDictionary: [ClothingType: [Clothing]] = [ClothingType: [Clothing]]()
    
    var filterTypes: [ClothingType: Bool] = [ClothingType: Bool]()
    var isFiltering = false
    
    // MARK: - UIViewController delegate
    
    /**         
     
     1) "...[This UIViewController instance] acts as the delegate of the collection view.
 
     The delegate must adopt the UICollectionViewDelegate protocol. The collection view 
     maintains a weak reference to the delegate object.
 
     The delegate object is responsible for managing selection behavior and interactions 
     with individual items. ...

     2) [This UIViewController instance] provides the data for the collection view.
 
     The data source must adopt the UICollectionViewDataSource protocol. The collection view maintains a weak reference to the data source object.
     
     3) Allows users to "select more than one item in the collection view."
     
    */
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.allowsMultipleSelection = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("View will appear")
        reloadClothingData()
        filterTypes.removeAll()
        isFiltering = false
        collectionView.reloadData()
    }
    
    private func reloadClothingData() {
        do {
            clothingDictionary = try ClothingService.getClothesDictionary()
        } catch {
            print("Error in getting clothes")
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UICollectionViewDataSource
    
    /**
     We only have one section is our UICollectionView, but you
     can have many.
     */
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        if isFiltering {
            return filteredClothingDictionary.count
        } else {
            return clothingDictionary.count
        }
    }
    
    /**
     "Asks your data source object [collectionViewDataSource] for the number of items in the
     specified section [we only have 1 section; it's 0]."
     */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if isFiltering {
            return filteredClothingDictionary[getClothingDictionaryKeyByInt(dictionary: filteredClothingDictionary, index: section)]!.count
        } else {
            return clothingDictionary[getClothingDictionaryKeyByInt(dictionary: clothingDictionary,index: section)]!.count
        }
    }
    
    /**
     This method is crucial to the proper rendering of a UICollectionViewCell based on its
     corresponding data source item.
     REMEMBER that this call ties your data source to your UICollectionViewCell's.
     */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let collectionViewCell:CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CollectionViewCell
        
        let backgroundView: UIView = UIView(frame: collectionViewCell.frame)
        backgroundView.backgroundColor = UIColor.yellow
        collectionViewCell.selectedBackgroundView = backgroundView
        
        let clothing: Clothing
        if isFiltering {
            clothing = getClothing(dictionary: filteredClothingDictionary, sectionNumber: indexPath.section, sectionIndex: indexPath.row)
        } else {
            clothing = getClothing(dictionary: clothingDictionary, sectionNumber: indexPath.section, sectionIndex: indexPath.row)
        }
        collectionViewCell.label.text = clothing.name
        do {
            collectionViewCell.image.image = try ImageUtils.getImage(imageName: clothing.imageId)
        } catch {
            print("Failed to get image with id: \(clothing.imageId) \(error)")
        }
        
        return collectionViewCell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionTitleView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: sectionTitleIdentifier, for: indexPath) as! SectionTitleView
        let endTab: String = "        " // Used to extend bottom border
        let sectionTitleType: ClothingType
        if isFiltering {
            sectionTitleType = getClothingDictionaryKeyByInt(dictionary: filteredClothingDictionary, index: indexPath.section)
        } else {
            sectionTitleType = getClothingDictionaryKeyByInt(dictionary: clothingDictionary, index: indexPath.section)
        }
        
        sectionTitleView.sectionTitle = sectionTitleType.rawValue + endTab
        sectionTitleView.sectionHideRecentSwitch.setOn(filterTypes[sectionTitleType] != nil && filterTypes[sectionTitleType]!, animated: false)
        sectionTitleView.sectionHideRecentSwitch.tag = indexPath.section
        sectionTitleView.sectionHideRecentSwitch.addTarget(self, action: #selector(sectionSwitchDidChange(_:)), for: .touchUpInside)
        sectionTitleView.setBottomBorder()
        return sectionTitleView
    }
    
    // MARK: - UICollectionViewDelegate
    
    /**
     Allows you to control whether a cell is added to the list of selected
     cells. So, if a user selected a cell, you can tell the collection view
     to "remember" that this cell was tapped/selected by the user (or not).
     */
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    /**
     Allows you to control whether a cell is removed from the list of selected
     cells. So, if a user selected a cell, you can tell the collection view
     to "forget" that this cell was tapped/selected by the user (or not).
     */
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    /**
     Allow the cell to be visually highlighted when selected/tapped (or not).
     */
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    /**
     Useful for confirming which cell was just selected/tapped.
     */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if isFiltering {
            print("Selected cell named: \(getClothing(dictionary: filteredClothingDictionary, sectionNumber: indexPath.section, sectionIndex: indexPath.row).name)")
        } else {
            print("Selected cell named: \(getClothing(dictionary: clothingDictionary, sectionNumber: indexPath.section, sectionIndex: indexPath.row).name)")
        }
    }
    
    // MARK: - Helper methods
    private func getClothingDictionaryKeyByInt(dictionary: [ClothingType: [Clothing]], index: Int) -> ClothingType {
        return Array(dictionary.keys)[index]
    }
    
    private func getClothing(dictionary: [ClothingType: [Clothing]], sectionNumber: Int, sectionIndex: Int) -> Clothing {
        return dictionary[getClothingDictionaryKeyByInt(dictionary: dictionary, index: sectionNumber)]![sectionIndex]
    }
    
    private func deselectAll() {
        // Deselect all
        if let selectedItemPaths = collectionView.indexPathsForSelectedItems {
            for selectedItem in selectedItemPaths {
                collectionView.deselectItem(at: selectedItem, animated: true)
            }
        }
    }
    
    // MARK: - UIToolbar: user interaction
    @IBAction func confirmButtonTapped(_ sender: Any)
    {
        if let selectedItemPaths = collectionView.indexPathsForSelectedItems
        {
            if selectedItemPaths.count == 0 {
                print("Nothing was selected")
                return
            }
            let currClothingDictionary: [ClothingType: [Clothing]]
            if isFiltering {
                currClothingDictionary = filteredClothingDictionary
            } else {
                currClothingDictionary = clothingDictionary
            }
            
            // Get list of clothing sql ids that are selected and deselect rows.
            var clothingIdsToAdd = [Int64]()
            for selectedItem in selectedItemPaths {
                let clothing: Clothing = getClothing(dictionary: currClothingDictionary, sectionNumber: selectedItem.section, sectionIndex: selectedItem.row)
                clothingIdsToAdd.append(clothing.id!)
            }
            do {
                if clothingIdsToAdd.count == selectedItemPaths.count {
                    try ClothingHistoryService.addClothingSetToHistory(date: Date(), clothingIds: clothingIdsToAdd)
                } else {
                    print("Error in finding some of the clothing objects.")
                    return
                }
            } catch {
                print("Error in adding clothing set to history.")
                return
            }
            deselectAll()
            performSegue(withIdentifier: segueToHistoryIdentifier, sender: self)
        } else { //selectedItemPaths = collectionView.indexPathsForSelectedItems
            print("No items were selected")
        }
    }
    
    /**
     Called when the "History" button is tapped.
    */
    @IBAction func toHistoryButtonTapped(_ sender: Any)
    {
        deselectAll()
        performSegue(withIdentifier: segueToHistoryIdentifier, sender: self)
    }
    
    @IBAction func sectionSwitchDidChange(_ sender: UISwitch) {
        print("Button function called")
        let filterType: ClothingType
        if isFiltering {
            filterType = getClothingDictionaryKeyByInt(dictionary: filteredClothingDictionary, index: sender.tag)
        } else {
            filterType = getClothingDictionaryKeyByInt(dictionary: clothingDictionary, index: sender.tag)
        }
        filterTypes[filterType] = sender.isOn
        filterClothing(notWornInNumDays: 14)
    }
    
    private func filterClothing(notWornInNumDays: Int) {
        var filterTypeStrings: [String] = [String]()
        for type: ClothingType in filterTypes.keys {
            if filterTypes[type]! {
                filterTypeStrings.append(type.rawValue)
            }
        }
        if filterTypeStrings.count > 0 {
            print("Filtering by \(filterTypeStrings)")
            isFiltering = true
            do {
                filteredClothingDictionary = try ClothingService.getNotRecentlyWornClothes(filterTypes: filterTypeStrings, allTypes: Array(clothingDictionary.keys), limit: notWornInNumDays)
            } catch {
                print("error with filtering clothing \(error)")
            }
        } else {
            print("Not filtering")
            isFiltering = false
        }
        // Wait for the animation of the switch to finish before feloading the data
        let timer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(self.reloadData), userInfo: nil, repeats: false)
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        if let selectedItemPaths = collectionView.indexPathsForSelectedItems
        {
            if selectedItemPaths.count == 0 {
                print("Nothing was selected")
                return
            }
            let currClothingDictionary: [ClothingType: [Clothing]]
            if isFiltering {
                currClothingDictionary = filteredClothingDictionary
            } else {
                currClothingDictionary = clothingDictionary
            }
            
            var clothing: Clothing
            for selectedItem in selectedItemPaths {
                do {
                    clothing = getClothing(dictionary: currClothingDictionary, sectionNumber: selectedItem.section, sectionIndex: selectedItem.row)
                    try ClothingService.deleteClothingRow(clothingObject: clothing)
                } catch {
                    print("Error in deleting \(clothing)")
                }
            }
            deselectAll()
            isFiltering = false
            filterTypes = [ClothingType: Bool]()
            reloadClothingData()
            collectionView.reloadData()
        } else { //selectedItemPaths = collectionView.indexPathsForSelectedItems
            print("No items were selected")
        }
        
        
    }
    
    @objc func reloadData() {
        collectionView.reloadData()
    }
    
    
} // end class ViewController

