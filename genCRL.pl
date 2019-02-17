#!/usr/bin/perl

#
# A simple script to generate CRL
#

# generate Root CRL
print "openssl ca -gencrl -config root-ca.conf -out root-ca.crl\n";
system("openssl ca -gencrl -config root-ca.conf -out root-ca.crl");

# output in text format
system("openssl crl -in root-ca.crl -noout -text");

# generate Sub CA CRL
print "openssl ca -gencrl -config sub-ca.conf -out sub-ca.crl\n";
system("openssl ca -gencrl -config sub-ca.conf -out sub-ca.crl");

# output in text format
system("openssl crl -in sub-ca.crl -noout -text");
