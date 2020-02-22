//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by 小野寺祥吾 on 2020/01/30.
//  Copyright © 2020 syogo-user. All rights reserved.
//

import UIKit
import FirebaseUI
import Firebase
class PostTableViewCell: UITableViewCell {
    
    //コメントデータを格納する配列
    var commentArray:[CommentData] = []
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    //@IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    //@IBOutlet weak var commentContentLabel: UILabel!
    //@IBOutlet weak var commentTableView: UITableView!
    
    @IBOutlet weak var commentUserLabel: UILabel!
    @IBOutlet weak var commentContentLabel: UILabel!
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var commentUserImageView: UIImageView!
    @IBOutlet weak var commentShow: UIButton!
    
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
        let imageNumber = postData.name!.components(separatedBy: ":")
        self.captionLabel.text = "\(imageNumber[0]) : \(postData.caption!)"
        //日時の表示
        self.dateLabel.text = ""
        if let date = postData.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateString = formatter.string(from :date)
            self.dateLabel.text = dateString
        }
        

        //コメントの表示
//        self.commentLabel.text = ""
//        self.commentContentLabel.text = ""
//        for comments in postData.comments {
//            let commentDic = comments as! [String:String] //ここが大事　Any型を[String:String]にキャストする
            //self.commentLabel.text! += "\(commentDic["userName"]!) \n"
            //self.commentContentLabel.text! += "\(commentDic["content"]!) \n"
//        }


        
        
        //投稿者のアイコンを表示
        let user = Auth.auth().currentUser
        if let user  = user{
            if let myId = postData.myId{
                let  displayName : String = user.displayName! as String
                //文字列を: で分割　imageNumber[1]
                let imageNumber = displayName.components(separatedBy: ":")
                //インジケーター表示
                myImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                let imageRef2 = Storage.storage().reference().child(Const.ImagePath).child(myId).child("\(imageNumber[1])" + ".jpg")
                
                SDImageCache.shared.removeImage(forKey: imageRef2.fullPath , withCompletion: nil)
                
                myImageView.sd_setImage(with: imageRef2)
                //画像を丸く表示
                //myImageView.layer.cornerRadius = 30 * 0.4
                //myImageView.clipsToBounds = true
            }
        }
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
        
        //commentTableView.delegate = self
        //commentTableView.dataSource = self
        //カスタムセルを登録する(Cellで登録)xib
//        let nib = UINib(nibName: "XibTableViewCell", bundle:nil)
//        commentTableView.register(nib, forCellReuseIdentifier: "Cell2")
        //postのコメントデータをcommentArrayに渡す  CommentDataにAny型が渡されるはず
        self.commentArray = postData.comments.map{ comments in return CommentData(comments)}
        
        if commentArray.count > 0{
            //コメントの表示
            let imageNumber = self.commentArray[0].commentUser!.components(separatedBy: ":")
            commentUserLabel.text =  imageNumber[0]
            print("temp:\(imageNumber[1])")
            //コメント内容
            commentContentLabel.text = self.commentArray[0].commentContent
            
            //コメントユーザID
            let commentUserId =  self.commentArray[0].commentUserId
            
            
            if let commentUserId = commentUserId {
                commentUserImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                let imageRef2 = Storage.storage().reference().child(Const.ImagePath).child(commentUserId).child("\(imageNumber[1])" + ".jpg")
                commentUserImageView.sd_setImage(with:imageRef2)
            }
        }
    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return commentArray.count
//    }
//
//    func tableView(_ tableView:UITableView,cellForRowAt indexPath:IndexPath) ->UITableViewCell {
//        //セルを取得してデータを設定する xib
//        //let comment = commentArray[indexPath.row]
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! XibTableViewCell
//        //let cell = commentTableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! XibTableViewCell
//        cell.setCommentData(commentArray[indexPath.row] )
//
//        return cell
//    }
    
    
    
        
    
}
