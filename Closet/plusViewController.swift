import UIKit
import AVFoundation

class plusViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var plusButton: UIButton!
    @IBOutlet var textView: UITextView!
    @IBOutlet var nametextField: UITextField!
    @IBOutlet var colortextField: UITextField!
    @IBOutlet var typetextField: UITextField! {
        
        didSet {
            nametextField.delegate = self
            colortextField.delegate = self
            typetextField.delegate = self
        }
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        imageView.isHidden = true
        
//メモの枠線
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.borderWidth = 1.0
        
    }
    
    @IBAction func plusButton(_ sender: UIButton) {
        imageView.isHidden = false
        plusButton.isHidden = true
        
        print("+ボタンが押されました")
        
        let sourceType:UIImagePickerController.SourceType = UIImagePickerController.SourceType.camera
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType){
                        
            switch AVCaptureDevice.authorizationStatus(for: .video) {
                case .authorized: // The user has previously granted access to the camera.
                    self.camera(sourceType: sourceType)

                case .notDetermined: // The user has not yet been asked for camera access.
                    AVCaptureDevice.requestAccess(for: .video) { granted in
                        if granted {
                            print("許可されました")
                            DispatchQueue.main.async{
                                self.camera(sourceType: sourceType)
                            }
                        }else{
                            print("許可されませんでした")
                        }
                    }

                case .denied: // The user has previously denied access.
                    DispatchQueue.main.async{
                        
                    }
                    print(".denied")
                    return

                case .restricted: // The user can't grant access due to restrictions.
                    DispatchQueue.main.async{
                        
                    }
                    print(".restricted")
                    return
                default:
                    return
            }
            
        }else{
            print("エラー")
        }
    }
    
    func camera(sourceType:UIImagePickerController.SourceType){
            // インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
//            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
        }
        
        //　撮影が完了時した時に呼ばれる
        func imagePickerController(_ imagePicker: UIImagePickerController,didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
               
            if let pickedImage = info[.originalImage] as? UIImage {
                imageView.contentMode = .scaleAspectFit
                imageView.image = pickedImage
            }
            //閉じる処理
            imagePicker.dismiss(animated: true, completion: nil)
        }
        
        // 撮影がキャンセルされた時に呼ばれる
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
        
        //写真を保存
//        @IBAction func savePicture(_ sender : AnyObject) {
//            let image:UIImage! = imageView.image
//
//            if image != nil {
//                UIImageWriteToSavedPhotosAlbum(
//                    image,
//                    self,
//                    #selector(CameraViewController.image(_:didFinishSavingWithError:contextInfo:)),
//                    nil)
//            }
//        }
        
        // 書き込み完了結果の受け取り
        @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError!, contextInfo: UnsafeMutableRawPointer) {
            if error != nil {
                print(error.code)
               
        }
      

    }

    
    
//キーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           self.view.endEditing(true)
    }
    
//キーボード下げることについて
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    ///Notification発行
   override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       configureObserver()
   }


   /// Notification発行
   func configureObserver() {
       let notification = NotificationCenter.default
       notification.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                name: UIResponder.keyboardWillShowNotification, object: nil)
       notification.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                name: UIResponder.keyboardWillHideNotification, object: nil)
       print("Notificationを発行")
   }

   /// キーボードが表示時に画面をずらす。
   @objc func keyboardWillShow(_ notification: Notification?) {
       guard let rect = (notification?.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
           let duration = notification?.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
       UIView.animate(withDuration: duration) {
           let transform = CGAffineTransform(translationX: 0, y: -(rect.size.height))
           self.view.transform = transform
       }
       print("keyboardWillShowを実行")
   }

   /// キーボードが降りたら画面を戻す
   @objc func keyboardWillHide(_ notification: Notification?) {
       guard let duration = notification?.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? TimeInterval else { return }
       UIView.animate(withDuration: duration) {
           self.view.transform = CGAffineTransform.identity
       }
       print("keyboardWillHideを実行")
   }

}
