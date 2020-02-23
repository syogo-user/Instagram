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
    var myId :String?
    var name :String?
    var caption:String?
    var date: Date?
    var likes :[String] = []
    var isLiked:Bool = false
    var comments :[Any] = []


    init(document:QueryDocumentSnapshot){
        self.id = document.documentID
        
        let postDic = document.data()
        self.myId = postDic["myId"] as? String
        self.name = postDic["name"] as? String
        self.caption = postDic["caption"] as? String
        let timestamp = postDic["date"] as? Timestamp
        self.date = timestamp?.dateValue()
        
        
        if let comments = postDic["comments"] as? [Any] {
            self.comments = []//
            self.comments = comments
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
