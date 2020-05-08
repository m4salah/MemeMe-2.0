//
//  MemeDetailViewController.swift
//  MemeMe-2.0
//
//  Created by Mohamed Abdelkhalek Salah on 4/30/20.
//  Copyright © 2020 Mohamed Abdelkhalek Salah. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    var memeImage: UIImage!
    @IBOutlet var memImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareMeme))
    }
    
    @objc func shareMeme(){
        let memedImage = memImageView.image!
        let activityControll = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        present(activityControll, animated: true, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        memImageView.image = memeImage
    }
    
}
