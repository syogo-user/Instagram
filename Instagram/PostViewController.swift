//
//  PostViewController.swift
//  Instagram
//
//  Created by 小野寺祥吾 on 2020/01/26.
//  Copyright © 2020 syogo-user. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class PostViewController: UIViewController {
    var image: UIImage!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //受け取った画像をImageViewに設定する
        imageView.image = image
    }
    //投稿ボタンをタップした時に呼ばれるメソッド
    @IBAction func handlePostButton(_ sender: Any) {
        //画像をJPEG形式に変換する
        let imageData = image.jpegData(compressionQuality: 0.75)
        //画像と投稿データの保存場所を定義する
        let postRef = Firestore.firestore().collection(Const.PostPath).document()
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postRef.documentID + ".jpg")
        //HUDで投稿処理中の表示を開始
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        imageRef.putData(imageData!,metadata: metadata){ (metadata,error) in
            if error != nil {
                //画像のアップロード失敗
                print(error)
                SVProgressHUD.showError(withStatus: "画像のアップロードが失敗しました")
                //投稿処理をキャンセルし、先頭画面に戻る
                UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
                return
            }
            //FireStoreに投稿データを保存する
            let name = Auth.auth().currentUser?.displayName
            
            let postDic = [
                "myId":Auth.auth().currentUser?.uid,
                "name":name!,
                "caption":self.textField.text!,
                "date":FieldValue.serverTimestamp(),
//                "comments":[["userName":"田中太郎","content":"とても素晴らしい！"],["userName":"田中花子","content":"まあまあだね"]]
                "comments":[] as [Any]
            ] as [String:Any]
            postRef.setData(postDic)
            //HUDで投稿完了を表示する
            SVProgressHUD.showSuccess(withStatus: "投稿しました")
            //投稿処理が完了したので先頭画面に戻る
            UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    //キャンセルボタンをタップした時に呼ばれるメソッド
    @IBAction func handleCancelButton(_ sender: Any) {
        //加工画面に戻る
        self.dismiss(animated: true, completion: nil)
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
