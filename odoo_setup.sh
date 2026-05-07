
#!/bin/bash

set -e

echo "Update system"
sudo apt update && sudo apt upgrade -y

echo "Add deadsnakes repository"
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt update

echo "Install Python 3.12 and dependencies"
sudo apt install -y \
python3.12 \
python3.12-dev \
python3.12-venv \
build-essential \
wget \
git \
curl \
npm \
postgresql \
postgresql-client \
libjpeg-dev \
libpq-dev \
libxml2-dev \
libssl-dev \
libffi-dev \
libmysqlclient-dev \
libxslt1-dev \
zlib1g-dev \
libsasl2-dev \
libldap2-dev \
liblcms2-dev \
libzip-dev \
libreadline-dev \
libsqlite3-dev \
xz-utils \
tk-dev

echo "Install node tools"
sudo npm install -g less less-plugin-clean-css

echo "Install wkhtmltopdf"
wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-3/wkhtmltox_0.12.6.1-3.jammy_amd64.deb
sudo apt install -y ./wkhtmltox_0.12.6.1-3.jammy_amd64.deb

echo "Create PostgreSQL user"
sudo -u postgres createuser --createdb --username postgres --no-createrole --no-superuser odoo19 || true

sudo -u postgres psql -c "ALTER USER odoo19 WITH PASSWORD 'odoo19';"
sudo -u postgres psql -c "ALTER USER odoo19 WITH SUPERUSER;"

echo "Clone Odoo 19"
git clone https://github.com/odoo/odoo --depth 1 --branch 19.0 --single-branch odoo19

cd odoo19

echo "Create virtual environment"
python3.12 -m venv venv

echo "Activate virtual environment"
source venv/bin/activate

echo "Upgrade pip"
pip install --upgrade pip wheel setuptools

echo "Install Python requirements"
pip install -r requirements.txt


echo "create odoo.conf file"
touch odoo.conf
cat <<EOF > odoo.conf
[options]
admin_passwd = master
db_host = localhost
db_port = 5432
db_user = odoo19
db_password = 1234
addons_path = $(pwd)/addons
http_port = 8069
EOF


echo "Odoo 19 installation completed"
