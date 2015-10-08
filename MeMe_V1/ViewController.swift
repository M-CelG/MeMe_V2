//
//  ViewController.swift
//  MeMe_V1
//
//  Created by Manish Sharma on 9/8/15.
//  Copyright (c) 2015 CelG Mobile LLC. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    //Dictionary for NSAttributedString to setup attributes of Text Fields
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBold", size: 40)!,
        NSStrokeWidthAttributeName : -3.0
        ]
    
    //Setting the Text Field Attributes prior to view appearing
    override func viewDidAppear(animated: Bool) {
        bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.textAlignment = NSTextAlignment.Center
        topTextField.textAlignment = NSTextAlignment.Center
        topTextField.attributedPlaceholder = NSAttributedString(string: "TOP", attributes: memeTextAttributes)
        bottomTextField.attributedPlaceholder = NSAttributedString(string: "BOTTOM", attributes: memeTextAttributes)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.enabled = false
        // Disable camera button is camera is not present in the device
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            cameraButton.enabled = true
        }
        //Assign text field delegate
        topTextField.delegate = self
        bottomTextField.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //Register for keyboard notifications
        registerForKeyboardNotification()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //De-register for keyboard notifications
        deregisterForKeyboardNotification()
    }
    // Detects when a user touches the screen and tells the keyboard to disappear when that happens
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        textFieldDidEndEditing(bottomTextField)
        textFieldDidEndEditing(topTextField)
        super.touchesBegan(touches, withEvent: event)
    }

    
    //Return to start state Cancel button is pressed in Meme Editor View
    @IBAction func cancelMeme(sender: UIBarButtonItem) {
        imageView.image = nil
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
    }
    //Album button action to present Alblum
    @IBAction func albumImage(sender: UIBarButtonItem) {
        let albumViewController = UIImagePickerController()
        albumViewController.delegate = self
        presentViewController(albumViewController, animated: true, completion: nil)
    }
    //Camera button action to present camera view
    @IBAction func cameraImage(sender: UIBarButtonItem) {
        let cameraViewController = UIImagePickerController()
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            cameraViewController.sourceType = UIImagePickerControllerSourceType.Camera
            presentViewController(cameraViewController, animated: true, completion: nil)
        }
        cameraViewController.delegate = self
    }
    //Action button to share Meme
    @IBAction func actionButton(sender: UIBarButtonItem) {
        let image = generateMeme()
        var sharingItems = [AnyObject]()
        sharingItems.append(image)
        let shareViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
        self.presentViewController(shareViewController, animated: true, completion: nil)
        shareViewController.completionWithItemsHandler = {
            (activity, success, returneditems, error) in
            print("Activity: \(activity) Success: \(success) Items: \(returneditems) Error: \(error)")
            self.save(image)
        }
    }

    // Reference outlet for Tool Bar
    @IBOutlet weak var toolBar: UIToolbar!
    
    //Reference outlet for Navigation Bar
    @IBOutlet weak var navBar: UINavigationBar!
    
    // Delegate function for UI Image picker controller to access the image
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        if (image != nil) {
            imageView.image = image
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            print("image is a nil")
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    //Delegate function for dismissing the image picker view controller
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Function to register for Keyboard hide and show notification
    func registerForKeyboardNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillDisappear:", name: UIKeyboardDidHideNotification, object: nil)
    }
    
    //Function to deregister for Keyboard hide and show notification
    func deregisterForKeyboardNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidShowNotification, object: nil)
    }
    
    //Function to adjust view once keyboard appears
    func keyboardWasShown(notification:NSNotification) {
        if bottomTextField.isFirstResponder() {
            topTextField.hidden = true
            view.frame.origin.y -= getKeyBoardHeight(notification)
        }
    }
    
    //Function to adjust view once keyboard disappears
    func keyboardWillDisappear(notification:NSNotification) {
            topTextField.hidden = false
            view.frame.origin.y = 0
    }
    
    //Function to derive keyboard height from Userinfo in the UINSNotification
    func getKeyBoardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    //Meme Save Function
    func save(memedImage: UIImage) {
        let memedImage = generateMeme()
        if imageView.image != nil {
            let meme = Meme(image: imageView.image!, topText: topTextField.text!, bottomText: bottomTextField.text!, memedImage: memedImage)
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
        }        
    }
    
    //Generate meme
    func generateMeme() ->UIImage {
        
        
        // Hide toolbar and navbar
        toolBar.hidden = true
        navBar.hidden = true

        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let memedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Show tool and nav bars
        toolBar.hidden = false
        navBar.hidden = false
    
        return memedImage
    }

    //UITextfield Delegate Functions
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        // temp storage for UI text Field Text
        var newText = textField.text! as NSString
        // Assign replacement string to temp storage
        newText = newText.stringByReplacingCharactersInRange(range, withString: string)
        newText = newText.uppercaseString
        textField.text = newText as String
        return false
    }
    
    //UITextfield Delegate Function
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }
    
    //UITextfield Delegate Function
    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    //UITextfield Delegate Function
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}



