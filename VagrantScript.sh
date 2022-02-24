#!/bin/bash 

separator="==================="

##################
echo ${separator}
echo 'APT UPDATE'
sudo apt-get update

##################
echo ${separator}
echo 'NODEJS'

if ! command -v node -v &> /dev/null
then
    echo "NODEJS not installed"
    echo "Start installing NODEJS version 14"
    curl -fsSL https://deb.nodesource.com/setup_14.x | bash -
    apt-get install -y nodejs
fi

nodever="$(node -v)"
echo "installed version of NODEJS: ${nodever}"

cd /vagrant
##################
echo ${separator}
echo 'POSTGRESQL'

if ! command -v  psql -V &> /dev/null
then
    echo "POSTGRESQL not installed"
    echo "Start installing POSTGRESQL version"
    apt-get install -y postgresql
fi

postgersver="$(psql -V)"
echo "installed version of POSTGRESQL: ${postgersver}"

echo ${separator}
echo 'Prepare postgresql environment'

echo "DATABASE_NAME=vagrant
DATABASE_USERNAME=vagrant
DATABASE_PASSWORD=vagrant
DATABASE_PORT=5432
DATABASE_HOST=localhost" > /vagrant/js-fastify-blog/.env


sudo -u postgres psql -c "CREATE DATABASE vagrant;"

sudo -u postgres psql -c "CREATE USER vagrant WITH PASSWORD 'vagrant';";

sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE vagrant TO vagrant;";


##################
echo
echo ${separator}
echo 'MAKE'

if ! command -v make --version &> /dev/null
then
    echo "MAKE not installed"
    echo "Start installing MAKE by apt package manager"
    apt install make -y
fi

makever="$(make --version | head -n 1)"
echo "installed version of MAKE: ${makever}"

##################
echo
echo ${separator}
echo 'MAKE SETUP'
cd /vagrant/js-fastify-blog\

echo command \'npm ci\' can take a long time, plase be patient
make setup
