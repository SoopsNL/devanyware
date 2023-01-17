vw/run-image-version () {
    set -euxo pipefail

    IMAGE=$1
    VERSION=$2
    shift ; shift
    VISUALWORKS=/home/dev/visualworks/vw${IMAGE%/*}
    DIR=/home/dev/visualworks/images/$IMAGE.image/$VERSION.version
    cd $DIR && VISUALWORKS=$VISUALWORKS $VISUALWORKS/bin/linux86/visual -m7 1m *.im $*
}

vw/run-image-version64 () {
    set -euxo pipefail

    IMAGE=$1
    VERSION=$2
    shift ; shift
    VISUALWORKS=/home/dev/visualworks/vw${IMAGE%/*}
    DIR=/home/dev/visualworks/images/$IMAGE.image/$VERSION.version
    cd $DIR && VISUALWORKS=$VISUALWORKS $VISUALWORKS/bin/linuxx86_64/visual -m7 1m *.im $*
}

vw/run-image-version-headless () {
    set -euxo pipefail

    VERSION=$1
    shift 
    VISUALWORKS=/home/dev/visualworks/vw${VERSION}
    DIR=/home/dev/work
    cd $DIR && exec $VISUALWORKS/bin/linux86/visual -m7 1m runtime.im $*
}

vw/run-image-version64-headless () {
    set -euxo pipefail

    VERSION=$1
    shift
    VISUALWORKS=/home/dev/visualworks/vw${VERSION}
    DIR=/home/dev/work
    cd $DIR && exec $VISUALWORKS/bin/linuxx86_64/visual -m7 1m runtime.im $*
}
