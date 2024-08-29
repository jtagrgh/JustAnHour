//
//  MenuBarStopwatchApp.swift
//  MenuBarStopwatch
//
//  Created by jakob koblinsky on 2024-08-24.
//

import SwiftUI
import Combine

public final class DataModel: ObservableObject {
    @Published var percentOfWhole: CGFloat = 0.0
    @Published var wholesPassed: Int = 0
    @Published var paused: Bool = false
    var cancellable = Set<AnyCancellable>()
    
    init() {
        Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink(receiveValue: { [self] value in
                if !paused {
                    percentOfWhole = (percentOfWhole + 1/3600)
                    if percentOfWhole >= 1 {
                        percentOfWhole -= 1
                        wholesPassed += 1
                    }
                }
            })
            .store(in: &cancellable)
    }

}

struct MenuBarTimer: Scene {
    let eps: Double = 0.001
    @State var colorIndex: Int = 0
    @State var showItem: Bool = false
    @ObservedObject var secondTimer = DataModel()
    
    var body: some Scene {
        MenuBarExtra() {
        } label: {
            let icon = ZStack {
                Circle()
                    .stroke(.white, lineWidth: 15)
                    .opacity(0.2)
                    .frame(width: 100)
                Circle()
                    .trim(from: 0, to: secondTimer.percentOfWhole > 0 ? secondTimer.percentOfWhole : eps)
                    .stroke(.white, style: StrokeStyle(lineWidth: 15, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .frame(width: 100)
                    .padding(.all, 10)
            }
            let renderer = ImageRenderer(content: icon)
            let image: NSImage = {
                let ratio = $0.size.width / $0.size.height
                $0.size.height = 15
                $0.size.width = 15 * ratio
                return $0
            } (renderer.nsImage!)
            
            Image(nsImage: image)
        }
    }
}

@main
struct MenuBarStopwatchApp: App {
    
    var body: some Scene {
        MenuBarTimer()
    }
    
}
