#!/usr/bin/perl

#
# A simple script to convert cert from PEM to PKCS#12 (.pfx .p12)
#
print "openssl pkcs12 -export -out server.pfx -inkey server.key -in server.crt -certfile root-ca/sub-ca.crt\n";
system("openssl pkcs12 -export -out server.pfx -inkey server.key -in server.crt -certfile root-ca/sub-ca.crt");
