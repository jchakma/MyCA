#!/usr/bin/perl

#
# A simple script to sign server certificate
#
print "openssl ca -config sub-ca.conf -in client.csr -out client.crt -extensions client_ext\n";
system("openssl ca -config sub-ca.conf -in client.csr -out client.crt -extensions client_ext");
