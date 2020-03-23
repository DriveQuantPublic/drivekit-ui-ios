//
//  DKImagePicker.swift
//  DriveKitCommonUI
//
//  Created by Meryl Barantal on 20/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import UIKit

public class DKImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var picker = UIImagePickerController();
    var alert = UIAlertController(title: DKCommonLocalizable.updatePhotoTitle.text(), message: nil, preferredStyle: .actionSheet)
    var viewController: UIViewController?
    public var pickImageCallback : ((UIImage) -> ())?;
    public var selectedImageTag: String = NSUUID().uuidString
    
    public override init(){
        super.init()
    }
    
    public func pickImage(_ viewController: UIViewController, _ callback: @escaping ((UIImage) -> ())) {
        pickImageCallback = callback;
        self.viewController = viewController;
        
        let cameraAction = UIAlertAction(title: DKCommonLocalizable.camera.text(), style: .default){
            UIAlertAction in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: DKCommonLocalizable.gallery.text(), style: .default){
            UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: DKCommonLocalizable.cancel.text(), style: .cancel){
            UIAlertAction in
        }
        
        // Add the actions
        picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        alert.popoverPresentationController?.sourceView = self.viewController!.view
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func openCamera(){
        alert.dismiss(animated: true, completion: nil)
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            picker.allowsEditing = true
            self.viewController!.present(picker, animated: true, completion: nil)
        } else {
            let alertWarning = UIAlertController(title: nil, message: DKCommonLocalizable.cameraPermission.text(), preferredStyle: .alert)
            alertWarning.addAction(UIAlertAction(title: "OK", style: .default))
            self.viewController!.present(alertWarning, animated: true)
        }
    }
    
    func openGallery(){
        alert.dismiss(animated: true, completion: nil)
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        self.viewController!.present(picker, animated: true, completion: nil)
    }
    
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        let fileManager = FileManager.default
        
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let documentPath = documentsURL.path
        
        let filePath = documentsURL.appendingPathComponent("\(String(selectedImageTag)).jpeg")
        
        do {
            let files = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
            for file in files {
                if "\(documentPath)/\(file)" == filePath.path {
                    try fileManager.removeItem(atPath: filePath.path)
                }
            }
        } catch {
            print("Could not add image from document directory: \(error)")
        }
        
        do {
            if let editedImage = info[.editedImage] as? UIImage  {
                if let jpegImageData = editedImage.jpegData(compressionQuality: 0.8) {
                    try jpegImageData.write(to: filePath, options: .atomic)
                }
            } else {
                if let jpegImageData = image.jpegData(compressionQuality: 0.8) {
                    try jpegImageData.write(to: filePath, options: .atomic)
                }
            }
        } catch {
            print("Could not write image")
        }
        
        picker.dismiss(animated: true, completion: nil)
        
        pickImageCallback?(image)
    }
    
    
    
    @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {
    }
    
}
