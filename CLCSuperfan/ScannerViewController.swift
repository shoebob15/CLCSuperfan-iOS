//
//  ScannerViewController.swift
//  CLCSuperfan
//
//  Created by Brennan Reinhard on 3/12/25.
//


// all code stolen from https://www.hackingwithswift.com/example-code/media/how-to-scan-a-qr-code
import AVFoundation
import UIKit

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var event: Event! = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        captureSession.startRunning()
    }

    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }

        dismiss(animated: true)
    }

    func found(code: String) {
        print(code)
        // TODO: use actual user location
        NetworkManager.shared.request(api: EventAPI.redeem(code: code, id: event.id.uuidString, lat: event.lat, lon: event.lon)) { (result: Result<RedeemResponse, NetworkError>) in
            let success = UIAlertController(title: "Event Redeemed!", message: "Event successfully redeemed. One point added to account!", preferredStyle: .alert)
            
            let failure = UIAlertController(title: "Unable to Redeem", message: "Redemption could not be verified. Try going inside the event geofence or scanning the correct QR code.", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Ok", style: .default) { action in
                self.dismiss(animated: true)
                self.dismiss(animated: true)

            }
            success.addAction(UIAlertAction(title: "Ok", style: .default))
            
            failure.addAction(UIAlertAction(title: "Ok", style: .default))

            
            switch result {
                // TODO: gross code - delegate to function
            case .success(let response):
                if response.success {
                    print("event validated!")
                    AppData.mostRecentScan = Date()
                    UserDefaults.standard.set(AppData.mostRecentScan, forKey: "mostRecentScan")
                    DispatchQueue.main.async {
                        self.present(success, animated: true)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.present(failure, animated: true)
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print("error: \(error)")
                    self.present(failure, animated: true)
                }
            }
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
