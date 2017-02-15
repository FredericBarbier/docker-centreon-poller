What Is It?
-----------
Thist is just satellite poller for centreon.
To have it working you need to have full centreon installation, and then u can run that poller on remote locations.

And now on the 6022 u have running SSH port for centreon poller.
You can configure your centreon master and specify IP and PORT for ssh.
On the centreon side you need to add:
- poller
- main.cfg
- centreon broker config

and it's ready to go.

Known problems 
-------

First time ssh would have problem to log in because of new fingerprint, just on the master host you need to do:
    $ sudo su centreon
    $ ssh -p 6022 YOUR_POLLER_IP 
    // and accept the new fingerprint


