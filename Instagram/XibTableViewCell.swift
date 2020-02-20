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
        
        self.commentUser.text = commentData.commentUser
        self.commentContent.text = commentData.commentContent
        //コメント投稿者の写真表示
        let imageName = commentData.commentUserId
        if let imageName = imageName{
            //インジケーター表示
            self.myImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
            let imageRef = Storage.storage().reference().child(Const.ImagePath).child(imageName + ".jpg")
            self.myImage.sd_setImage(with:imageRef)
        }
        
    }
}
