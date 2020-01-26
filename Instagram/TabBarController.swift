//
//  TabBarController.swift
//  Instagram
//
//  Created by 小野寺祥吾 on 2020/01/26.
//  Copyright © 2020 syogo-user. All rights reserved.
//

import UIKit
import Firebase

class TabBarController: UITabBarController ,UITabBarControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        //タブアイコンの色
        self.tabBar.tintColor = UIColor(red:1.0,green: 0.44,blue: 0.11,alpha: 1)
        //タブバーの背景色
        self.tabBar.barTintColor = UIColor(red:0.96,green:0.91,blue:0.87,alpha:1)
        //UITabBarControllerDelegateプロトコルのメソッドをこのクラスで処理する
        self.delegate = self

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //currentUserがnilならログインしていない
        if Auth.auth().currentUser == nil {
            //ログインしていない時の処理
            let lobinViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
            self.present(lobinViewController!,animated:true,completion:nil)
        }
    }
    
    //タブバーのアイコンがタップされた時に呼ばれるdelegateメソッドを処理する
    //true:タブを切り替える　false:タブを切り替えない
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is ImageSelectViewController {
            //ImageSelectViewControllerはタブ切り替えではなくモーダル画面遷移する
            let imageSelectViewController = storyboard!.instantiateViewController(identifier: "ImageSelect")
            present(imageSelectViewController,animated: true)
            return false
        } else {
            //その他のViewControllerは通常のタブ切り替えを実施
            return true
        }
    }


}
