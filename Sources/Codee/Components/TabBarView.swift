//
//  TabBarView.swift
//  Codee
//
//  Created by Eryk on 09/09/2025.
//

import SwiftUI

// Protokół do definiowania własnych typów zakładek
public protocol TabItemRepresentable: Hashable {
    var id: String { get }
    var icon: String { get }
    var title: String { get }
}

// Struktura do zarządzania stanem TabBar
public class TabBarManager<T: TabItemRepresentable>: ObservableObject {
    @Published var selectedTab: T
    private var tabs: [T]
    
    init(tabs: [T], initialTab: T? = nil) {
        self.tabs = tabs
        self.selectedTab = initialTab ?? tabs.first!
    }
    
    var availableTabs: [T] {
        return tabs
    }
}

public enum TabBarStyle {
    case primary
    case secondary
}

// Konfigurowalna struktura widoku TabBar
public struct TabBarView<T: TabItemRepresentable>: View {
    @ObservedObject public var manager: TabBarManager<T>
    public var onTabSelected: ((T) -> Void)? = nil
    public var style: TabBarStyle
    
    public var body: some View {
        HStack(spacing: 12) {
            ForEach(manager.availableTabs, id: \.self) { tab in
                tabItemView(for: tab)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(8)
        .background(backgroundColor)
        .cornerRadius(24)
    }
    
    @ViewBuilder
    private func tabItemView(for tab: T) -> some View {
        SwiftUI.Button(action: {
            withAnimation(.easeInOut) {
                manager.selectedTab = tab
                onTabSelected?(tab)
            }
        }) {
            HStack(spacing: 12) {
                Text(tab.title)
                    .fontWeight(.medium)
                    .foregroundColor(manager.selectedTab == tab ? selectedTextColor : textColor)
            }
            .padding(12)
            .frame(idealWidth: .infinity, maxWidth: .infinity)
            .background(manager.selectedTab == tab ? selectedBackgroundColor : .clear)
            .cornerRadius(20)
        }
    }
    
    var selectedTextColor: Color {
        switch style {
        case .primary:
            return .primary
        case .secondary:
            return .white
        }
    }
    
    var textColor: Color {
        switch style {
        case .primary:
            return .gray
        case .secondary:
            return .white.opacity(0.4)
        }
    }
    
    var selectedBackgroundColor: Color {
        switch style {
        case .primary:
            return .gray.opacity(0.12)
        case .secondary:
            return .white.opacity(0.2)
        }
    }
    
    var backgroundColor: Color {
        switch style {
        case .primary:
            return .gray.opacity(0.12)
        case .secondary:
            return .black.opacity(0.4)
        }
    }
}
