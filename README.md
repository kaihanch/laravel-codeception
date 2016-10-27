# laravel-codeception
laravel + codeception

## Requirement

1. [VirtualBox](https://www.virtualbox.org/)
2. [Vagrant](https://www.vagrantup.com/)

## Installed software:
- Apache 2.4.7 
- PHP 7.0.12
- MariaDB 10.1
- Laravel 5.3



## Vagrant

Default setting:

- IP: 10.10.10.10

project dir:

- /vagrant/blog

## Installation
Clone 本專案(`/path/to/project`)，然後初始化虛擬機

```bash
cd /path/to/project
vagrant up
vagrant ssh
cd /vagrant/blog
composer install
cp .env.example .env
php artisan key:generate
```
