//
//  MemeCollectionViewController.swift
//  MemeMe-1.0
//
//  Created by Mohamed Abdelkhalek Salah on 4/29/20.
//  Copyright © 2020 Mohamed Abdelkhalek Salah. All rights reserved.
//

import UIKit

private let reusableId = "MemeCollectionViewCell"

class MemeCollectionViewController: UICollectionViewController {

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    var memes: [Meme]! {
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Sent Memes"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(pushCreatMeme))
        
        let space: CGFloat = 3.0
        let dimensionWidth = (view.frame.size.width - (2 * space)) / 3.0
        let dimensionHight = (view.frame.size.height - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimensionWidth, height: dimensionHight)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        collectionView.reloadData()
    }
    
    @objc func pushCreatMeme() {
        if let creatMeme = storyboard?.instantiateViewController(identifier: "createMemeVC") {
            navigationController?.pushViewController(creatMeme, animated: true)
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableId, for: indexPath) as? MemeCollectionViewCell {
            cell.configureMeme(image: memes[indexPath.row].memedImage)
            return cell
        }
        return UICollectionViewCell()
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let memedImage = memes[indexPath.row].memedImage
        if let memeDetailVC = storyboard?.instantiateViewController(identifier: "MemeDetailViewController") as? MemeDetailViewController {
            memeDetailVC.memeImage = memedImage
            navigationController?.pushViewController(memeDetailVC, animated: true)
        }
    }
}


