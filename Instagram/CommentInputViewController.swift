//
//  CommentInputViewController.swift
//  Instagram
//
//  Created by 小野寺祥吾 on 2020/02/04.
//  Copyright © 2020 syogo-user. All rights reserved.
//

import UIKit
import Firebase
class CommentInputViewController: UIViewController {
    
    @IBOutlet weak var inputTextView: UITextView!
    
    var documentId :String!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red:0,green:0,blue:0,alpha:0.5)
        // Do any additional setup after loading the view.
        //背景をタップしたら画面を閉じるメソッドを呼ぶように設定する
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target:self,action:#selector(dismissView))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    //コメントボタン押下時
    @IBAction func submitButton(_ sender: Any) {
        let postRef = Firestore.firestore().collection(Const.PostPath).document(documentId)
        let user = Auth.auth().currentUser
        
        if let userName = user?.displayName ,let userId = user?.uid{
            let comments = ["userName": userName,"content":self.inputTextView.text!,"commentUserId":userId]
            //コメントのデータを取得する
            postRef.getDocument {
                (document,error) in
                if let error = error {
                    print("DEBUG_PRINT: snapshotの取得が失敗しました。\(error)")
                    return
                } else {
                    if let document  = document ,document.exists{
                        var array  = document["comments"] as! [Any]
                        array.append(comments)
                        let data  = [
                            "comments" : array
                        ]
                        print("submitButton")
                        postRef.updateData(data)
                    }
                }
                
                
            }
         }
        //送信ボタン押下後はモーダル画面を閉じる
        self.dismiss(animated: true, completion: nil)
    }

                    


                    
               
                
                
            
        
                
                
                
                
                
                
                
                
                
                
                
                
                
                
//                for document in querySnapshot.documents {
//
//                    //ドキュメントのIDと同じコメントデータを取得する
//                    if document.documentID == self.documentId {
//                       let postDic = document.data()
//                        //コメントの配列を取得
//                        for comment in postDic["comment"] as! [String] {
//                            self.comments += comment + ","
//                        }
//                        //コメントユーザの配列を取得
//                        for commentUser in postDic["commentUser"] as! [String] {
//                            self.comments.append(commentUser)
//                        }
//
//                    }
//                }

        

//        let data = [
//            "comments" : ["1","2",inputTextView.text!]
//            , "commentUser" : ["a","b","c"]
//            ]
//
//        let data  = [
//            "comments" : FieldValue.arrayUnion([self.inputTextView.text!]),
//            "commentUsers":FieldValue.arrayUnion([user?.displayName]
//            )]
        
        //var myPostArray = PostArray(comment:"self.inputTextView.text!" ,commnetUser:"user?.displayName as! String")
        //let data = ["comments" : FieldValue.arrayUnion([myPostArray])]
        //let data = FieldValue.arrayUnion([myPostArray])

        
    
    
    @objc func dismissView(){
        //画面を閉じる
        self.dismiss(animated: true, completion: nil)
    }
}
