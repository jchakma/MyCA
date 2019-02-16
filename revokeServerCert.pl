#!/usr/bin/perl

#
# A simple script to revoke server certificate
#

# revoke cert
print "openssl ca -config sub-ca.conf -revoke server.crt -crl_reason keyCompromise\n";
system("openssl ca -config sub-ca.conf -revoke server.crt -crl_reason keyCompromise");
