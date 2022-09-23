da/install-oracle-client () {
    set -euxo pipefail

    [[ -a ~/.config/zsh/oracle-client.zshenv ]] && return

    sudo dpkg --add-architecture i386
    sudo apt-get update

    sudo zsh -c " \
        mkdir -p /opt/oracle/i86 ; \
        curl --silent http://files.soops.intern/Software/Oracle/instantclient-basic-linux-18.3.0.0.0dbru.tar.gz | tar zx --strip-components=1 --directory=/opt/oracle/i86 ; \
        echo '/opt/oracle/i86' > /etc/ld.so.conf.d/oracle.conf && sudo ldconfig ; \
        echo 'general=(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=oracle)(PORT=1521)))(CONNECT_DATA=(SERVICE_NAME=general)))' > /opt/oracle/i86/network/admin/tnsnames.ora \
    "

    (
        echo 'export ORACLE_HOME=/opt/oracle/i86'
        echo 'export TNS_ADMIN=/opt/oracle'
        echo 'export NLS_LANG=AMERICAN_AMERICA.UTF8'
    ) > ~/.config/zsh/oracle-client.zshenv
}

da/install-oracle-client64 () {
    set -euxo pipefail

    [[ -a ~/.config/zsh/oracle-client64.zshenv ]] && return

    sudo apt-get update

    sudo zsh -c " \
        mkdir -p /opt/oracle/x64 ; \
        curl --silent http://files.soops.intern/Software/Oracle/instantclient-basic-linux.x64-18.3.0.0.0dbru.tar.gz | tar zx --strip-components=1 --directory=/opt/oracle/x64 ; \
        echo '/opt/oracle/x64' > /etc/ld.so.conf.d/oracle.conf && sudo ldconfig ; \
        echo 'general=(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=oracle)(PORT=1521)))(CONNECT_DATA=(SERVICE_NAME=general)))' > /opt/oracle/x64/network/admin/tnsnames.ora \
    "

    (
        echo 'export ORACLE_HOME=/opt/oracle/x64'
        echo 'export TNS_ADMIN=/opt/oracle'
        echo 'export NLS_LANG=AMERICAN_AMERICA.UTF8'
    ) > ~/.config/zsh/oracle-client64.zshenv
}

da/install-sqlite3 () {
    set -euxo pipefail

    [[ -a ~/.config/zsh/sqlite3.zshenv ]] && return

    sudo dpkg --add-architecture i386
    sudo apt-get update

    da/install-c

    # Can't use uuid-runtime because the 32 & 64 bit versions conflict
    DEBIAN_FRONTEND='noninteractive' sudo apt-get install -y --no-install-recommends -o APT::Immediate-Configure=false gcc-multilib
       
    sudo zsh -c " \
        curl --silent https://www.sqlite.org/2021/sqlite-autoconf-3370000.tar.gz | tar zx ; \
        cd sqlite-autoconf-* ; \
        CFLAGS='-m32' ./configure ; \
        make ; \
        make install ; \
        cd .. ; \
        rm -rf sqlite-autoconf-*
    "

    touch ~/.config/zsh/sqlite3.zshenv
}

da/install-postgres-client () {
    set -euxo pipefail

    [[ -a ~/.config/zsh/postgres-client.zshenv ]] && return

    sudo dpkg --add-architecture i386
    sudo apt-get update
    DEBIAN_FRONTEND='noninteractive' sudo apt-get install -y libpq5:i386

    touch ~/.config/zsh/postgres-client.zshenv
}

da/install-postgres-client64 () {
    set -euxo pipefail

    [[ -a ~/.config/zsh/postgres-client64.zshenv ]] && return

    sudo apt-get update
    DEBIAN_FRONTEND='noninteractive' sudo apt-get install -y libpq5

    touch ~/.config/zsh/postgres-client64.zshenv
}

da/install-gemstone-client () {
    set -euxo pipefail

    [[ -a ~/.config/zsh/gemstone-client.zshenv ]] && return

    sudo dpkg --add-architecture i386
    sudo apt-get update

    sudo zsh -c "
        mkdir /gemstone ; \
        curl --silent http://files.soops.intern/Software/Gemstone/GemStone64Bit3.4.2-x86_64.Linux.lib32.tar.gz | tar zx --directory=/gemstone ; \
        echo '/gemstone/lib32' > /etc/ld.so.conf.d/gemstone.conf && ldconfig \
    "

    touch ~/.config/zsh/gemstone-client.zshenv
}

da/install-vw () {
    set -euxo pipefail

    [[ -a ~/.config/zsh/visualworks.zshenv ]] && return

    sudo dpkg --add-architecture i386
    sudo apt-get update
    # Can't use uuid-runtime because the 32 & 64 bit versions conflict
    DEBIAN_FRONTEND='noninteractive' sudo apt-get install -y --no-install-recommends -o APT::Immediate-Configure=false \
       uuid-dev uuid-dev:i386 \
       libx11-6 libx11-6:i386 \
       libncurses5 libncurses5:i386 \
       libxft2 libxft2:i386 \
       libaio1 libaio1:i386 \
       libx11-dev libx11-dev:i386 \
       libaudit1:i386 \
       libcap-ng0:i386 \
       libpam0g:i386 \
       libxss1 \
       libssl-dev:i386

    mkdir -p ~/visualworks/config/user ~/visualworks/config/common ~/visualworks/desktop

    (
        echo 'export VW_COMMONCONFIG_DIRECTORY=/home/dev/visualworks/config/common'
        echo 'export VW_CONFIG_DIRECTORY=/home/dev/visualworks/config/user'
        echo 'export VW_DESKTOP_DIRECTORY=/home/dev/visualworks/desktop'
        echo 'export VW_HOST_DIRECTORY=/host'
        echo 'export VW_IS_IN_DOCKER=true'
    ) > ~/.config/zsh/visualworks.zshenv
}

da/install-vw-7.10.1 () {
    set -euxo pipefail

    [[ -a ~/.config/zsh/visualworks-7.10.1.zshenv ]] && return
    da/install-vw
    curl --silent http://files.soops.intern/Software/Cincom/vw7.10.1.tar.gz | tar zx --directory=/home/dev/visualworks
    (cd ~/visualworks/vw7.10.1 ; rm -rf preview launchpad examples dllcc DotNETConnect seaside wavedev waveserver obsolete *.txt *.log *.pdf)
    touch ~/.config/zsh/visualworks-7.10.1.zshenv
}

da/install-vw-8.3 () {
    set -euxo pipefail

    [[ -a ~/.config/zsh/visualworks-8.3.zshenv ]] && return
    da/install-vw
    curl --silent http://files.soops.intern/Software/Cincom/vw8.3.tar.gz | tar zx --directory=/home/dev/visualworks
    (cd ~/visualworks/vw8.3 ; rm -rf preview launchpad examples dllcc DotNETConnect seaside wavedev waveserver obsolete *.zip *.txt *.log *.pdf)
    touch ~/.config/zsh/visualworks-8.3.zshenv
}

da/install-vw-9.1 () {
    set -euxo pipefail

    [[ -a ~/.config/zsh/visualworks-9.1.zshenv ]] && return
    da/install-vw
    curl --silent http://files.soops.intern/Software/Cincom/vw9.1.tar.gz | tar zx --directory=/home/dev/visualworks
    (cd ~/visualworks/vw9.1 ; rm -rf preview launchpad examples dllcc DotNETConnect seaside wavedev waveserver obsolete *.txt *.log *.pdf)
    touch ~/.config/zsh/visualworks-9.1.zshenv
}

da/install-vw-9.1.1 () {
    set -euxo pipefail

    [[ -a ~/.config/zsh/visualworks-9.1.1.zshenv ]] && return
    da/install-vw
    curl --silent http://files.soops.intern/Software/Cincom/vw9.1.1.tar.gz | tar zx --directory=/home/dev/visualworks
    (cd ~/visualworks/vw9.1.1 ; rm -rf preview launchpad examples dllcc DotNETConnect seaside wavedev waveserver obsolete *.txt *.log *.pdf)
    touch ~/.config/zsh/visualworks-9.1.1.zshenv
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
    wget -m -np -nH --reject-regex '.*/\?.*' --cut-dirs 4 -P ${DIR}.tmp http://files.soops.intern/Builds/$IMAGE/$VERSION/
    rm -rf ${DIR}
    mkdir -p ${DIR}
    mv ${DIR}.tmp/*/* ${DIR}
    rm -rf ${DIR}.tmp
    find $DIR -name 'index.html*' -exec rm {} \;
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

vw/dir () {
    set -euxo pipefail

    IMAGE=$1
    VERSION=$2
    echo ~/visualworks/images/$IMAGE.image/$VERSION.version
}
