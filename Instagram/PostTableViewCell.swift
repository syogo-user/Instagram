//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by 小野寺祥吾 on 2020/01/30.
//  Copyright © 2020 syogo-user. All rights reserved.
//

import UIKit
import FirebaseUI

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var commentContentLabel: UILabel!
    
    
    var commentText : String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        //  												 Configure the view for the selected state
    }
    
    //PostDataの内容をセルに表示
    func setPostData(_ postData:PostData){
        //画像の表示
        //インジケーター表示
        postImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postData.id + ".jpg")
        postImageView.sd_setImage(with:imageRef)
        
        //キャプションの表示
        self.captionLabel.text = "\(postData.name!) : \(postData.caption!)"
        //日時の表示
        self.dateLabel.text = ""
        if let date = postData.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateString = formatter.string(from :date)
            self.dateLabel.text = dateString
        }
        

        //コメントの表示
        self.commentLabel.text = ""
        self.commentContentLabel.text = ""
        for comments in postData.comments {
            let commentDic = comments as! [String:String] //ここが大事　Any型を[String:String]にキャストする
            self.commentLabel.text! += "\(commentDic["userName"]!) \n"
            self.commentContentLabel.text! += "\(commentDic["content"]!) \n"
        }
        
        
        
        
        
        
        
        
        
        
        
//        self.commentLabel.text! = postData.comments["userName"] as! String
//        self.commentContentLabel.text! = postData.comments["content"] as! String
        
        
        
//        for (key,value) in postData.comments {
//            self.commentLabel.text! += "\ \n"
////            if let comm  = comment {
////                self.commentLabel.text!  +=  comm + "\n"
////            }
//        }
       // self.commentLabel.text = commentText

//        if let commentUser = postData.commentUser {
//            if let comments = postData.comments   {
//                if commentUser[0] != ""{
//                    //コメントユーザとコメントの表示
//                    self.commentLabel.text = "\(commentUser[0]) → \(comments[0]) "
//                }else {
//                    self.commentLabel.text = ""
//                }
//            }
//        }
        //いいね数の表示
        let likeNumber = postData.likes.count
        likeLabel.text = "\(likeNumber)"
        
        //いいねボタンの表示
        if postData.isLiked {
            let buttonImage = UIImage(named:"like_exist")
            self.likeButton.setImage(buttonImage,for:.normal)
            
        } else {
            let buttonImage = UIImage(named:"like_none")
            self.likeButton.setImage(buttonImage,for:.normal)
        }
        
        
    }
        																	
}
