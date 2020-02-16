//
//  CommentData.swift
//  Instagram
//
//  Created by 小野寺祥吾 on 2020/02/16.
//  Copyright © 2020 syogo-user. All rights reserved.
//

import UIKit
import Firebase

class CommentData: NSObject {
    var commentUser :String?
    var commentContent :String?
    var commentUserId : String?
    //var commentUserImage :String?

    init(_ postData:Any) {
        //self.commentArray = postData
//        let commentDic = postData.data()
//        for
        let comments = postData as! [String:String]
        self.commentUser = comments["userName"]
        self.commentContent = comments["content"]
        self.commentUserId = comments["commentUserId"]
//        self.commentUserImage = commentDic[""]
        
    }
    
}
