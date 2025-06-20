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
        .library(
            name: "DriveKitVehicleUI",
            targets: ["DriveKitVehicleUI"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/DriveQuantPublic/drivekit-sdk-spm.git",
            exact: "2.17.0-beta1"
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
                .product(name: "DriveKitChallenge", package: "drivekit-sdk-spm"),
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
                .product(name: "DriveKitCore", package: "drivekit-sdk-spm"),
            ],
            path: "DriveKitCommonUI",
            resources: [
                .copy("PrivacyInfo.xcprivacy"),
                .copy("AnalyticsScreenToTagKey.plist"),
                .copy("AnalyticsTags.plist"),
                .process("Graphical/Roboto-Bold.ttf"),
                .process("Graphical/Roboto-Regular.ttf"),
            ],
            linkerSettings: [
                .linkedFramework("CoreText"),
            ]
        ),

        .target(
            name: "DriveKitDriverAchievementUI",
            dependencies: [
                .target(name: "DriveKitDriverAchievementUI-Objc"),
                .target(name: "DriveKitCommonUI"),
                .product(name: "DriveKitDriverAchievement", package: "drivekit-sdk-spm"),
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
                .product(name: "DriveKitDriverData", package: "drivekit-sdk-spm"),
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
                .product(name: "DriveKitDriverData", package: "drivekit-sdk-spm"),
            ],
            path: "DriveKitDriverDataUI",
            exclude: [
                "DKUIDriverDataAutoInit.m",
                "include",
            ],
            resources: [
                .copy("PrivacyInfo.xcprivacy"),
            ],
            linkerSettings: [
                .linkedFramework("CoreLocation"),
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
                .product(name: "DriveKitCore", package: "drivekit-sdk-spm"),
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
                .product(name: "DriveKitTripAnalysis", package: "drivekit-sdk-spm"),
                .product(name: "WARangeSlider", package: "RangeSlider"),
            ],
            path: "DriveKitTripAnalysisUI",
            exclude: [
                "DKUITripAnalysisAutoInit.m",
                "include",
            ],
            resources: [
                .copy("PrivacyInfo.xcprivacy"),
            ],
            linkerSettings: [
                .linkedFramework("CoreLocation"),
            ]
        ),
        .target(
            name: "DriveKitTripAnalysisUI-Objc",
            path: "DriveKitTripAnalysisUI",
            sources: ["DKUITripAnalysisAutoInit.m"]
        ),

        .target(
            name: "DriveKitVehicleUI",
            dependencies: [
                .target(name: "DriveKitVehicleUI-Objc"),
                .target(name: "DriveKitCommonUI"),
                .product(name: "DriveKitTripAnalysis", package: "drivekit-sdk-spm"),
                .product(name: "DriveKitVehicle", package: "drivekit-sdk-spm"),
            ],
            path: "DriveKitVehicleUI",
            exclude: [
                "DKUIVehicleAutoInit.m",
                "include",
            ],
            resources: [
                .copy("PrivacyInfo.xcprivacy"),
            ],
            linkerSettings: [
                .linkedFramework("CoreLocation"),
            ]
        ),
        .target(
            name: "DriveKitVehicleUI-Objc",
            path: "DriveKitVehicleUI",
            sources: ["DKUIVehicleAutoInit.m"]
        ),
    ]
)
