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
    sudo DEBIAN_FRONTEND='noninteractive' apt-get install -y --no-install-recommends -o apt-get::Immediate-Configure=false gcc-multilib
       
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
    sudo DEBIAN_FRONTEND='noninteractive' apt-get install -y libpq5:i386

    touch ~/.config/zsh/postgres-client.zshenv
}

da/install-postgres-client64 () {
    set -euxo pipefail

    [[ -a ~/.config/zsh/postgres-client64.zshenv ]] && return

    sudo apt-get update
    sudo DEBIAN_FRONTEND='noninteractive' apt-get install -y libpq5

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
