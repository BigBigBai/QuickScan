//
//  ARUIView.swift
//  QuickScanSwift
//
//  Created by Eric Li on 2022-03-02.
//  Copyright © 2022 iOS App Templates. All rights reserved.
//
import SwiftUI
import Foundation
import ARKit
struct ARUIView: View {
    @State var isRecording = false
    @State var pushActive = false
    @State var buttonShow = true
    @State var toggledOn = false
    
    @ObservedObject var state: AppState
    
    func toggleFlashLight() {
        if (toggledOn) {
            self.toggledOn = false
        } else {
            self.toggledOn = true
        }
        // Toggle flashlight
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        guard device.hasTorch else { return }
        
        do {
            try device.lockForConfiguration()
            
            if (device.torchMode == AVCaptureDevice.TorchMode.on) {
                device.torchMode = AVCaptureDevice.TorchMode.off
            } else {
                do {
                    try device.setTorchModeOn(level: 1.0)
                } catch {
                    print(error)
                }
            }
            
            device.unlockForConfiguration()
        } catch {
            print(error)
        }
    }
    
    
    let ar = ARView()
    var body: some View {
        NavigationView {
            VStack(spacing: -100) {
                NavigationLink(destination: UploadView(state: state, url: ar.getUrl()),
                               isActive: self.$pushActive) {
                    EmptyView()
                }.hidden()
                ZStack {
                    ar
                    VStack {
                        Spacer()
                        Spacer()
                        VStack {
                            Button(action: {
                                if (self.buttonShow) {
                                    self.buttonShow = false
                                } else {
                                    self.buttonShow = true
                                }
                            }, label: {
                                Text("Tap the screen to create a bounding box.\n Drag the corners of the box to modify size and shape. Tap and drag the box to move it wherever you desire.\n When you are ready, tap the record button and fill the box to complete the recording.\n\n Tap to dismiss")
                                    .foregroundColor(Color.black).multilineTextAlignment(.center)        .font(.system(size: 500))
                                    .minimumScaleFactor(0.01)
                            })
                                .frame(height: 220)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 90, style: .continuous).fill(Color.white)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 90, style: .continuous)
                                        .strokeBorder(Color.blue, lineWidth: 1)
                                )
                                .opacity(self.buttonShow ? 1 : 0)
                        }
                        ZStack {
                            VStack{
                                Circle()
                                    .frame(width: 60, height: 60)
                                    .opacity(0)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: .infinity)
                                            .stroke(Color.white, lineWidth: 5)
                                    )
                                Button(action: {
                                    if (isRecording) {
                                        isRecording = false
                                        ar.stopRecording()
                                        print(ar.getUrl())
                                        self.pushActive = true
                                    } else {
                                        isRecording = ar.startRecording()
                                    }
                                }) {
                                    Text("")
                                        .padding()
                                        .frame(width: 40, height: 40)
                                        .background(RoundedRectangle(cornerRadius: .infinity)
                                                        .foregroundColor(isRecording ? Color.red : Color.white))
                                }
                            }
                            HStack {
                                Circle()
                                    .frame(width: 40, height: 40)
                                    .opacity(0)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: .infinity)
                                            .stroke(Color.white, lineWidth: 5)
                                    )
                                Button(action: {
                                    toggleFlashLight()
                                }, label: {
                                    Text("")
                                        .foregroundColor(Color.black).multilineTextAlignment(.center)        .font(.system(size: 500))
                                        .minimumScaleFactor(0.01)
                                }).padding()
                                    .frame(width: 40, height: 40)
                                    .background(RoundedRectangle(cornerRadius: .infinity)
                                                    .foregroundColor(toggledOn ? Color.red : Color.white))
                            }}
                    }
                }
            }
        }.navigationViewStyle(StackNavigationViewStyle()).navigationBarBackButtonHidden(true).navigationBarHidden(true)
    }
}
