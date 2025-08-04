#!/bin/bash

echo "---------------------------------------------------"
echo "Android Project Folder Structure Creator (CLI)"
echo "---------------------------------------------------"

# --- 1. Get Project Name and Package Name ---
read -p "Enter your project name (e.g., MyAwesomeApp): " PROJECT_NAME
if [ -z "$PROJECT_NAME" ]; then
    echo "Project name cannot be empty. Exiting."
    exit 1
fi

read -p "Enter your package name (e.g., com.example.myapp): " PACKAGE_NAME
if [ -z "$PACKAGE_NAME" ]; then
    echo "Package name cannot be empty. Exiting."
    exit 1
fi

# Convert package name to directory path (e.g., com.example.myapp -> com/example/myapp)
PACKAGE_DIR=$(echo "$PACKAGE_NAME" | tr '.' '/')

echo ""
echo "Creating project: $PROJECT_NAME"
echo "With package: $PACKAGE_NAME"
echo "---------------------------------------------------"

# --- 2. Create Main Project Directory ---
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME" || { echo "Failed to enter project directory. Exiting."; exit 1; }

# --- 3. Create App Module Directory Structure ---
mkdir -p app/src/main/java/"$PACKAGE_DIR"
mkdir -p app/src/main/res/{drawable,layout,mipmap,values,xml} # Common resource types
mkdir -p app/libs # For external JARs
mkdir -p gradle/wrapper

# --- 4. Create Placeholder Files ---

# settings.gradle
cat << EOF > settings.gradle
include ':app'
EOF

# gradle.properties
cat << EOF > gradle.properties
# Project-wide Gradle settings.

# IDE (e.g. Android Studio) users:
# Gradle settings configured through the IDE will override any settings specified in this file.
# For more details on Gradle settings, see the Gradle User Manual.
# https://docs.gradle.org/current/userguide/userguide.html#gradle_properties

# Enable AndroidX for this project.
android.useAndroidX=true

# The errorprone plugin is not compatible with Java 9 or higher.
# To disable it, uncomment the following line:
# errorprone.disable=true

# Specifies the JVM arguments used for the daemon process.
# The setting is particularly useful for tweaking memory settings.
# Default value: null
# org.gradle.jvmargs=-Xmx2048m -Dfile.encoding=UTF-8

# When configured, Gradle will run in incubating parallel mode.
# This option should only be used with projects that are designed for it.
# org.gradle.parallel=true

# Enables new incubating features.
# org.gradle.configureondemand=true

# Enable the configuration cache.
# org.gradle.configuration-cache=true
EOF

# build.gradle (Project Level)
cat << EOF > build.gradle
// Top-level build file where you can add configuration options common to all sub-projects/modules.
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // Android Gradle Plugin (AGP) version compatible with Gradle 8.x
        classpath 'com.android.tools.build:gradle:8.2.2'
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

tasks.register('clean', Delete) {
    delete rootProject.buildDir
}
EOF

# app/build.gradle (Module Level)
cat << EOF > app/build.gradle
plugins {
    id 'com.android.application'
}

android {
    namespace '$PACKAGE_NAME'
    compileSdk 34

    defaultConfig {
        applicationId "$PACKAGE_NAME"
        minSdk 21
        targetSdk 34
        versionCode 1
        versionName "1.0"
        testInstrumentationRunner "androidx.test.runner.AndroidJUnitRunner"
    }

    buildTypes {
        release {
            minifyEnabled false
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_17
        targetCompatibility JavaVersion.VERSION_17
    }

    buildToolsVersion "34.0.0"
}

dependencies {
    implementation 'androidx.appcompat:appcompat:1.6.1'
    implementation 'com.google.android.material:material:1.12.0'
    implementation 'androidx.constraintlayout:constraintlayout:2.1.4'

    testImplementation 'junit:junit:4.13.2'
    androidTestImplementation 'androidx.test.ext:junit:1.1.5'
    androidTestImplementation 'androidx.test.espresso:espresso-core:3.5.1'
}
EOF

# AndroidManifest.xml
cat << EOF > app/src/main/AndroidManifest.xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <application
        android:allowBackup="true"
        android:label="@string/app_name"
        android:supportsRtl="true"
        android:theme="@style/Theme.MyAndroidApp">
        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
    </application>

</manifest>
EOF

# MainActivity.java
cat << EOF > app/src/main/java/"$PACKAGE_DIR"/MainActivity.java
package $PACKAGE_NAME;

import android.os.Bundle;
import androidx.appcompat.app.AppCompatActivity;
import android.widget.TextView;
import android.widget.Toast;
import android.view.View;
import android.widget.Button;


public class MainActivity extends AppCompatActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main); // Make sure activity_main.xml exists

        TextView myTextView = findViewById(R.id.myTextView);
        Button myButton = findViewById(R.id.myButton);

        myButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Toast.makeText(MainActivity.this, "Button Clicked!", Toast.LENGTH_SHORT).show();
            }
        });
    }
}
EOF

# activity_main.xml (basic LinearLayout)
cat << EOF > app/src/main/res/layout/activity_main.xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="vertical"
    android:gravity="center_horizontal"
    android:padding="16dp">

    <TextView
        android:id="@+id/myTextView"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="@string/hello_message"
        android:textSize="24sp"
        android:textColor="@color/text_color"
        android:layout_marginBottom="24dp" />

    <Button
        android:id="@+id/myButton"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="@string/click_me_button"
        android:backgroundTint="@color/button_background"
        android:textColor="@color/white"
        android:paddingStart="32dp"
        android:paddingEnd="32dp"
        android:paddingTop="12dp"
        android:paddingBottom="12dp" />

</LinearLayout>
EOF

# strings.xml
cat << EOF > app/src/main/res/values/strings.xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">$PROJECT_NAME</string>
    <string name="hello_message">Hello from CLI Android!</string>
    <string name="click_me_button">CLI Button</string>
</resources>
EOF

# colors.xml
cat << EOF > app/src/main/res/values/colors.xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="purple_200">#FFBB86FC</color>
    <color name="purple_500">#FF6200EE</color>
    <color name="purple_700">#FF3700B3</color>
    <color name="teal_200">#FF03DAC5</color>
    <color name="teal_700">#FF018786</color>
    <color name="black">#FF000000</color>
    <color name="white">#FFFFFFFF</color>
    <color name="text_color">#FF000000</color>
    <color name="button_background">#FF6200EE</color>
</resources>
EOF

# themes.xml
cat << EOF > app/src/main/res/values/themes.xml
<?xml version="1.0" encoding="utf-8"?>
<resources xmlns:tools="http://schemas.android.com/tools">
    <!-- Base application theme. -->
    <style name="Theme.MyAndroidApp" parent="Theme.MaterialComponents.DayNight.DarkActionBar">
        <!-- Primary brand color. -->
        <item name="colorPrimary">@color/purple_500</item>
        <item name="colorPrimaryVariant">@color/purple_700</item>
        <item name="colorOnPrimary">@color/white</item>
        <!-- Secondary brand color. -->
        <item name="colorSecondary">@color/teal_200</item>
        <item name="colorSecondaryVariant">@color/teal_700</item>
        <item name="colorOnSecondary">@color/black</item>
        <!-- Status bar color. -->
        <item name="android:statusBarColor" tools:targetApi="l">?attr/colorPrimaryVariant</item>
        <!-- Customize your theme here. -->
    </style>
</resources>
EOF

# themes.xml (for night mode - minimal for now)
mkdir -p app/src/main/res/values-night
cat << EOF > app/src/main/res/values-night/themes.xml
<?xml version="1.0" encoding="utf-8"?>
<resources xmlns:tools="http://schemas.android.com/tools">
    <!-- Base application theme for night mode. -->
    <style name="Theme.MyAndroidApp" parent="Theme.MaterialComponents.DayNight.DarkActionBar">
        <!-- Primary brand color. -->
        <item name="colorPrimary">@color/purple_200</item>
        <item name="colorPrimaryVariant">@color/purple_700</item>
        <item name="colorOnPrimary">@color/black</item>
        <!-- Secondary brand color. -->
        <item name="colorSecondary">@color/teal_200</item>
        <item name="colorSecondaryVariant">@color/teal_200</item>
        <item name="colorOnSecondary">@color/black</item>
        <!-- Status bar color. -->
        <item name="android:statusBarColor" tools:targetApi="l">?attr/colorPrimaryVariant</item>
        <!-- Customize your theme here. -->
    </style>
</resources>
EOF

# Placeholder for ProGuard rules (empty)
cat << EOF > proguard-rules.pro
# Add project specific ProGuard rules here.
# By default, the flags in progurad-android-optimize.txt are applied.
# You can remove the junk from your application by uncommenting this line:
# -dontwarn android.webkit.WebView
EOF


# --- 5. Download Gradle Wrapper (if not present) and Make Executable ---
# This part requires 'wget' or 'curl' and a working internet connection.
# It downloads a specific Gradle distribution and configures the wrapper.
# You can manually download and place it if preferred.

GRADLE_VERSION="8.1.1" # A common stable version for AGP 8.2.2
#GRADLE_ZIP="gradle-$GRADLE_VERSION-bin.zip"
#GRADLE_URL="https://services.gradle.org/distributions/$GRADLE_ZIP"

#echo "Downloading Gradle Wrapper distribution ($GRADLE_VERSION)..."
#wget -q --show-progress "$GRADLE_URL" -O "$GRADLE_ZIP"

#if [ $? -ne 0 ]; then
#    echo "Failed to download Gradle distribution. Please check your internet connection or try manually downloading from $GRADLE_URL"
#    echo "You might need to place $GRADLE_ZIP in the project root and run 'unzip $GRADLE_ZIP -d .' then 'mv gradle-$GRADLE_VERSION gradle' manually."
#    exit 1
#fi

#unzip -q "$GRADLE_ZIP" -d .
#mv "gradle-$GRADLE_VERSION" gradle
#rm "$GRADLE_ZIP"

# Create gradlew and gradlew.bat (minimal versions)
# These are usually generated by `gradle wrapper` but we'll create them manually for a fully offline setup.
echo "gradle wrapper --gradle-version 8.14.3"
gradle wrapper --gradle-version 8.14.3

cat << EOF > b
#!/bin/bash

echo "Building the Debug App:"
echo "gradle assembleDebug"
gradle assembleDebug
echo "Build Successfull!!"
echo "---------------------------------------------"
echo "Install Build app:"
echo "adb install app/build/outputs/apk/debug/app-debug.apk"
adb install app/build/outputs/apk/debug/app-debug.apk
echo "Install Successfull!"
echo "---------------------------------------------"
sleep 3
echo "Launch Build app:"
echo "adb shell am start -n $PACKAGE_NAME/.MainActivity"
adb shell am start -n $PACKAGE_NAME/.MainActivity
echo "Launch Successfull!"
echo "---------------------------------------------"
sleep 2
echo "Listen to logs:"
echo "adb logcat"
adb logcat
echo "Exiting logs..."
echo "---------------------------------------------"
EOF
chmod +x b

cat << EOF > delete
#!/bin/bash
echo "uninstall $PACKAGE_NAME"
adb uninstall $PACKAGE_NAME
EOF
chmod +x delete
echo "cd $PROJECT_NAME"
echo "created build and delete scripts."
echo "run them to build debug app."
