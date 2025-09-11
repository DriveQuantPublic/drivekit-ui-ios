// swiftlint:disable no_magic_numbers
//
//  DKImagePicker.swift
//  DriveKitCommonUI
//
//  Created by Meryl Barantal on 20/03/2020.
//  Copyright © 2020 DriveQuant. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

public class DKImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var picker = UIImagePickerController()
    var alert = UIAlertController(title: DKCommonLocalizable.updatePhotoTitle.text(), message: nil, preferredStyle: .actionSheet)
    var viewController: UIViewController?
    public var pickImageCallback: ((UIImage) -> Void)?
    public var selectedImageTag: String = NSUUID().uuidString
    
    public override init() {
        super.init()
    }
    
    public func pickImage(_ viewController: UIViewController, _ callback: @escaping ((UIImage) -> Void)) {
        pickImageCallback = callback
        self.viewController = viewController
        
        let cameraAction = UIAlertAction(title: DKCommonLocalizable.camera.text(), style: .default) { _ in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: DKCommonLocalizable.gallery.text(), style: .default) { _ in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: DKCommonLocalizable.cancel.text(), style: .cancel) { _ in
        }
        
        // Add the actions
        picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func openCamera() {
        alert.dismiss(animated: true, completion: nil)
        checkCameraPermission { [weak self] status in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                if status && UIImagePickerController .isSourceTypeAvailable(.camera) {
                    self.picker.sourceType = .camera
                    self.picker.allowsEditing = true
                    self.viewController?.present(self.picker, animated: true, completion: nil)
                } else {
                    let alertWarning = UIAlertController(title: nil, message: DKCommonLocalizable.cameraPermission.text(), preferredStyle: .alert)
                    alertWarning.addAction(UIAlertAction(title: DKCommonLocalizable.ok.text(), style: .default))
                    self.viewController?.present(alertWarning, animated: true)
                }
            }
        }
    }
    
    func openGallery() {
        alert.dismiss(animated: true, completion: nil)
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        self.viewController!.present(picker, animated: true, completion: nil)
    }

    func checkCameraPermission(completionHandler: @escaping (Bool) -> Void) {
        let currentStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch currentStatus {
        case .notDetermined, .restricted, .denied:
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
                if response {
                    completionHandler(true)
                } else {
                    completionHandler(false)
                }
            }
        case .authorized:
            completionHandler(true)
        @unknown default:
            completionHandler(false)
        }
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        let fileManager = FileManager.default
        
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let documentPath = documentsURL.path
        
        let filePath = documentsURL.appendingPathComponent("\(String(selectedImageTag)).jpeg")
        
        do {
            let files = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
            for file in files where "\(documentPath)/\(file)" == filePath.path {
                try fileManager.removeItem(atPath: filePath.path)
            }
        } catch {
            print("Could not add image from document directory: \(error)")
        }
        
        do {
            if let editedImage = info[.editedImage] as? UIImage {
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
