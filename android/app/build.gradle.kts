plugins {
    id("com.android.application")
    id("kotlin-android")
    // الـ Flutter Gradle Plugin لازم يفضل هنا
    id("dev.flutter.flutter-gradle-plugin")
    // سطر الفايربيز هنا صح ومن غير تكرار تحت
    id("com.google.gms.google-services") version "4.4.1" apply false
}

android {
    namespace = "com.example.aqaarak"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.example.aqaarak"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

