//
//  ContentView.swift
//  ToDoList
//
//  Created by Scholar on 7/18/23.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var context
    @State private var showNewTask = false
    @FetchRequest(
        entity: ToDo.entity(), sortDescriptors: [ NSSortDescriptor(keyPath: \ToDo.id, ascending: false) ])
    
    var toDoItems: FetchedResults<ToDo>
    var body: some View {
        ZStack {
            Color(hex: "F6EFE8")
                .ignoresSafeArea()
            VStack {
                HStack{
                    Text("To-Do List")
                        .font(.system(size: 50))
                        .fontWeight(.medium)
                        .foregroundColor(Color(hex: "8b9475"))
                        .shadow(radius: 1)
                    Spacer()
                    
                    Button(action: {
                        self.showNewTask = true
                    }){
                        Text("+")
                            .fontWeight(.bold)
                            .font(.system(size: 20))
                    }
                    .buttonStyle(.borderedProminent)
                    .cornerRadius(100)
                    .tint(Color(hex:"8b9475"))
                    .controlSize(.regular)
                    .shadow(radius: 1)
                }
                .padding()
                Spacer()
                List {
                    ForEach (toDoItems) { toDoItem in
                        if toDoItem.isImportant == true {
                            Text("‼️" + (toDoItem.title ?? "No title"))
                        } else {
                            Text(toDoItem.title ?? "No title")
                        }
                        
                    }
                    .onDelete(perform: deleteTask)
                }
                // .listStyle(.plain)
            }
        }
            if showNewTask {
                NewToDoView(showNewTask: $showNewTask, title: "", isImportant: false)
            }
            
        }
        private func deleteTask(offsets: IndexSet) {
            withAnimation {
                offsets.map { toDoItems[$0] }.forEach(context.delete)
                
                do {
                    try context.save()
                } catch {
                    print(error)
                }
            }
        }
        
    }


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Color {
  init(hex: String) {
    let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int: UInt64 = 0
    Scanner(string: hex).scanHexInt64(&int)
    let a, r, g, b: UInt64
    switch hex.count {
    case 3: // RGB (12-bit)
      (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
    case 6: // RGB (24-bit)
      (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
    case 8: // ARGB (32-bit)
      (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
    default:
      (a, r, g, b) = (1, 1, 1, 0)
    }
    self.init(
      .sRGB,
      red: Double(r) / 255,
      green: Double(g) / 255,
      blue: Double(b) / 255,
      opacity: Double(a) / 255
    )
  }
}
