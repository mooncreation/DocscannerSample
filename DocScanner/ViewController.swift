//
//  ViewController.swift
//  DocScanner
//
//  Created by Mac on 28/07/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import DocumentScanner
import TOCropViewController
class ViewController: UIViewController {

    // MARK: private fields
    private var scannedImage: UIImage? {
        willSet {
            set(isVisible: newValue != nil)
        } didSet {
            imageView.image = scannedImage
        }
    }
    
    //private var previewingController: UIViewControllerPreviewing
    private lazy var tapRecogniser = UITapGestureRecognizer(target: self, action: #selector(onClickEditAction))
    
    @IBOutlet weak var BtnEdit: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var BtnScan: UIButton!
    @IBOutlet weak var lblHeader: UILabel!
    
    // MARK: Init
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    // MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        set(isVisible: false)
        
        self.tapRecogniser.delegate = self
        self.view.addGestureRecognizer(tapRecogniser)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
        self.imageView.image = nil
        self.scannedImage = nil
    }
    
    private func set(isVisible: Bool) {
        imageView.isHidden = !isVisible
        BtnEdit.isHidden = !isVisible
    }

    @IBAction func onClickScanAction(_ sender: UIButton) {
        
        let scanner = ScannerViewController()
        scanner.delegate = self
        navigationController?.pushViewController(scanner, animated: true)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func onClickEditAction(_ sender: UIButton) {
        
        guard let image = self.scannedImage else {
            return
            
        }
        
        let cropViewController = TOCropViewController(image: image)
        cropViewController.delegate = self
        present(cropViewController, animated: true)
    }
}

extension ViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard scannedImage != nil else {
            return false
        }
        
        return imageView.bounds.contains(self.view.convert(tapRecogniser.location(in: self.view), to: imageView))
    }
}

extension ViewController: ScannerViewControllerDelegate {
    func scanner(_ scanner: ScannerViewController,
                 didCaptureImage image: UIImage) {
        
        self.scannedImage = image.noir
        navigationController?.popViewController(animated: true)
    }
}

extension ViewController: TOCropViewControllerDelegate {
    func cropViewController(_ cropViewController: TOCropViewController,
                            didCropToImage image: UIImage,
                            rect cropRect: CGRect,
                            angle: Int) {
        
        self.scannedImage = image.noir
        cropViewController.dismiss(animated: true, completion: nil)
    }
}

extension UIImage {
    var noir: UIImage? {
        let context = CIContext(options: nil)
        guard let currentFilter = CIFilter(name: "CIPhotoEffectNoir") else { return nil }
        currentFilter.setValue(CIImage(image: self), forKey: kCIInputImageKey)
        if let output = currentFilter.outputImage,
            let cgImage = context.createCGImage(output, from: output.extent) {
            return UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)
        }
        return nil
    }
}

