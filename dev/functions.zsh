function gradleDebug() {
    gw -Dorg.gradle.debug=true --no-daemon "$@"
}

function gradleUserHomeLocal() {
    GRADLE_USER_HOME="$(pwd)/.gradle" gw "$@"
}

# Useful for profiling the Gradle launcher and adhoc profiling

function gradleYk() {
    GRADLE_OPTS="-agentpath:/Applications/YourKit.app/Contents/Resources/bin/mac/libyjpagent.jnilib" gw --no-daemon "$@"
}

function gradleYkSample() {
    GRADLE_OPTS="-agentpath:/Applications/YourKit.app/Contents/Resources/bin/mac/libyjpagent.jnilib=sampling,probe_disable=*,onexit=snapshot" gw --no-daemon "$@"
}

function gradleYkAlloc() {
    GRADLE_OPTS="-agentpath:/Applications/YourKit.app/Contents/Resources/bin/mac/libyjpagent.jnilib=alloceach=10,allocsizelimit=4096,onexit=snapshot" gw --no-daemon "$@"
}

function gradleYkAllocCount() {
    GRADLE_OPTS="-agentpath:/Applications/YourKit.app/Contents/Resources/bin/mac/libyjpagent.jnilib=alloc_object_counting,onexit=snapshot" gw --no-daemon "$@"
}