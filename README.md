# VirtualBox Dev Setup

These are my scripts for provisioning a new VirtualBox for PHP development. Many things are Taylor specific, such as the bash aliases and extensions for work related projects. However, feel free to fork and modify for your own usage.
And I did that, :+1: Taylor!

`wget -O setup.sh goo.gl/6CGWyk`

## Instructions

1. Install Ubuntu 13.10 into new VirtualBox instance.
2. Login and select `Devices` -> `Insert Guest Additions CD image...` from the VirtualBox menu.
3. Run the `setup.sh` script to provision the box.
3.1 First password prompt: root
3.2 Others userpassword ("develop" in my case)

After the box has been provisioned, you only need to setup your shared folder(s) and port forwarding. Everything else is ready to go. You may connect to the MySQL and Postgres instances via any database management program on your host, such as Sequel Pro or Navicat.

A few of the action and scripts assume your shared folder will be `/media/sf_Code`. You can modify the `setup.sh` and `serve.sh` scripts to change this.

## Includes

- Apache
- PHP 5.5
- Composer
- PHPUnit
- Mailparse PHP Extension (For Snappy Dev)
- Memcached
- Redis
- MySQL (Password: root)
- Beanstalkd Queue & Console (VirtualHost @ http://beansole.app)
- Node.js (With Grunt & Forever)
- Python Fabric & Hipchat Plugin
- SSH Key Generation
- Taylor's Serve Script - modified
- Taylor's Bash Aliases - modified

## Port Forwarding

**Note:** On Windows, you may use the same ports for both host and guest. This screenshots shows the Mac configuration where higher ports must be used on the host.

![Port Forwarding Setup](http://i.imgur.com/iTeohFC.png)

## Shared Folder

![Shared Folder Setup](http://i.imgur.com/2UqPpHB.png)
