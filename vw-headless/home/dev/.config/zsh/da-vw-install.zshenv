da/install-vw () {
    set -euxo pipefail

    [[ -a ~/.config/zsh/visualworks.zshenv ]] && return

    sudo apt-get update
    # Can't use uuid-runtime because the 32 & 64 bit versions conflict
    sudo DEBIAN_FRONTEND='noninteractive' apt-get install -y --no-install-recommends -o apt-get::Immediate-Configure=false \
        libx11-6 
    
    mkdir -p ~/visualworks/config/user ~/visualworks/config/common ~/visualworks/desktop

    (
        echo 'export VW_COMMONCONFIG_DIRECTORY=/home/dev/visualworks/config/common'
        echo 'export VW_CONFIG_DIRECTORY=/home/dev/visualworks/config/user'
        echo 'export VW_DESKTOP_DIRECTORY=/home/dev/visualworks/desktop'
        echo 'export VW_HOST_DIRECTORY=/host'
        echo 'export VW_IS_IN_DOCKER=true'
    ) > ~/.config/zsh/visualworks.zshenv
}

da/install-vw32 () {
    set -euxo pipefail

    da/install-vw

    [[ -a ~/.config/zsh/visualworks32.zshenv ]] && return

    sudo dpkg --add-architecture i386
    sudo apt-get update
    # Can't use uuid-runtime because the 32 & 64 bit versions conflict
    sudo DEBIAN_FRONTEND='noninteractive' apt-get install -y --no-install-recommends -o apt-get::Immediate-Configure=false \
       uuid-dev uuid-dev:i386 \
       libx11-6:i386 \
       libncurses5 libncurses5:i386 \
       libaio1 libaio1:i386 \
       libaudit1:i386 \
       libcap-ng0:i386 \
       libpam0g:i386 \
       libxss1 \
       zlib1g:i386 \
       libssl-dev:i386
    touch ~/.config/zsh/visualworks32.zshenv
}


da/install-vw-runtime () {
    set -euxo pipefail
    VWVERSION=$1

    [[ -a ~/.config/zsh/vw-runtime-$VWVERSION.zshenv ]] && return
    da/install-vw
    da/install-vw32
    curl --silent http://files.soops.intern/Software/Cincom/vw$VWVERSION.tar.gz | tar -z --wildcards --directory=/home/dev/visualworks -x \
        'vw'${VWVERSION}'/bin/linuxx86_64/visual' \
        'vw'${VWVERSION}'/bin/linuxx86_64/vwlinuxx86_64*' \
        'vw'${VWVERSION}'/bin/linuxx86_64/tlsPlugin.so' \
        'vw'${VWVERSION}'/bin/linux86/visual' \
        'vw'${VWVERSION}'/bin/linux86/vwlinux86*' \
        'vw'${VWVERSION}'/bin/linux86/tlsPlugin.so'
    touch ~/.config/zsh/vw-runtime-$VWVERSION.zshenv
}

da/install-vw-version () {
    set -euxo pipefail
    VWVERSION=$1

    [[ -a ~/.config/zsh/visualworks-$VWVERSION.zshenv ]] && return
    da/install-vw
    curl --silent http://files.soops.intern/Software/Cincom/vw${VWVERSION}.tar.gz | tar zx --directory=/home/dev/visualworks
    (cd ~/visualworks/vw${VWVERSION} ; rm -rf preview launchpad examples dllcc DotNETConnect seaside wavedev waveserver obsolete *.txt *.log *.pdf)
    touch ~/.config/zsh/visualworks-$VWVERSION.zshenv
}

da/install-vw-7.10.1 () {
    da/install-vw-version 7.10.1
}

da/install-vw-8.3 () {
    da/install-vw-version 8.3
}

da/install-vw-9.1 () {
    da/install-vw-version 9.1
}

da/install-vw-9.1.1 () {
    da/install-vw-version 9.1.1
}

vw/remote-images () {
    set -euxo pipefail

    jq \
        --argjson images91 "$(curl http://files.soops.intern/json/Builds/9.1.1/ 2>/dev/null  | jq '[.[].name | select(endswith("Image"))]')" \
        --argjson images91 "$(curl http://files.soops.intern/json/Builds/9.1/ 2>/dev/null  | jq '[.[].name | select(endswith("Image"))]')" \
        --argjson images83 "$(curl http://files.soops.intern/json/Builds/8.3/ 2>/dev/null  | jq '[.[].name | select(endswith("Image"))]')" \
        --argjson images7101 "$(curl http://files.soops.intern/json/Builds/7.10.1/ 2>/dev/null  | jq '[.[].name | select(endswith("Image"))]')" \
        -n '[($images91 | .[] | "9.1.1/" + .) , ($images91 | .[] | "9.1/" + .) , ($images83 | .[] | "8.3/" + .) , ($images7101 | .[] | "7.10.1/" + .)]'
}

vw/remote-image-versions () {
    set -euxo pipefail

    IMAGE=$1
    echo -n '{ "name": "'$IMAGE'", "versions": '
    curl http://files.soops.intern/json/Builds/$IMAGE/ 2>/dev/null | jq '[.[].name | select(contains("TERMINATED") | not)]'
    echo '}'
}

vw/install-image-version () {
    set -euxo pipefail

    IMAGE=$1
    VERSION=$2
    DIR=~/visualworks/images/$IMAGE.image/$VERSION.version
    rm -rf ${DIR}.tmp
    mkdir -p ${DIR}.tmp
    wget -nv -m -np -nH --reject-regex '.*/\?.*' --cut-dirs 4 -P ${DIR}.tmp http://files.soops.intern/Builds/$IMAGE/$VERSION/
    rm -rf ${DIR}
    mkdir -p ${DIR}
    mv ${DIR}.tmp/*/* ${DIR}
    rm -rf ${DIR}.tmp
    find $DIR -name 'index.html*' -exec rm {} \;
}

vw/install-runtime-image-version32 () {
    set -euxo pipefail

    IMAGE=$1
    VERSION=$2
    VWVERSION=$3
    DIR=~/work
    wget -nv -m -np -nH --reject-regex '.*/\?.*' --cut-dirs 5 -P ${DIR} http://files.soops.intern/Builds/$VWVERSION/$IMAGE/$VERSION/$IMAGE/runtime.im
}

vw/install-runtime-image-version64 () {
    set -euxo pipefail

    IMAGE=$1
    VERSION=$2
    VWVERSION=$3
    DIR=~/work
    wget -nv -m -np -nH --reject-regex '.*/\?.*' --cut-dirs 5 -P ${DIR} http://files.soops.intern/Builds/$VWVERSION/$IMAGE/$VERSION/$IMAGE/runtime64.im
}

vw/install-cached-image-version () {
    set -euxo pipefail

    IMAGE=$1
    VERSION=$2
    DIR=~/visualworks/images/${IMAGE}.image/${VERSION}.version
    ARTIFACTORY=http://artifactory.soops.intern/artifactory
    ARTIFACT_PATH=vw-images/soops/${IMAGE}/${VERSION}.tar.gz
    BUILD_USER=build:APB3J2hkf9LDaw6r
    if [ "null" = $(curl -s -u${BUILD_USER} ${ARTIFACTORY}/api/storage/${ARTIFACT_PATH} | jq '.path') ] ; then
        echo "Get image from build directory"
        vw/install-image-version ${IMAGE} ${VERSION} 2> /dev/null
        pushd ${DIR}
        tar -zcf ~/image.tar.gz *
        popd
        echo "Put image into artifactory"
        curl -s -u${BUILD_USER} -T ~/image.tar.gz ${ARTIFACTORY}/${ARTIFACT_PATH}
        rm ~/image.tar.gz
    else
        echo "Get image from artifactory"
        mkdir -p ${DIR}
        curl -s -u${BUILD_USER} ${ARTIFACTORY}/${ARTIFACT_PATH} | tar -zxf - -C ${DIR}
    fi
}

vw/installed-images-and-versions () {
    set -euxo pipefail

    cd ~/visualworks/images
    for DIR in */*.image ; do
        echo '{ "name": "'${DIR:r}'", "versions": '
        DIRS=($DIR/*.version)
        print -f '"%s"\n' ${DIRS:t:r} | jq -s '.'
        echo "}"
    done | jq -s '.'
}
