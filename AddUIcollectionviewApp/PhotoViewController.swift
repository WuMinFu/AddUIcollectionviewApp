//
//  PhotoViewController.swift
//  AddUIcollectionviewApp
//
//  Created by mac on 2018/10/31.
//  Copyright © 2018年 mac. All rights reserved.
//

import UIKit

protocol  EditPhotoViewControllerDelegate  {
    func  update()
}

class PhotoViewController: UIViewController {

    var imageArrary : [Picture] = []
    var photoImage : Int?
    var delegate : EditPhotoViewControllerDelegate?
    
    @IBOutlet weak var photoZoom: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let picture = Picture.readFromFile(),let photoImage = photoImage{
            self.imageArrary = picture
            photoZoom.image = UIImage(data :imageArrary[photoImage].image)
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func deletButton(_ sender: Any) {
        imageArrary.remove(at: photoImage!)
        Picture.saveFile(picture: imageArrary)
        delegate?.update()
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
