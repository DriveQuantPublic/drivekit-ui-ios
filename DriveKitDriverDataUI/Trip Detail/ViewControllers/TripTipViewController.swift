//
//  TripTipViewController.swift
//  DriveKitDriverDataUI
//
//  Created by Jérémy Bayle on 30/10/2019.
//  Copyright © 2019 DriveQuant. All rights reserved.
//

import UIKit
import DriveKitDriverData

class TripTipViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var okButton: UIButton!
    @IBOutlet var contentView: UIView!
    
    
    private let config: TripListViewConfig
    private let advice: TripAdvice
    
    init(config: TripListViewConfig, advice: TripAdvice) {
        self.config = config
        self.advice = advice
        super.init(nibName: String(describing: TripTipViewController.self), bundle: Bundle.driverDataUIBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.backgroundColor = config.primaryColor
        titleLabel.textColor = .white
        titleLabel.font = config.primaryFont.withSize(17)
        titleLabel.text = advice.title ?? ""
        
        
        okButton.setTitle(config.okText, for: .normal)
        okButton.setTitleColor(.white, for: .normal)
        okButton.backgroundColor = config.secondaryColor
        
        let contentTextView = UITextView(frame: contentView.frame)
        self.automaticallyAdjustsScrollViewInsets = false
        
        if let htmlData = NSString(string: advice.message ?? "").data(using: String.Encoding.unicode.rawValue){
            let attributedString = try! NSMutableAttributedString(data: htmlData, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            contentTextView.attributedText = NSAttributedString(attributedString: attributedString)
            contentTextView.font = config.primaryFont
            contentView.embedSubview(contentTextView)
        }else{
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func closeClicked(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
