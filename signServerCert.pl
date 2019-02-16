#!/usr/bin/perl

#
# A simple script to sign server certificate
#
print "openssl ca -config sub-ca.conf -in server.csr -out server.crt -extensions server_ext\n";
system("openssl ca -config sub-ca.conf -in server.csr -out server.crt -extensions server_ext");
