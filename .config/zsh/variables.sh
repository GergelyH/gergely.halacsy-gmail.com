export VISUAL='nvim'
export EDITOR='nvim'
export ANDROID_SDK_ROOT='/opt/android-sdk'
export PATH=$ANDROID_HOME/emulator:$PATH
export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$PATH
# export PATH=$PATH:$ANDROID_HOME/emulator
# export PATH=$PATH:$ANDROID_HOME/platform-tools/
# export PATH=$PATH:$ANDROID_HOME/tools/bin/
# export PATH=$PATH:$ANDROID_HOME/tools/
#export JAVA_HOME='/usr/lib/jvm/java-8-openjdk'
export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which javac))))
export JAVA_OPTS='-XX:+IgnoreUnrecognizedVMOptions'

export NNN_BMS='d:~/Documents;u:/home/user/Cam Uploads;D:~/Downloads/'
export NNN_SSHFS="sshfs -o follow_symlinks"        # make sshfs follow symlinks on the remote
export NNN_COLORS="2136"                           # use a different color for each context
export NNN_TRASH=1                                 # trash (needs trash-cli) instead of delete
if [ -e /usr/share/terminfo/x/xterm-256color ]; then
        export TERM='xterm-256color'
else
        export TERM='xterm-color'
fi
