//
//  TodosListView.swift
//  DailyTodos
//
//  Created by Priyanka Mathur on 05/05/24.
//

import SwiftUI
import SwiftData

struct TodosListView: View {
    
    @Environment (\.modelContext) var context
    @State private var showCreate = false
    @Query private var items: [TodoItemModel]
    
    var body: some View {
        
        NavigationStack {
            List {
                ForEach(items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            
                            if item.isCritical {
                                Image(systemName: "exclamationmark.3")
                                    .symbolVariant(.fill)
                                    .foregroundColor(.red)
                                    .font(.largeTitle)
                                    .bold()
                            }
                            
                            Text(item.title)
                                .font(.largeTitle)
                                .bold()
                            
                            Text("\(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .shortened))")
                                .font(.callout)
                        }
                        
                        Spacer()
                        
                        Button {
                            withAnimation {
                                item.isCompleted.toggle()
                            }
                        } label: {
                            
                            Image(systemName: "checkmark")
                                .symbolVariant(.circle.fill)
                                .foregroundStyle(item.isCompleted ? .green : .gray)
                                .font(.largeTitle)
                        }
                        .buttonStyle(.plain)
                        
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            withAnimation {
                                context.delete(item)
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                                .symbolVariant(.fill)
                        }
                    }
                }
            }
            .navigationTitle("Daily todos")
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        showCreate.toggle()
                    }, label: {
                        Image(uiImage: .add)
                    })
                }
            }
            .sheet(isPresented: $showCreate,
                   content: {
                NavigationStack {
                    GenerateTodosView()
                }
                .presentationDetents([.medium])
            })
            
        }
    }
}

#Preview {
    TodosListView()
}