//
//  CommentShowViewController.swift
//  Instagram
//
//  Created by 小野寺祥吾 on 2020/02/16.
//  Copyright © 2020 syogo-user. All rights reserved.
//

import UIKit

class CommentShowViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{

    var commentsArray :[CommentData] = []
    @IBOutlet weak var commentTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTableView.dataSource = self
        commentTableView.delegate = self
        
        //カスタムセルを登録する(Cellで登録)xib
        let nib = UINib(nibName: "XibTableViewCell", bundle:nil)
        commentTableView.register(nib, forCellReuseIdentifier: "Cell2")
        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsArray.count
    }
    func tableView(_ tableView:UITableView,cellForRowAt indexPath:IndexPath) ->UITableViewCell {
        //セルを取得してデータを設定する xib
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! XibTableViewCell
        
        cell.setCommentData(commentsArray[indexPath.row])
        return cell
    }
    //高さ調整
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
