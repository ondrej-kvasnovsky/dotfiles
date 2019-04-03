#!/bin/sh
  
gh_help(){
    echo "Usage: gh <subcommand> [options]\n"
    echo "Subcommands:"
    echo "    browse   Open a GitHub project page in the default browser"
    echo "    cd       Go to the directory of the specified repository"
    echo "    clone    Clone a remote repository"
    echo "    uf       Updates master from upstream and pushes it to fork"
    echo ""
    echo "For help with each subcommand run:"
    echo "gh <subcommand> -h|--help"
    echo ""
}
  
gh_browse() {
    open `git remote -v | awk '/fetch/{print $2}' | sed -Ee 's#(git@|git://)#http://#' -e 's@com:@com/@'`| head -n1
}
  
gh_clone() {
    git clone "ssh://git@github.com/$1.git" ~/Projects/github/$1
    gh_cd "$1"

    REPO=$(echo "$1" | cut -d '/' -f 2)
    POSSIBLE_FORK="ssh://git@github.com/$GH_USER/$REPO.git"
    git ls-remote "$POSSIBLE_FORK" --exit-code &> /dev/null
    if [ $? = 0 ]; then
        echo "Fork found. Origin will be $POSSIBLE_FORK"
        git remote rename origin upstream
        git remote add origin $POSSIBLE_FORK
    else
        echo "No fork found."
    fi
}

gh_uf() {
    echo ‘git checkout master’
    git checkout master
    echo ‘git fetch upstream’
    git fetch upstream
    echo ‘git merge upstream/master’
    git merge upstream/master
    echo ‘git push origin master’
    git push origin master
}

gh_cd() {
    cd ~/Projects/github/$1
}

gh() {
    subcommand=$1
    case $subcommand in
        "" | "-h" | "--help")
            gh_help
            ;;
        *)
            shift
            gh_${subcommand} $@
            if [ $? = 127 ]; then
                echo "Error: '$subcommand' is not a known subcommand." >&2
                echo "       Run 'ghs --help' for a list of known subcommands." >&2
                return 1
            fi
            ;;
    esac
}

compdef '_files -W ~/Projects/github' gh
