//
//  ViewController.swift
//  AddUIcollectionviewApp
//
//  Created by mac on 2018/10/27.
//  Copyright © 2018年 mac. All rights reserved.
//

import UIKit



class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    

    var imageArrary : [Picture] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let picture = Picture.readFromFile(){
            self.imageArrary = picture
        }
        
        //讓cell跟著螢幕大小變化
        let layout = myCollectionView.collectionViewLayout as?    UICollectionViewFlowLayout
        let width = (UIScreen.main.bounds.width - 2 * 2) / 3
        layout?.itemSize = CGSize(width: width, height: width)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
/*
     
     collectionView功能
     
*/
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArrary.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImgImageCollectionViewCell", for: indexPath) as! ImgImageCollectionViewCell
        
        cell.imgImage.image = UIImage(data : imageArrary[indexPath.row].image)
        
        return cell
    }
    
    
    
/*
     
     相機功能
     
*/
    @IBAction func photoButton(_ sender: Any) {
        let photoActionSheet = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        
        
        
        let photoAlbumAction = UIAlertAction(title: "從相冊選擇", style: UIAlertAction.Style.default){ (action:UIAlertAction)in
            
            self.initPhotoPicker()
            
        }
        
        let photoPhotoAction = UIAlertAction(title: "拍照", style: UIAlertAction.Style.default){ (action:UIAlertAction)in
            
            
            self.initCameraPicker()
            
        }
        
        
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel){ (action:UIAlertAction)in
            
            
        }
        
        
        photoActionSheet.addAction(photoAlbumAction)
        photoActionSheet.addAction(photoPhotoAction)
        photoActionSheet.addAction(cancelAction)
        
        photoActionSheet.popoverPresentationController?.sourceView = self.view
        photoActionSheet.popoverPresentationController?.sourceRect = CGRect(x: view.frame.maxX/2, y: view.frame.maxY, width: 1.0, height: 1.0)
        
        self.present(photoActionSheet, animated: true, completion: nil)

    }
    //從相冊選擇
    func initPhotoPicker(){
        let photoPicker =  UIImagePickerController()
        photoPicker.delegate = self
        photoPicker.allowsEditing = true
        photoPicker.sourceType = .photoLibrary
        //在需要的地方present出来
        self.present(photoPicker, animated: true, completion: nil)
    }
    //拍照
    func initCameraPicker(){
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let  cameraPicker = UIImagePickerController()
            cameraPicker.delegate = self
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = .camera
            //在需要的地方present出来
            self.present(cameraPicker, animated: true, completion: nil)
        } else {
            
            print("不支持拍照")
            
        }
        
    }
    
    //拍照結束所做的動作
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        
        //將圖片顯示在畫面上
        self.imageArrary.append(Picture(image: image.pngData()!))
        Picture.saveFile(picture: imageArrary)
        myCollectionView.reloadData()
        
        // 退出相機介面
        picker.dismiss(animated: true, completion: nil)
    }
    @objc func image(image:UIImage,didFinishSavingWithError error:NSError?,contextInfo:AnyObject) {
        
        if error != nil {
            
            print("保存失败")
            
            
        } else {
            
            print("保存成功")
            
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? PhotoViewController, let indexPath = self.myCollectionView.indexPathsForSelectedItems {
            controller.photoImage = indexPath[0].row
            controller.delegate = self
        }
        
    }
}

extension ViewController: EditPhotoViewControllerDelegate{
    func update() {
        if let indexPath = myCollectionView.indexPathsForSelectedItems{
            
            //需要刪除imageArrary否則畫面不會更新
            self.imageArrary.remove(at: indexPath[0].row)
            myCollectionView.reloadData()
            print("reload")
        }
    }
}
