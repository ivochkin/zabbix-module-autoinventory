#!/usr/bin/env bash

src="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
stage=/tmp/zabbix-module-autoinventory/$(uuidgen)

# Configurable parameters
libexec_prefix=/usr/libexec
zbx_bin_prefix=/etc/zabbix/extensions/scripts
zbx_libexec_prefix=$libexec_prefix/zabbix/extensions/autoinventory
zbx_agent_confd=/etc/zabbix/zabbix_agentd.d

mkdir -p $stage/$zbx_bin_prefix
mkdir -p $stage/$zbx_libexec_prefix
mkdir -p $stage/$zbx_agent_confd

sed_script="s#@ZBX_BIN_PREFIX@#$zbx_bin_prefix#g;s#@ZBX_LIBEXEC_PREFIX@#$zbx_libexec_prefix#g"

sed "$sed_script" $src/autoinventory-hw-short.sh.in \
  > $stage/$zbx_bin_prefix/autoinventory-hw-short.sh
sed "$sed_script" $src/autoinventory.conf.in \
  > $stage/$zbx_agent_confd/autoinventory.conf

chmod +x $stage/$zbx_bin_prefix/autoinventory-hw-short.sh

cp $src/mininumfmt.py $stage/$zbx_libexec_prefix/

fpm \
  --input-type dir \
  --output-type rpm \
  --chdir $stage \
  --name zabbix-module-autoinventory \
  --version $(cat $src/version) \
  --architecture all \
  --maintainer "Stanislav Ivochkin <isn@extrn.org>" \
  --vendor extrn.org \
  --depends "zabbix-agent > 3.0" \
  --config-files $zbx_agent_confd/autoinventory.conf \
  --url https://github.com/ivochkin/zabbix-module-autoinventory \
  --license MIT

rm -rf $stage
