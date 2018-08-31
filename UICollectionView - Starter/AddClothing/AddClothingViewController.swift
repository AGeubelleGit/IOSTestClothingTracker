//
//  AddClothingViewController.swift
//  UICollectionView - Starter
//
//  Created by Alexandre Geubelle on 8/29/18.
//  Copyright © 2018 microIT Infrastructure, LLC. All rights reserved.
//

import Foundation
import UIKit

class AddClothingViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate,
    UITextFieldDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var clothingTypePicker: UIPickerView!
    @IBOutlet weak var confirmButton: UIButton!
    
    var imagePickerController : UIImagePickerController!
    
    var pickerDataSource: [ClothingType] = [ClothingType]()
    
    var currImage: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerDataSource = ClothingType.getAll()
        clothingTypePicker.dataSource = self
        clothingTypePicker.delegate = self
        
        nameInput.delegate = self
        
        confirmButton.isEnabled = false
        currImage = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK picker view functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row].rawValue
    }
    
    // Taking Image functions
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePickerController.dismiss(animated: true, completion: nil)
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        currImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        confirmButton.isEnabled = true
    }
    
    @IBAction func onTakeRetakeButtonPressed(_ sender: Any) {
        imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // Make keyboard go away on confirm
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // On confirm
    @IBAction func onConfirmButtonPressed(_ sender: Any) {
        let name: String
        if nameInput.text == nil {
            name = ""
        } else {
            name = nameInput.text!
        }
        let type: ClothingType = pickerDataSource[clothingTypePicker.selectedRow(inComponent: 0)]
        if currImage != nil {
            do {
                try ClothingService.addClothingRow(clothingType: type, name: name, image: currImage!)
            } catch {
                print("Error in adding row")
            }
        } else {
            print("Need to take an image.")
        }
    }
}
