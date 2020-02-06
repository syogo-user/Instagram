//
//  PostData.swift
//  Instagram
//
//  Created by 小野寺祥吾 on 2020/01/30.
//  Copyright © 2020 syogo-user. All rights reserved.
//

import UIKit
import Firebase

class PostData: NSObject {
    var id:String
    var name :String?
    var caption:String?
    var date: Date?
    var likes :[String] = []
    var isLiked:Bool = false
    var comments :[String] = []
    var commentUser:[String]  = []

    init(document:QueryDocumentSnapshot){
        self.id = document.documentID
        
        let postDic = document.data()
        
        self.name = postDic["name"] as? String
        self.caption = postDic["caption"] as? String
        let timestamp = postDic["date"] as? Timestamp
        self.date = timestamp?.dateValue()
        
        
        if let comments = postDic["comment"] as? [String] {
            self.comments = comments
        }
        if let commentUser = postDic["commentUser"] as? [String] {
            self.commentUser = commentUser
        }

        
        if let likes = postDic["likes"] as? [String] {
            self.likes = likes
        }
        if let myid = Auth.auth().currentUser?.uid{
            //likesの配列の中にmyidが含まれているかチェックすることで、自分がいいねを押しているかを判断
            if self.likes.firstIndex(of: myid) != nil{
                //myidがあれば、いいねを押していると認識する
                self.isLiked = true
            }
        }
    
        
    }
}
