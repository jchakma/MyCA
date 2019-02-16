#!/usr/bin/perl

#
# A simple script to convert cert from PEM to PKCS#12 (.pfx .p12)
#
print "openssl pkcs12 -export -out client.pfx -inkey client.key -in client.crt -certfile root-ca/sub-ca.crt\n";
system("openssl pkcs12 -export -out client.pfx -inkey client.key -in client.crt -certfile root-ca/sub-ca.crt");
