//
//  otpView.swift
//  UProtect
//
//  Created by Simone Sarnataro on 18/05/24.
//

import SwiftUI
import Combine

struct OtpFormFieldView: View {
    
    enum FocusPin {
        case  pinOne, pinTwo, pinThree, pinFour
    }
    
    @FocusState private var pinFocusState : FocusPin?
    @State var pinOne: String = ""
    @State var pinTwo: String = ""
    @State var pinThree: String = ""
    @State var pinFour: String = ""
    
    var body: some View {
        VStack {
            
            Text("Verify your number")
                .font(.title2)
                .fontWeight(.semibold)
            Text("Enter 4 digit code we'll text you")
                .font(.caption)
                .fontWeight(.thin)
                .padding(.top)
            
            HStack(spacing: 15) {
                TextField("", text: $pinOne)
                    .modifier(OtpModifer(pin: $pinOne))
                    .onChange(of: pinOne) { oldVal, newVal in
                        if newVal.count == 1 {
                            pinFocusState = .pinTwo
                        }
                    }
                    .focused($pinFocusState, equals: .pinOne)
                
                TextField("", text: $pinTwo)
                    .modifier(OtpModifer(pin: $pinTwo))
                    .onChange(of: pinTwo) { oldVal, newVal in
                        if newVal.count == 1 {
                            pinFocusState = .pinThree
                        } else if newVal.count == 0 {
                            pinFocusState = .pinOne
                        }
                    }
                    .focused($pinFocusState, equals: .pinTwo)
                
                TextField("", text: $pinThree)
                    .modifier(OtpModifer(pin: $pinThree))
                    .onChange(of: pinThree) { oldVal, newVal in
                        if newVal.count == 1 {
                            pinFocusState = .pinFour
                        } else if newVal.count == 0 {
                            pinFocusState = .pinTwo
                        }
                    }
                    .focused($pinFocusState, equals: .pinThree)
                
                TextField("", text: $pinFour)
                    .modifier(OtpModifer(pin: $pinFour))
                    .onChange(of: pinFour) { oldVal, newVal in
                        if newVal.count == 0 {
                            pinFocusState = .pinThree
                        }
                    }
                    .focused($pinFocusState, equals: .pinFour)
            }.padding(.bottom)
            
            Button(action: {}, label: {
                Spacer()
                Text("Veify")
                    .font(.system(.title3, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                Spacer()
            })
            .padding(15)
            .background(Color.blue)
            .clipShape(Capsule())
            .padding()
        }
        
    }
}

struct OtpModifer: ViewModifier {
    
    @Binding var pin : String
    
    var textLimt = 1
    
    func limitText(_ upper : Int) {
        if pin.count > upper {
            self.pin = String(pin.prefix(upper))
        }
    }
    
    func body(content: Content) -> some View {
        content
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
            .onReceive(Just(pin)) {_ in limitText(textLimt)}
            .frame(width: 45, height: 45)
            .background(Color.red.cornerRadius(5))
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color("blueColor"), lineWidth: 2)
            )
    }
}

struct OtpFormFieldView_Previews: PreviewProvider {
    static var previews: some View {
        OtpFormFieldView()
    }
}
