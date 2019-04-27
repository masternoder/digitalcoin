 masternode for docker
===================

Docker image that runs the  daemon which can be turned into a masternode with the correct configuration.

This image also runs [sentinel](https://github.com//sentinel) (which is required for a masternode to get rewards) every minute as a cron job.



Quick Start
-----------

```bash
docker run \
  -d \
  -p 13333:13333 \
  -v /some/directory:/ \
  --name= \
  masternoder/digitalcoin2
```

This will create the folder `.core` in `/some/directory` with a bare `.conf`. You might want to edit the `.conf` before running the container because with the bare config file it doesn't do much, it's basically just an empty wallet.

Start as masternode
------------

To start the masternode functionality, edit your .conf (should be in /some/directory/./ following the docker run command example above):

```
rpcuser=<SOME LONG RANDOM USER NAME>
rpcpassword=<SOME LONG RANDOM PASSWORD>
rpcallowip=::/0
server=1
logtimestamps=1
maxconnections=256
printtoconsole=1
masternode=1
masternodeaddr=<SERVER IP ADDRESS>:7999
masternodeprivkey=<MASTERNODE PRIVATE KEY>
```

Where `<SERVER IP ADDRESS>` is the public facing IPv4 or IPv6 address that the masternode will be reachable at.
Don't forget to put your IPv6 address in brackets! For example `[aaaa:bbbb:cccc::0]:51472`

`<MASTERNODE PRIVATE KEY>` is the private key that you generated earlier (with `-cli masternode genkey`).
