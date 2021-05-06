cd /var/lib/repo_data/partner/V10-build/

rm -rf conf
mkdir conf
cat > conf/distributions << EOF
Origin: Kylin Repository
Label: Kylin Repository
Suite: juniper
Codename: juniper
Architectures: i386 amd64 arm64 mips64 mips64el source debian-installer
Components: main multiverse restricted universe
UDebComponents: main multiverse restricted universe
Description: Kylin Install Repository
SignWith: 6593A4DD1A3405C22BE659EB26034FA3225C6FE4
EOF

cat > conf/options << EOF
verbose
ask-passphrase
basedir .
EOF

reprepro  -V  --confdir=/var/lib/repo_data/partner/V10-build/conf --ignore=forbiddenchar -S application -P optional --outdir=/var/lib/repo_data/partner/V10-build/V10  --dbdir=/var/lib/repo_data/partner/V10-build -C main includedeb juniper $1

chown -R www-data:www-data /var/lib/repo_data/partner
