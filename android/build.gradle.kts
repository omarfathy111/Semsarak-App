plugins {
    // سبنا دول من غير إصدار (version) عشان Gradle يقرا النسخة الحديثة (8.11.1) اللي موجودة في الـ Classpath من غير خناق
    id("com.android.application") apply false
    id("com.android.library") apply false
    id("org.jetbrains.kotlin.android") apply false
    
    // سبنا الفايربيز بالـ version بتاعه عادي
    id("com.google.gms.google-services") version "4.4.1" apply false
}
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}