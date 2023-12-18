//
//  DiagramVC.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 09/08/22.
//

import UIKit
import AASignatureView

class DiagramVC: UIViewController {

    @IBOutlet weak var diagramView: AASignatureView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        diagramView.layer.borderColor = UIColor(named: AppColors.INPUT_BORDER)?.cgColor
        if UIDevice.current.userInterfaceIdiom == .pad {
            diagramView.layer.borderWidth = 3
            diagramView.layer.cornerRadius = 7.2
        } else {
            diagramView.layer.borderWidth = 1.1
            diagramView.layer.cornerRadius = 6
        }
    }
    

    @IBAction func backBtnTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    @IBAction func clearBtnTapped(_ sender: UIButton) {
        diagramView.clear()
    }
    
    @IBAction func saveBtnTapped(_ sender: UIButton) {
        submitDiagramAPI()
    }
}

extension DiagramVC {
    func submitDiagramAPI() {
        
        guard let image = diagramView.signature else {
            showToast(strMessage: accidentDiagramEmpty)
            return
        }
        let obj = DiagramVM()
        obj.delegate = self
        let parameters = ["application_id": CommonObject.sharedInstance.currentReferenceId]
        obj.submitAccidentDiagramAPI(parameters: parameters, img: [image], isImage: true, isMultipleImg: false, imgParameter: "image", imgExtension: "jpg", controller: self)
    }
}

extension DiagramVC: DiagramVMDelegate {
    func success(serviceKey: String, message: String) {
        showToast(strMessage: message)
        DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
            self.dismiss(animated: true)
        })
    }
    
    func failure(serviceKey: String, message: String) {
        showToast(strMessage: message)
    }
    
    
}
