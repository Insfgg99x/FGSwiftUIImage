//
//  ContentView.swift
//  FGSwiftUIImage
//
//  Created by xgf on 2020/1/9.
//  Copyright © 2020 xgf. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        FGSwiftUIImage("http://ww1.sinaimg.cn/large/0065oQSqly1ft3fna1ef9j30s210skgd.jpg")
            .placeholder {
                Image(fgImage: FGImage.init(named: "1")!)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
