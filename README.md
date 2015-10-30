behaviorSim_web
===============

This is a web server which creates a gui to connect users to behaviorSim.

Test out the server-decoupled version at http://pielab.github.io/behaviorSim_web/

## Getting Started ##
### Basic ###
To build the less, dust.js templates, and coffeescript you'll need to install dependencies. The easiest way to do this is to use npm.
```sh
sudo apt-get install npm
cd behaviorSim
npm install
git submodule init
git submodule update
```
Once setup just run `startup.sh` to build and start a local test server.
