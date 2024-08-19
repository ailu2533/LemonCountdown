//
//  LemonEventApp.swift
//  LemonEvent
//
//  Created by ailu on 2024/4/18.
//

import ConcentricOnboarding
import CoreText
import Defaults
import LemonCountdownModel
import LemonUtils
import RevenueCat
import RevenueCatUI
import Shift
import SwiftData
import SwiftUI
import TipKit

@main
struct LemonEventApp: App {
    var container = ModelUtilities.getModelContainer([EventModel.self, EventBackupModel.self, Tag.self, WidgetTemplateModel.self], isStoredInMemoryOnly: false)
    var vm: ViewModel

    @Default(.shouldShowOnboarding) var shouldShowOnboarding

    init() {
        vm = ViewModel(modelContext: container.mainContext)
        Shift.configureWithAppName(String(localized: "事件"))

        try? Tips.configure()

//        Purchases.logLevel = .debug
//        Purchases.configure(withAPIKey: "appl_qRUBuhHdimQjyLOeYgEfYEBYewR")
//        Purchases.configure(with: .init(withAPIKey: "appl_qRUBuhHdimQjyLOeYgEfYEBYewR"))
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if shouldShowOnboarding {
                    ConcentricOnboardingView(pageContents: MockData.pages.map { (PageView(showOnborading: $shouldShowOnboarding, page: $0), $0.color) })
                        .duration(1.0)
                        .nextIcon("chevron.forward")
                        .didGoToLastPage {
                            print("Animation Did End")
                        }.overlay(alignment: .topTrailing) {
                            Button(action: {
                                shouldShowOnboarding = false
                            }, label: {
                                Text("跳过")
                            })
                            .buttonStyle(BorderedButtonStyle())
                            .padding()
                        }
                } else {
                    MainView()
                }
            }

            .onAppear {
                loadResources()

                MembershipManager.shared.checkMembershipStatus()

                DispatchQueue.main.async {
                    preloadWidgetTemplates()
                }
            }
        }
        .modelContainer(container)
        .environment(vm)
//        .environment(widgetVm)
    }
}

extension LemonEventApp {
    @MainActor
    func preloadWidgetTemplates() {
        let templates = [
            (String(localized: "小号模板"), "smallTemplateModel.json", WidgetSize.small),
            (String(localized: "中号模板"), "mediumTemplateModel.json", WidgetSize.medium),
            (String(localized: "今天是周五吗"), "small-friday.json", WidgetSize.small),
            (String(localized: "打工人1"), "small-worker.json", WidgetSize.small),
        ]

        templates.forEach { title, path, size in
            preloadWidgetTemplateModel(modelContext: container.mainContext, templateTitle: title, templateDataPath: path, size: size)
        }
    }

    func loadResources() {
        let request = NSBundleResourceRequest(tags: ["sticker", "onboarding", "font", "icon"])

        request.conditionallyBeginAccessingResources { available in
            if available {
                print("Resources already available locally.")
                self.vm.odrRequest = request
                self.loadFonts()
            } else {
                print("Resources not available locally. Beginning to access resources...")
                request.beginAccessingResources { error in
                    if let error {
                        print("Error accessing resources: \(error.localizedDescription)")
                    } else {
                        print("Resources loaded successfully")
                        self.vm.odrRequest = request
                        self.loadFonts()
                    }
                }
            }
        }
    }

    func loadFonts() {
        let fonts = [
            ("ChillRoundFBold", "otf"),
            ("ChillRoundFRegular", "otf"),
        ]
        fonts.forEach { fontName, fontExtension in
            let success = loadFont(fontName: fontName, fontExtension: fontExtension)
            print(success ? "Loaded \(fontName)" : "Failed to load \(fontName)")
        }
    }

    func loadFont(fontName: String, fontExtension: String) -> Bool {
        guard let fontURL = Bundle.main.url(forResource: fontName, withExtension: fontExtension) else {
            print("Failed to find font file.")
            return false
        }

        var error: Unmanaged<CFError>?
        CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, &error)

        if let error {
            let errorDescription = CFErrorCopyDescription(error.takeUnretainedValue())
            print("Failed to load font: \(errorDescription ?? "unknown error" as CFString)")
            return false
        }

        return true
    }
}
