//
//  ContentView.swift
//  NuemorphicClock
//
//  Created by Pratik on 31/01/23.
//

import SwiftUI

struct ContentView: View {
    
    let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    @State private var secondAngle: Double = 0
    @State private var minuteAngle: Double = 0
    @State private var hourAngle: Double = 0
    
    private let fullCircleValue: Double = 0.2
    //value = 60 will give you real clock experience
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.bgLight, .bgDark],
                           startPoint: .top,
                           endPoint: .bottom)
            .ignoresSafeArea()
            
            
            VStack {
                VStack(spacing: 0) {
                    Text("Jan")
                        .textCase(.uppercase)
                        .font(.system(size: 13, weight: .medium, design: .monospaced))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .foregroundColor(.bgDark.opacity(0.6))
                    
                    Text("31")
                        .font(.system(size: 34, weight: .medium, design: .monospaced))
                        .foregroundColor(.white)
                    
                }
                Spacer()
            }
            .frame(width: 80)
            .padding(.vertical, 70)
            clockView
            
        }
        .onReceive(timer) { t in
            withAnimation(.linear(duration: 1)) {
                secondAngle += 360 / fullCircleValue
                minuteAngle += 360 / (fullCircleValue*60)
                hourAngle += 360 / (fullCircleValue*60*12)
            }
        }
    }
    
    private var clockView: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20)
                .fill(LinearGradient(colors: [.bgLight, .bgDark],
                                     startPoint: .top,
                                     endPoint: .bottom))
                .blur(radius: 16)
                .shadow(color: .bgLight, radius: 23, x: 0, y: -25)
                .shadow(color: .bgDark, radius: 23, x: 0, y: 25)
                .frame(width: 330, height: 330, alignment: .center)
            
            Circle()
                .fill(LinearGradient(colors: [.bgDark, .bgLight].reversed(),
                                     startPoint: .top,
                                     endPoint: .bottom))
                .blur(radius: 3)
                .shadow(color: .bgLight, radius: 3, x: 0, y: -3)
                .shadow(color: .bgDark, radius: 3, x: 0, y: 3)
                .frame(width: 13, height: 13, alignment: .center)
            
//            handsView
            newHandsView
                .shadow(color: .bgDark, radius: 10, x: 7, y: 10)
                
        }
    }
    
    private var handsView: some View {
        ZStack {
            hourHand
            
            minuteHand
            
            //                secondHand
        }
        .rotationEffect(.degrees(-90))
    }
    
    private var newHandsView: some View {
        Canvas { context, size in
            context.addFilter(.alphaThreshold(min: 0.5, color: .purpleLight))
            context.addFilter(.blur(radius: 2))
            
            context.drawLayer { ctx in
                let hour = ctx.resolveSymbol(id: 1)!
                let minute = ctx.resolveSymbol(id: 2)!
                
                ctx.draw(hour, at: CGPoint(x: size.width/2, y: size.height/2))
                ctx.draw(minute, at: CGPoint(x: size.width/2, y: size.height/2))
            }
        } symbols: {
            hourHand
                .rotationEffect(.degrees(-90))
                .tag(1)
            
            minuteHand
                .rotationEffect(.degrees(-90))
                .tag(2)
        }

    }
    
    private var hourHand: some View {
        Capsule(style: .continuous)
            .fill(LinearGradient(colors: [.purpleDark, .purpleLight], startPoint: .leading, endPoint: .trailing))
            .frame(width: 60, height: 13, alignment: .center)
            .offset(x: 50)
            .rotationEffect(.degrees(hourAngle))
//            .shadow(color: .bgDark, radius: 10, x: -7, y: 5)
    }
    
    private var minuteHand: some View {
        Capsule(style: .continuous)
            .fill(LinearGradient(colors: [.purpleDark, .purpleLight], startPoint: .leading, endPoint: .trailing))
            .frame(width: 70, height: 7, alignment: .center)
            .offset(x: 55)
            .rotationEffect(.degrees(minuteAngle))
//            .shadow(color: .bgDark, radius: 10, x: -7, y: 5)
    }
    
    private var secondHand: some View {
        Capsule(style: .continuous)
            .fill(LinearGradient(colors: [.purpleDark, .purpleLight], startPoint: .leading, endPoint: .trailing))
            .frame(width: 80, height: 4, alignment: .center)
            .offset(x: 60)
            .rotationEffect(.degrees(secondAngle))
            .shadow(color: .bgDark, radius: 5, x: -5, y: 5)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
