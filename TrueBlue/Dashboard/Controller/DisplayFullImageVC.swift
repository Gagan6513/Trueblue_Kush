//
//  DisplayFullImageVC.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 04/09/21.
//

import UIKit
import Kingfisher
class DisplayFullImageVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var colseBtn: UIButton!
    
    var imgForDisplay = UIImage()
    var imageUrlForDisplay = String()
    private var downSwipeGestureRecognizer: UISwipeGestureRecognizer!
    private var leftSwipeGestureRecognizer: UISwipeGestureRecognizer!
    private var RightSwipeGestureRecognizer: UISwipeGestureRecognizer!
    var imageArray = [String]()
    var currenIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 10
        scrollView.bounces = false
        colseBtn.layer.shadowColor = UIColor.black.cgColor
        colseBtn.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        colseBtn.layer.shadowRadius = 8
        colseBtn.layer.shadowOpacity = 0.8
        colseBtn.layer.masksToBounds = false
        downSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        downSwipeGestureRecognizer.direction = .down
        
        self.view.addGestureRecognizer(downSwipeGestureRecognizer)
        
        leftSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        leftSwipeGestureRecognizer.direction = .left
        
        self.view.addGestureRecognizer(leftSwipeGestureRecognizer)
        
        RightSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        RightSwipeGestureRecognizer.direction = .right
        
        self.view.addGestureRecognizer(RightSwipeGestureRecognizer)
            
    }
    @objc private func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
           // Check if the swipe direction is downward
           if gesture.direction == .down {
               // Hide the image view or perform any other action
               dismiss(animated: true, completion: nil)
           } else if gesture.direction == .left {
               
               if(currenIndex < imageArray.count){
                   currenIndex += 1
                   if imageArray.indices.contains(currenIndex) {
                       imageView.kf.setImage(with: URL(string: imageArray[currenIndex]))
                   }
                   
               }
           } else {
               
               if(currenIndex > 0){
                   currenIndex -= 1
                   if imageArray.indices.contains(currenIndex) {
                       imageView.kf.setImage(with: URL(string: imageArray[currenIndex]))
                   }
                   
               }
               
           }
       }
    override func viewWillAppear(_ animated: Bool) {
        if imageUrlForDisplay.isEmpty {
            //Img is sent from previous view controller
            imageView.image = imgForDisplay
        } else {
            //Image Url is sent from previous view controller
            imageView.kf.setImage(with: URL(string: imageUrlForDisplay))
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view != backgroundView {
          //  dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func closeBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}


extension DisplayFullImageVC : UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
