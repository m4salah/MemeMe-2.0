//
//  MemeTableViewController.swift
//  MemeMe-1.0
//
//  Created by Mohamed Abdelkhalek Salah on 4/29/20.
//  Copyright © 2020 Mohamed Abdelkhalek Salah. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {

    private let reusableId = "MemeTableViewCell"
    
    var memes: [Meme]! {
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(pushCreatMeme))
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        navigationItem.title = "Sent Memes"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    @objc func pushCreatMeme() {
        if let creatMeme = storyboard?.instantiateViewController(identifier: "createMemeVC") {
            navigationController?.pushViewController(creatMeme, animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCell(withIdentifier: reusableId){
            cell.imageView?.image = memes[indexPath.row].memedImage
            cell.textLabel?.text = memes[indexPath.row].topText
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memedImage = memes[indexPath.row].memedImage
        if let memeDetailVC = storyboard?.instantiateViewController(identifier: "MemeDetailViewController") as? MemeDetailViewController {
            memeDetailVC.memeImage = memedImage
            navigationController?.pushViewController(memeDetailVC, animated: true)
        }
    }
}
