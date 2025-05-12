//
//  ColorPicker.swift
//  TaskPlanner
//
//  Created by Vadim Zhuk on 11/05/2025.
//

import SwiftUI

struct ColorPickerView: View {
    @Binding var selectedColor: Color

    var body: some View {
        VStack(spacing: 20) {
            ColorPicker("Pick a color", selection: $selectedColor)
        }
        .padding()
    }
}

#Preview {
    ColorPickerView(selectedColor: .constant(.blue))
//    RoundedRectangle(cornerRadius: 12)
//        .fill(selectedColor)
//        .frame(height: 100)
//        .overlay(Text("Preview").foregroundColor(.white).bold())
//
//    Text("Selected Color: \(selectedColor.description)")
//        .font(.caption)
}
