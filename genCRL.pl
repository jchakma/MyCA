#!/usr/bin/perl

#
# A simple script to generate CRL
#

# generate CRL
print "openssl ca -gencrl -config sub-ca.conf -out sub-ca.crl\n";
system("openssl ca -gencrl -config sub-ca.conf -out sub-ca.crl");

# output in text format
system("openssl crl -in sub-ca.crl -noout -text");
