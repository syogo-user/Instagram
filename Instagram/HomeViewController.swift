//
//  HomeViewController.swift
//  Instagram
//
//  Created by 小野寺祥吾 on 2020/01/26.
//  Copyright © 2020 syogo-user. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!


    //投稿データを格納する配列
    var postArray:[PostData] = []
    //Firestoreのリスナー
    var listener : ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //カスタムセルを登録する(Cellで登録)xib
        let nib = UINib(nibName: "PostTableViewCell", bundle:nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView:UITableView,cellForRowAt indexPath:IndexPath) ->UITableViewCell {
        //セルを取得してデータを設定する xib
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        cell.setPostData(postArray[indexPath.row])
        
        //セル内のボタンのアクションをソースコードで設定する
        cell.likeButton.addTarget(self,action:#selector(handleButton(_ : forEvent:)),for: .touchUpInside)
        //セル内のコメントボタンのアクションをソースコードで設定する
        cell.commentButton.addTarget(self,action:#selector(handleCommentButton(_ : forEvent:)),for: .touchUpInside)
        
        //セル内のキャンセルボタンが押された時のアクションをソースコードで設定
        cell.deleteButton.addTarget(self,action:#selector(handleDeleteButton(_ : forEvent:)),for: .touchUpInside)
        
        //セル内の　すべてのコメントを表示ボタン　が押された時のアクションをソースコードで設定
        cell.commentShow.addTarget(self,action:#selector(handleCommentShowButton(_ : forEvent:)),for: .touchUpInside)
        return cell
    }
    
    //viewが表示される直前に呼ばれる
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewWillAppear")
        
        if Auth.auth().currentUser != nil {
            //ログイン済み
            if listener == nil{
                //listener未登録なら、登録してスナップショットを受信する
                let postsRef = Firestore.firestore().collection(Const.PostPath).order(by:"date",descending:true)
                listener = postsRef.addSnapshotListener(){ (querySnapshot,error) in
                    if let error = error {
                        print("DEBUG_PRINT: snapshotの取得が失敗しました。\(error)")
                        return
                    }
                //取得したdocumentをもとにPostDataを作成しpostArrayの配列にする
                    self.postArray = querySnapshot!.documents.map {
                        document in
                        print("DEBUG_PRINT: document取得\(document.documentID)")
                        //PostData作成
                        let postData = PostData(document:document)
                        return postData
                    }
                    //TableViewの表示を更新する
                    self.tableView.reloadData()
                }
            }
        } else {
            //ログイン未（またはログアウト済み）
            if listener != nil {
                //listener登録済みなら削除してpostArrayをクリアする
                listener.remove()
                listener = nil
                postArray = []
                tableView.reloadData()
            }
            
        }
    }
    
    //セル内のボタンがタップされた時に呼ばれるメソッド
    @objc func handleButton(_ sender: UIButton,forEvent event:UIEvent){
        print("DEBUG_PRINT: likeボタンがタップされました。")
        //タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        //タッチした座標
        let point = touch!.location(in:self.tableView)
        //タッチした座標がtableViewのどのindexPath位置か
        let indexPath = tableView.indexPathForRow(at: point)
        
        //配列からタップされたインデックスのデータを取り出す
        let postData = postArray[indexPath!.row]
        
        //likesを更新する
        if let myid = Auth.auth().currentUser?.uid {
            //更新データを作成する
            var updateValue:FieldValue
            if postData.isLiked {
                //すでにいいねをしている場合は、いいね解除のためmyidを取り除く更新データを作成
                updateValue = FieldValue.arrayRemove([myid])
            } else {
                //今回新たにいいねを押した場合は、myidを追加する更新データを作成
                updateValue = FieldValue.arrayUnion([myid])
            }
            //likesに更新データを書き込む
            let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
            postRef.updateData(["likes":updateValue])
        }

    }
    //コメントボタン押下時
    @objc func handleCommentButton(_ sender: UIButton,forEvent event:UIEvent){
        print("DEBUG_PRINT: commentボタンがタップされました。")
        //タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        //タッチした座標
        let point = touch!.location(in:self.tableView)
        //タッチした座標がtableViewのどのindexPath位置か
        let indexPath = tableView.indexPathForRow(at: point)
        
        //配列からタップされたインデックスのデータを取り出す
        let postData = postArray[indexPath!.row]
        
        //モーダルで画面遷移
        let commentInputViewController = self.storyboard?.instantiateViewController(withIdentifier:"comment") as! CommentInputViewController
        //documentのIDを渡す
        commentInputViewController.documentId = postData.id
        self.present(commentInputViewController,animated: true,completion: nil)
        
        
        
        
    }
    
    //削除ボタン押下時
    @objc func handleDeleteButton(_ sender: UIButton,forEvent event:UIEvent){
        print("DEBUG_PRINT: 削除ボタンが押されました。")
        //タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        //タッチした座標
        let point = touch!.location(in: self.tableView)
        //タッチした座標がtableViewのどのindexPath位置か
        let indexPath = tableView.indexPathForRow(at: point)
        //配列からタップされたインデックスのデータを取り出す
        let postData = postArray[indexPath!.row]

        
        if Auth.auth().currentUser?.displayName == postData.name {
            //投稿者と現在ログインしている人物が同じであった場合
            
            //確認メッセージ出力
            let alert : UIAlertController = UIAlertController(title: "この投稿を削除してもよろしいですか？", message :nil, preferredStyle: UIAlertController.Style.alert)
            
            //OKボタン押下時
            let defaultAction :UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
                (action :UIAlertAction! ) -> Void in
                //以下OKボタンが押された時の動作
                //・firestoreからドキュメントを削除
                let postsRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
                postsRef.delete()
                
                //・firestorageから写真を削除
                let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postData.id + ".jpg")
                imageRef.delete{ error in
                    if let error = error {
                        print("DEBUG_PRINT: \(error)")
                    } else {
                        print("DEBUG_PRINT: 画像の削除が成功しました。")
                    }
                }
            })
            
            //キャンセルボタン押下時 → 何もしない
            let cancelAction : UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.default, handler:nil)
            //UIAlertControllerにActionを追加
            alert.addAction(cancelAction)
            alert.addAction(defaultAction)
            //Alertを表示
            present(alert,animated: true)
//            presentingViewController(alert,dismiss(animated: true, completion: nil))
//            presentedViewController(alert,dismiss(animated: true, completion: nil))
            
        } else {
            //投稿者と現在ログインしている人物が異なる場合
            print("DEBUG_PRINT: 投稿者が異なります。")
        }
        
        //コメントとコメント入力者を別の変数で持つ　例Any[””：””]
    }
    
    //コメントをすべて表示ボタン押下時
    @objc func handleCommentShowButton(_ sender: UIButton,forEvent event:UIEvent){
        print("DEBUG_PRINT: commentShowボタンがタップされました。")
         //タップされたセルのインデックスを求める
         let touch = event.allTouches?.first
         //タッチした座標
         let point = touch!.location(in:self.tableView)
         //タッチした座標がtableViewのどのindexPath位置か
         let indexPath = tableView.indexPathForRow(at: point)
         
         //配列からタップされたインデックスのデータを取り出す
         let postData = postArray[indexPath!.row]
         
         //モーダルで画面遷移
         let commeBntShowViewController = self.storyboard?.instantiateViewController(withIdentifier:"commentShow") as! CommentShowViewController
         //commentsを渡す
        commeBntShowViewController.commentDictionary = postData.comments as [CommentData]
         self.present(commeBntShowViewController,animated: true,completion: nil)
    }
}
