// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "DriveKitUI",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "DriveKitChallengeUI",
            targets: ["DriveKitChallengeUI"]
        ),
        .library(
            name: "DriveKitCommonUI",
            targets: ["DriveKitCommonUI"]
        ),
        .library(
            name: "DriveKitDriverAchievementUI",
            targets: ["DriveKitDriverAchievementUI"]
        ),
        .library(
            name: "DriveKitDriverDataTimelineUI",
            targets: ["DriveKitDriverDataTimelineUI"]
        ),
        .library(
            name: "DriveKitDriverDataUI",
            targets: ["DriveKitDriverDataUI"]
        ),
        .library(
            name: "DriveKitPermissionsUtilsUI",
            targets: ["DriveKitPermissionsUtilsUI"]
        ),
        .library(
            name: "DriveKitTripAnalysisUI",
            targets: ["DriveKitTripAnalysisUI"]
        ),
    ],
    dependencies: [
        .package(
            name: "DriveKit",
            url: "https://github.com/DriveQuantPublic/drivekit-sdk-spm.git",
            from: "2.0.0"
        ),
        .package(
            url: "https://github.com/danielgindi/Charts.git",
            from: "5.1.0"
        ),
        .package(
            url: "https://github.com/warchimede/RangeSlider.git",
            from: "1.2.0"
        ),
    ],
    targets: [
        .target(
            name: "DriveKitChallengeUI",
            dependencies: [
                .target(name: "DriveKitChallengeUI-Objc"),
                .target(name: "DriveKitCommonUI"),
                .product(name: "DriveKitChallenge", package: "DriveKit"),
            ],
            path: "DriveKitChallengeUI",
            exclude: [
                "DKUIChallengeAutoInit.m",
                "include",
            ],
            resources: [
                .copy("PrivacyInfo.xcprivacy"),
            ]
        ),
        .target(
            name: "DriveKitChallengeUI-Objc",
            path: "DriveKitChallengeUI",
            sources: ["DKUIChallengeAutoInit.m"]
        ),

        .target(
            name: "DriveKitCommonUI",
            dependencies: [
                .product(name: "DriveKitCore", package: "DriveKit"),
            ],
            path: "DriveKitCommonUI",
            resources: [
                .copy("PrivacyInfo.xcprivacy"),
                .copy("AnalyticsScreenToTagKey.plist"),
                .copy("AnalyticsTags.plist"),
            ]
        ),

        .target(
            name: "DriveKitDriverAchievementUI",
            dependencies: [
                .target(name: "DriveKitDriverAchievementUI-Objc"),
                .target(name: "DriveKitCommonUI"),
                .product(name: "DriveKitDriverAchievement", package: "DriveKit"),
            ],
            path: "DriveKitDriverAchievementUI",
            exclude: [
                "DKUIDriverAchievementAutoInit.m",
                "include",
            ],
            resources: [
                .copy("PrivacyInfo.xcprivacy"),
            ]
        ),
        .target(
            name: "DriveKitDriverAchievementUI-Objc",
            path: "DriveKitDriverAchievementUI",
            sources: ["DKUIDriverAchievementAutoInit.m"]
        ),

        .target(
            name: "DriveKitDriverDataTimelineUI",
            dependencies: [
                .target(name: "DriveKitDriverDataTimelineUI-Objc"),
                .target(name: "DriveKitCommonUI"),
                .product(name: "DriveKitDriverData", package: "DriveKit"),
                .product(name: "DGCharts", package: "Charts"),
            ],
            path: "DriveKitDriverDataTimelineUI",
            exclude: [
                "DKUIDriverDataTimelineAutoInit.m",
                "include",
            ],
            resources: [
                .copy("PrivacyInfo.xcprivacy"),
            ]
        ),
        .target(
            name: "DriveKitDriverDataTimelineUI-Objc",
            path: "DriveKitDriverDataTimelineUI",
            sources: ["DKUIDriverDataTimelineAutoInit.m"]
        ),

        .target(
            name: "DriveKitDriverDataUI",
            dependencies: [
                .target(name: "DriveKitDriverDataUI-Objc"),
                .target(name: "DriveKitCommonUI"),
                .product(name: "DriveKitDriverData", package: "DriveKit"),
            ],
            path: "DriveKitDriverDataUI",
            exclude: [
                "DKUIDriverDataAutoInit.m",
                "include",
            ],
            resources: [
                .copy("PrivacyInfo.xcprivacy"),
            ]
        ),
        .target(
            name: "DriveKitDriverDataUI-Objc",
            path: "DriveKitDriverDataUI",
            sources: ["DKUIDriverDataAutoInit.m"]
        ),

        .target(
            name: "DriveKitPermissionsUtilsUI",
            dependencies: [
                .target(name: "DriveKitPermissionsUtilsUI-Objc"),
                .target(name: "DriveKitCommonUI"),
                .product(name: "DriveKitCore", package: "DriveKit"),
            ],
            path: "DriveKitPermissionsUtilsUI",
            exclude: [
                "DKUIPermissionsUtilsAutoInit.m",
                "include",
            ],
            resources: [
                .copy("PrivacyInfo.xcprivacy"),
            ]
        ),
        .target(
            name: "DriveKitPermissionsUtilsUI-Objc",
            path: "DriveKitPermissionsUtilsUI",
            sources: ["DKUIPermissionsUtilsAutoInit.m"]
        ),

        .target(
            name: "DriveKitTripAnalysisUI",
            dependencies: [
                .target(name: "DriveKitTripAnalysisUI-Objc"),
                .target(name: "DriveKitCommonUI"),
                .product(name: "DriveKitTripAnalysis", package: "DriveKit"),
                .product(name: "WARangeSlider", package: "RangeSlider"),
            ],
            path: "DriveKitTripAnalysisUI",
            exclude: [
                "DKUITripAnalysisAutoInit.m",
                "include",
            ],
            resources: [
                .copy("PrivacyInfo.xcprivacy"),
            ]
        ),
        .target(
            name: "DriveKitTripAnalysisUI-Objc",
            path: "DriveKitTripAnalysisUI",
            sources: ["DKUITripAnalysisAutoInit.m"]
        ),
    ]
)
