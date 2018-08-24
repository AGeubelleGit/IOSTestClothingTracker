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
    
    // Identifiers
    let cellIdentifier: String = "cellItemID"
    let sectionTitleIdentifier: String = "SectionTitleView"
    
    // Data source
    let closet = Closet.sharedInstance
    
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
        
        collectionView.delegate = self      // 1)
        collectionView.dataSource = self    // 2)
        
        collectionView.allowsMultipleSelection = true   // 3)
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
        return closet.getCloset().count
    }
    
    /**
     "Asks your data source object [collectionViewDataSource] for the number of items in the
     specified section [we only have 1 section; it's 0]."
     */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return closet.getCloset()[getClosetDictionaryKeyByInt(index: section)]!.count
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
        
        let clothing: Clothing = getClothing(sectionNumber: indexPath.section, sectionIndex: indexPath.row)
        collectionViewCell.label.text = clothing.name
        collectionViewCell.image.image = UIImage(named: clothing.imageId!)
        
        return collectionViewCell
    }
    
    // Section Header view
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionTitleView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: sectionTitleIdentifier, for: indexPath) as! SectionTitleView
        let endTab: String = "        " // Used to extend bottom border
        sectionTitleView.sectionTitle = getClosetDictionaryKeyByInt(index: indexPath.section).rawValue + endTab
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
        print("Selected cell named: \(getClothing(sectionNumber: indexPath.section, sectionIndex: indexPath.row).name)")
    }
    
    // MARK: - Helper methods
    private func getClosetDictionaryKeyByInt(index: Int) -> Clothing.ClothingType {
        return Array(closet.getCloset().keys)[index]
    }
    
    private func getClothing(sectionNumber: Int, sectionIndex: Int) -> Clothing {
        return closet.getCloset()[getClosetDictionaryKeyByInt(index: sectionNumber)]![sectionIndex]
    }
    
    // MARK: - UIToolbar: user interaction
    @IBAction func addButtonTapped(_ sender: Any)
    {
//        var newCellValue: String = "NewImage"
//        collectionViewDataSource.append(newCellValue)
//        collectionView.reloadData()
    }
    
    /**
     When a user taps the "Remove" button, we: 1) remove the data items
     from the data source which correspond to the currently selected
     UICollectionViewCell's; and, 2) we delete the currently selected
     UICollectionViewCell's.
    */
    @IBAction func removeButtonTapped(_ sender: Any)
    {
        print(closet.getCloset())
        // Do something.
        
    } // end func removeButtonTapped
    
    /**
     Called when the "Confirm" button is tapped.
    */
    @IBAction func confirmButtonTapped(_ sender: Any)
    {
        // Do Something.
    }

} // end class ViewController

