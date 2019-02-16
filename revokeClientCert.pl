#!/usr/bin/perl

#
# A simple script to revoke client certificate
#

# revoke cert
print "openssl ca -config sub-ca.conf -revoke client.crt -crl_reason keyCompromise\n";
system("openssl ca -config sub-ca.conf -revoke client.crt -crl_reason keyCompromise");
