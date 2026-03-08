//
//  CreatePostViewController.swift
//  BeRealClone
//
//  Created by David Castaneda on 3/3/26.
//

import UIKit
import PhotosUI
import ParseSwift

class CreatePostViewController: UIViewController {

    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var captionTextField: UITextField!

    private var pickedImage: UIImage?

    @IBAction func onPickImageTapped(_ sender: UIBarButtonItem) {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }

    @IBAction func onShareTapped(_ sender: UIBarButtonItem) {
        guard
            let image = pickedImage,
            let imageData = image.jpegData(compressionQuality: 0.1)
        else {
            showAlert(description: "Pick an image first.")
            return
        }

        let file = ParseFile(name: "image.jpg", data: imageData)

        var post = Post()
        post.caption = captionTextField.text
        post.user = User.current
        post.imageFile = file

        post.save { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    self?.showAlert(description: error.localizedDescription)
                }
            }
        }
    }
}

extension CreatePostViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        guard let provider = results.first?.itemProvider,
              provider.canLoadObject(ofClass: UIImage.self)
        else { return }

        provider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
            if let error = error {
                self?.showAlert(description: error.localizedDescription)
                return
            }
            guard let image = object as? UIImage else {
                self?.showAlert(description: "Could not load image.")
                return
            }

            DispatchQueue.main.async {
                self?.previewImageView.image = image
                self?.pickedImage = image
            }
        }
    }
}
