FROM ethereum/client-go

# script that invokes with all those
# command line options
COPY rungeth.docker /usr/bin/rungeth
COPY geth.password /root/geth.password
COPY genesis.json  /root/genesis.json
COPY ethereum /root/.ethereum

ENTRYPOINT [/usr/bin/rungeth]

# use non-standard ports so don't accidently connect to real servers
EXPOSE 8110
EXPOSE 30310
EXPOSE 6110
