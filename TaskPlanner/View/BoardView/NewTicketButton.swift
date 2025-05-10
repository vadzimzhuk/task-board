//
//  NewTicketButton.swift
//  TaskPlanner
//
//  Created by Vadim Zhuk on 09/05/2025.
//

import SwiftUI

struct NewTicketButton: View {
    @Binding var createNewTask: Bool
    
    var body: some View {
        ZStack {
//                Rectangle()
//                    .stroke(Color.black, lineWidth: 1)
                Button(action: {
                    createNewTask = true
                }, label: {
                    Image(systemName: "plus")
                        .foregroundColor(.primary)
                })
        }
    }
}

#Preview {
    NewTicketButton(createNewTask: .constant(false))
}
