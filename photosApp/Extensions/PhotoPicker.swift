//
//  PhotoPicker.swift
//  photosApp
//
//  Created by Юрий on 06.12.2022.
//

import UIKit

extension ProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func presentImagePicker() {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        if upload == .profilePic {
            profileView.profileImage.image = image
            UserService.shared.updateProfilePic(user: user, pic: image) { url in
                self.fetchPosts()
                self.notification.post(name: NSNotification.Name(rawValue: "FetchFeed"), object: nil)
            }
            dismiss(animated: true)
        } else {
            dismiss(animated: true) {
                self.presentNewPost(user: self.user, postImage: image)
            }
        }
    }
}
