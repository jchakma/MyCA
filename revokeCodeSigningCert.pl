#!/usr/bin/perl

#
# A simple script to revoke code signing certificate
#

# revoke cert
print "openssl ca -config sub-ca.conf -revoke code-signing.crt -crl_reason keyCompromise\n";
system("openssl ca -config sub-ca.conf -revoke code-signing.crt -crl_reason keyCompromise");
