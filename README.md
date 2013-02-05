Peuplade VM
===========

Setup
-----

### Git submodules

Once this repository cloned, don't forget to update project submodules with :

    git submodule init
    git submodule update


### Ruby

Install ruby on your favorite distro. On debian/ubuntu that gives :

    sudo apt-get install ruby1.9.1


Then install the bundler gem system-wide (that will be usefull for many other
ruby projects too) :

    sudo gem install bundler


### Project dependencies

In the project subdirectories (master, slave), type the following command :

    bundle install --binstubs --path vendor/bundle

(This will install all dependencies in vendor/bundle and related executable
scripts in ./bin)


### Virtualbox

Make sure virtualbox is installed properly and that the kernel module is loaded.
If not, try typing :

    sudo /etc/init.d/vboxdrv setup


### Vagrant base commands

To start playing with vagrant, you first HAVE TO configure your local VM using

    bundle exec vagrant up


To push configuration changes to your VM after an update :

    bundle exec vagrant provision


To reload to VM :

    bundle exec vagrant reload


Then you can play using the classic vagrant commands :

    bundle exec vagrant ssh
    ...
    [code code code]
    ...
    bundle exec vagrant halt


That's all folks !

