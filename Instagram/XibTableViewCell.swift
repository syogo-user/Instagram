//
//  XibTableViewCell.swift
//  Instagram
//
//  Created by 小野寺祥吾 on 2020/02/15.
//  Copyright © 2020 syogo-user. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
class XibTableViewCell: UITableViewCell {

    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var commentUser: UILabel!
    @IBOutlet weak var commentContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCommentData(_ commentData:CommentData){
        //コメントを画面に表示する
        
        //コメント投稿者
        //文字列を: で分割　imageNumber[0]コメントユーザ名  imageNumber[1] 画像番号
        let imageNumber = commentData.commentUser!.components(separatedBy: ":")
        self.commentUser.text = imageNumber[0]
        
        //コメント内容
        self.commentContent.text = commentData.commentContent
        
        //コメント投稿者の写真
        let userId = commentData.commentUserId
        if let userId = userId{
            //インジケーター表示
            self.myImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
            let imageRef = Storage.storage().reference().child(Const.ImagePath).child(userId).child("\(imageNumber[1])" + ".jpg")
            self.myImage.sd_setImage(with:imageRef)
        }
        
    }
}
