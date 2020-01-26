//
//  LoginViewController.swift
//  Instagram
//
//  Created by 小野寺祥吾 on 2020/01/26.
//  Copyright © 2020 syogo-user. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
class LoginViewController: UIViewController {

    @IBOutlet weak var mailAddressTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    @IBOutlet weak var displayNameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    //ログインボタンをタップした時に呼ばれるメソッド
    @IBAction func handleLoginButton(_ sender: Any) {
        if let address = mailAddressTextField.text,let password = passWordTextField.text{
            //アドレスとパスワード名の「いずれかでも入力されていない時は何もしない
            if address.isEmpty || password.isEmpty {
                SVProgressHUD.showError(withStatus: "必要項目を入力してください")
                return
            }
            //HUDで処理中を表示
            SVProgressHUD.show()
            
            Auth.auth().signIn(withEmail: address, password: password ) { authResult ,error in
                if let error = error {
                    print("DEBUG_PRINT:" + error.localizedDescription)
                    SVProgressHUD.showError(withStatus:"サインインに失敗しました。")
                    return
                }
                print("DEBUG_PRINT:ログインに成功しました。")
                
                //HUDを消す
                SVProgressHUD.dismiss()
                //画面を閉じてタブ画面に戻る
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    //アカウント作成ボタンをタップした時に呼ばれるメソッド
    @IBAction func handleCreateAccountButton(_ sender: Any) {
        if let address = mailAddressTextField.text , let password = passWordTextField.text ,let displayName = displayNameTextField.text {
            //アドレスとパスワードと表示名のいずれかでも入力されていない時は何もしない
            if address.isEmpty || password.isEmpty || displayName.isEmpty {
                print("DEBUG_PRINT:何かが空文字です。")
                SVProgressHUD.showError(withStatus: "必要項目を入力してください")
                return
            }
            
            //HUDで処理中を表示
            SVProgressHUD.show()
            
            //アドレスとパスワードでユーザ作成。ユーザ作成に成功すると、自動的にログインする
            Auth.auth().createUser(withEmail: address, password: password) { authResult,error in
                if let error = error {
                    //エラーがあったら原因をprintして、returnすることで以降の処理を実行せずに処理を終了する
                    print("DEBUG_PRINT:"+error.localizedDescription)
                    SVProgressHUD.showError(withStatus: "ユーザ作成に失敗しました。")
                    return
                }
                print("DEBUB_PRINT:ユーザ作成に成功しました。")
                //表示名を設定する
                let user = Auth.auth().currentUser
                if let user = user{//if文　データが入っている時だけtrue
                    let changeReauest = user.createProfileChangeRequest()
                    changeReauest.displayName = displayName
                    changeReauest.commitChanges{ error in //後置クロージャでメソッドの（）は省略されている
                        if let error  = error {
                            //プロフィールの更新でエラーが発生
                            print("DEBUG_PRINT:" + error.localizedDescription)
                            SVProgressHUD.showError(withStatus: "表示名の設定に失敗しました。")
                            return
                        }
                        print("DEBUG_PRINT:[displayName = \(user.displayName!)の設定に成功しました。")
                        
                        //HUDを消す
                        SVProgressHUD.dismiss()
                        
                        //画面を閉じてタブ画面に戻る
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
            
        }
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
