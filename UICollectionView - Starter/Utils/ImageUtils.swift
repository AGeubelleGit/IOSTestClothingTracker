//
//  ImageUtils.swift
//  UICollectionView - Starter
//
//  Created by Alexandre Geubelle on 8/29/18.
//  Copyright © 2018 microIT Infrastructure, LLC. All rights reserved.
//

import Foundation
import UIKit

class ImageUtils {
    /*
     Save images to documents. https://appsandbiscuits.com/take-save-and-retrieve-a-photo-ios-13-4312f96793ff
     takes an image and image name
    */
    static func saveImage(image: UIImage!, imageName: String!) -> Void {
        let newWidth: CGFloat = 250
        let resizedImage = resizeImage(image: image, newWidth: newWidth)
        
        //create an instance of the FileManager
        let fileManager = FileManager.default
        //get the image path
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        //get the PNG data for this image
        let data = UIImagePNGRepresentation(resizedImage!)
        //store it in the document directory
        fileManager.createFile(atPath: imagePath as String, contents: data, attributes: nil)
    }
    
    static func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    /*
     Gets image from documents by name https://appsandbiscuits.com/take-save-and-retrieve-a-photo-ios-13-4312f96793ff
     takes an image name and returns UIImage
    */
    static func getImage(imageName: String) throws -> UIImage {
        let fileManager = FileManager.default
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        if fileManager.fileExists(atPath: imagePath){
            return UIImage(contentsOfFile: imagePath)!
        }else{
            throw MyError.runtimeError("Image not found")
        }
    }
    
    /*
     Delete image from documents by name https://appsandbiscuits.com/take-save-and-retrieve-a-photo-ios-13-4312f96793ff
     */
    static func deleteImage(imageName: String) -> Void {
        let fileManager = FileManager.default
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        if fileManager.fileExists(atPath: imagePath){
            do {
                try fileManager.removeItem(atPath: imagePath)
                print("Image with ImageId \(imageName) was deleted")
            } catch {
                print("Error in removing image: \(error)")
            }
        } else {
            print("Image does not exist")
        }
    }
}
