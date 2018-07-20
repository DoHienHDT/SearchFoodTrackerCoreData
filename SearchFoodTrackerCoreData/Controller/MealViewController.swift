//
//  ViewController.swift
//  Foodtracker
//
//  Created by dohien on 6/7/18.
//  Copyright © 2018 hiền hihi. All rights reserved.
//

import UIKit
import CoreData
class MealViewController: UIViewController , UITextFieldDelegate ,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    var object: PlistMeal?
    @IBOutlet weak var ratingControl: RatingControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        if let dataObject = object {
            nameTextField.text = dataObject.name
            ratingControl.rating = Int(dataObject.rating)
            photoImageView.image = dataObject.photo as? UIImage
        }
        updateSaveButtonSate()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func saveData(_ sender: UIBarButtonItem) {
        if object == nil {
            object = PlistMeal(context: DataService.shared.fetchedResultsController.managedObjectContext)
        }
        object?.name = nameTextField.text
        object?.rating = Int32(ratingControl.rating)
        object?.photo = photoImageView.image
        DataService.shared.saveData()
        navigationController?.popViewController(animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonSate()
        // đặt tiêu đề
        navigationItem.title = textField.text
    }
    func  textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true , completion:  nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        photoImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        super.prepare(for: segue, sender: sender)
    //        // cấu hình bộ điều khiển chế độ xem đích khi nhấn nút lưu
    //        guard let button = sender as? UIBarButtonItem, button === saveButton else {
    //            os_log("The save button was not pressed, cancelling", log: OSLog.default,type: .debug)
    //            return
    //        }
    //        let name = nameTextField.text ?? ""
    //        let photo = photoImageView.image
    //        let rating = ratingControl.rating
    //
    //        meal = Meal(name: name, photo: photo, rating: rating)
    //    }
    private func updateSaveButtonSate(){
        //  tắt nút lưu nếu trường văn bản trống
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
}

