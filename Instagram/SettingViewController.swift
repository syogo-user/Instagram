//
//  SettingViewController.swift
//  Instagram
//
//  Created by 小野寺祥吾 on 2020/01/26.
//  Copyright © 2020 syogo-user. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import FirebaseUI

class SettingViewController: UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate  {

    @IBOutlet weak var displayNameTextField: UITextField!
    @IBOutlet weak var myPicture: UIImageView!
    //Firestoreのリスナー
    var listener : ListenerRegistration!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        let user = Auth.auth().currentUser
        if let user = user {

            
            
            //画像の表示
            //インジケーター表示
            myPicture.sd_imageIndicator = SDWebImageActivityIndicator.gray
            
            let  displayName : String = user.displayName! as String
            //文字列を: で分割　imageNumber[1]
            let imageNumber = displayName.components(separatedBy: ":")
            print("SettingViewController ViewWillAppear \(imageNumber[0])")
            let imageRef = Storage.storage().reference().child(Const.ImagePath).child(user.uid).child("\(imageNumber[1])" + ".jpg")
            myPicture.sd_setImage(with:imageRef)
            //画像を丸く表示
            myPicture.layer.cornerRadius = 300 * 0.6
            myPicture.clipsToBounds = true
            
            
            //表示名を取得してTextFieldに設定する
            displayNameTextField.text = imageNumber[0]

        }
    }
        

     
    //表示名変更ボタンをタップした時に呼ばれるメソッド
    @IBAction func handleChangeButton(_ sender: Any) {
        if let displayName = displayNameTextField.text {
            //表示名が入力されていない時はHUDを出して何もしない
            if displayName.isEmpty{
                SVProgressHUD.showError(withStatus: "表示名を入力してください。")
                return
            }
            
            //表示名を設定する
            let user = Auth.auth().currentUser
            if let user = user {
                //現在のdisplayNameから画像を番号を取得
                let imageNumber = user.displayName!.components(separatedBy: ":")
                //displayNameを変更
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = displayName + ":" + imageNumber[1]
                changeRequest.commitChanges{ error in
                    if let error = error {
                        SVProgressHUD.showError(withStatus: "表示名の変更に失敗しました。")
                        print("DEBUG_PRINT:" + error.localizedDescription)
                        return
                    }
                    print("DEBUG_PRINT:[displayName = \(user.displayName!)]の設定に成功しました。")
                    //HUDで完了を知らせる
                    SVProgressHUD.showSuccess(withStatus: "表示名を変更しました。")
                }
            }
        }
        //キーボードを閉じる
        self.view.endEditing(true)
    }
    
    
    //ログアウトボタンをタップした時に呼ばれるメソッド
    @IBAction func handleLogounButton(_ sender: Any) {
        //ログアウトする
        try! Auth.auth().signOut()
        
        //ログイン画面を表示する
        let loginViewContoroller = self.storyboard?.instantiateViewController(withIdentifier: "Login")
        self.present(loginViewContoroller!,animated: true,completion: nil)
        
        //ログイン画面から戻ってきた時のためにホーム画面(index = 0)を選択している状態にしておく
        tabBarController?.selectedIndex = 0

    }
    //MyPictureボタン押下時
    @IBAction func myPictureButton(_ sender: Any) {
        //ライブラリ（カメラロール）を指定してピッカーを開く
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .photoLibrary
            self.present(pickerController,animated:true,completion: nil)
        }
        

        
    }
    //写真を撮影・選択した時に呼ばれるメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if info[.originalImage] != nil{
            //撮影・選択された画像を取得する
            let image = info[.originalImage] as! UIImage

            
            //画像をJPEG形式に変換する
            let imageData = image.jpegData(compressionQuality: 0.75)
            //画像と投稿データの保存場所を定義する
            //let postRef = Firestore.firestore().collection(Const.PostPath).document()
            //ユーザの情報を取得
            let user = Auth.auth().currentUser
                if let user = user{//if文　データが入っている時だけtrue
                    //動的な画像ファイル名を設定
                    //var number = user.displayName?.suffix(user.displayName!.firstIndex(of:":"))
                    let  displayName : String = user.displayName! as String
                    var imageNumber = displayName.components(separatedBy: ":")
                    imageNumber[1] = String(Int(imageNumber[1])! + 1)
                    
                    let changeRequest2 = user.createProfileChangeRequest()
                    changeRequest2.displayName = imageNumber[0] + ":" + imageNumber[1]//文字連結 表示名:画像番号
                    changeRequest2.commitChanges{ error in
                        if let error = error {
                            SVProgressHUD.showError(withStatus: "表示名の変更に失敗しました。")
                            print("DEBUG_PRINT:" + error.localizedDescription)
                            return
                        }
                    }
                    
                    let imageRef2 = Storage.storage().reference().child(Const.ImagePath).child(user.uid).child("\(imageNumber[1])" + ".jpg")
                    print(user.displayName!)
                        //HUDで投稿処理中の表示を開始
                        let metadata = StorageMetadata()
                        metadata.contentType = "image/jpeg"
                        
                        imageRef2.putData(imageData!,metadata: metadata){ (metadata,error) in
                            if error != nil {
                                //画像のアップロード失敗
                                print(error)
                                SVProgressHUD.showError(withStatus: "画像のアップロードが失敗しました")
                                return
                            }
                            SVProgressHUD.showSuccess(withStatus: "投稿しました")
                            //self.myPicture.sd_setImage(with: <#T##StorageReference#>)
                            self.myPicture.image = image
                            
                            //投稿処理が完了したので先頭画面に戻る
                            UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
                            
                    }
                }
        }
        
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //画面を閉じてタブ画面に戻る
        self.dismiss(animated: true, completion: nil)
        
    }
    

}
