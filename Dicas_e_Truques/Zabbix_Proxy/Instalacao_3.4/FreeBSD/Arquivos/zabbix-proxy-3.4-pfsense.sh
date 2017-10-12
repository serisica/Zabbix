#!/bin/sh
#
# @Programa
#	@name: pfzp34.sh
#	@versao: 1.0.0
#	@Data 09 de outubro de 2017
#	@Copyright: Verdanatech Soluções em TI, 2017
#  @Author: Halexsandro de Freitas Sales <halexsandro.sales@verdanatech.com>
# --------------------------------------------------------------------------
# LICENSE
#
# pfzp34.sh is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
# 
# pfzp34.sh is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# If not, see <http://www.gnu.org/licenses/>.
# --------------------------------------------------------------------------
 

clear

cd /

# Definindo qual pacote baixar
# pfZP3.4.amd64.tgz
# pfZP3.4.i386.tgz

fetch https://github.com/MagnoMonteCerqueira/Zabbix/blob/master/Dicas_e_Truques/Zabbix_Proxy/Instalacao_3.4/FreeBSD/Arquivos/pfZP3.4.$(uname -m).tgz


if [ $? -ne 0 ]
then
	echo "ERRO TO  GET Package!!!"
	echo "..."
	echo "Exiting with erro to identify the arch (i686 our amd64)"
	exit 1
fi

pkg update
pkg upgrade -y

pkg install -y zabbix3-proxy pfsense-pkg-zabbix-proxy

mkdir /usr/local/etc/pkg/repos/

echo -e "FreeBSD: {\n url : \"pkg+http://pkg.FreeBSD.org/\${ABI}/latest\",\n enabled : yes,\n mirror_type : \"SRV\",\n signature_type : \"FINGERPRINTS\",\n fingerprints : \"/usr/share/keys/pkg\"\n}" > /usr/local/etc/pkg/repos/FreeBSD.conf

pkg update

# dependencias
pkg install -y gnutls libtasn1 openipmi p11-kit nmap 

# removendo arquivos que serao substituidos
killall zabbix_proxy
rm /usr/local/share/zabbix/proxy/database/sqlite3/schema.sql 2> /dev/null
rm /var/db/zabbix-proxy-lts/proxy.db 2> /dev/null
rm /usr/local/sbin/zabbix_proxy 2> /dev/null

# Instalando 3.4
tar -zxvf pfZP3.4.amd64.tgz
chown zabbix:zabbix /var/db/zabbix-proxy-lts/proxy.db

/usr/local/sbin/zabbix_proxy

# Cleaning 
echo -e "FreeBSD: { enabled : no }" > /usr/local/etc/pkg/repos/FreeBSD.conf
rm pfZP3.4.amd64.tgz


