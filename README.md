# DocScanner
This example is about detecting the borders of any document and then capturing the image of the same.

Features 

	⁃	Scanning of documents.
	⁃	Editing scaned image with crop and filter option
	⁃	Save scanned image to your album.
	⁃	Lightweight dependency.

Requirements

Swift 4.0
IOS 10.0+
Xcode 9.x

Installation

To integrate Docscanner into your Xcode project using CocoaPods, specify it in your Podfile:

pod 'DocumentScanner'
pod 'TOCropViewController'
pod 'SwiftLint'

Usage

1)	import this two framework in your viewcontroller
	import DocumentScanner
	import TOCropViewController

2)	Make sure that your view controller conforms to the ScannerViewControllerDelegate and TOCropViewControllerDelegate protocol

class YourViewController: UIViewController,ScannerViewControllerDelegate, TOCropViewControllerDelegate {
}

3)	Implement of delegate function

// this is for scan documents
func scanner(_ scanner: ScannerViewController,
                 didCaptureImage image: UIImage) {
        
        self.scannedImage = image.noir
        navigationController?.popViewController(animated: true)
    }
// this is for crop image
func cropViewController(_ cropViewController: TOCropViewController,
                            didCropToImage image: UIImage,
                            rect cropRect: CGRect,
                            angle: Int) {
        
        self.scannedImage = image.noir
        cropViewController.dismiss(animated: true, completion: nil)
    }

4)	Add extension of UIImage 

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

5)	Add in scan click action 
        let scanner = ScannerViewController()
        scanner.delegate = self
        navigationController?.pushViewController(scanner, animated: true)

6)	Add in crop click action
// pass scanned image
	let cropViewController = TOCropViewController(image: image)
        cropViewController.delegate = self
        present(cropViewController, animated: true)

![alt text](http://dev.acquaintsoft.com/scanner.gif)


Enjoy Scanning!!!
