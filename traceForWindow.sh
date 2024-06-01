cwd = `pwd`
osname = `uname -o`
if ${osname,,} != "mysys"; then
    printf "Please use this scrip in windows OS only.\n" >&2
    exit 1
fi
function installPhp() {
    echo "Installing Php..."
    
}
function checkDepencies() {
    if ! hash php >/dev/null 2>&1; then
        installPhp || print "Error: while installing dependencies\n"
    fi

}