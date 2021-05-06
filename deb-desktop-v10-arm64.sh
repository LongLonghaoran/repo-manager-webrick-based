cd /var/lib/repo_data/kylin-desktop/V10-arm64-build/

rm -rf conf
mkdir conf
cat > conf/distributions << EOF
Origin: Kylin Repository
Label: Kylin Repository
Suite: 10.0
Codename: 10.0 
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

reprepro  -V  --confdir=/var/lib/repo_data/kylin-desktop/V10-arm64-build/conf --ignore=forbiddenchar --outdir=/var/lib/repo_data/kylin-desktop/V10-arm64-build/V10  --dbdir=/var/lib/repo_data/kylin-desktop/V10-arm64-build -C main includedeb 10.0 $1

chown -R www-data:www-data /var/lib/repo_data/kylin-desktop
