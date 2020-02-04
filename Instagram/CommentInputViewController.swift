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
    
    @IBAction func submitButton(_ sender: Any) {
        var postRef = Firestore.firestore().collection(Const.PostPath).document(documentId)
        var user = Auth.auth().currentUser
        let data = ["comment":inputTextView.text!,"commentUser":user?.displayName] as [String:Any]
        
        print("submitButton")
        //postRef.setValue("comment",forKey: inputTextView.text!)
        //postRef.updateChildValues(data)
        postRef.updateData(data)
        
        //送信ボタン押下後はモーダル画面を閉じる
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func dismissView(){
        //画面を閉じる
        self.dismiss(animated: true, completion: nil)
    }
}
