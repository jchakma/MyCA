#!/usr/bin/perl

#
# A simple script to sign code signing cert
#
print "openssl ca -config sub-ca.conf -in code-signing.csr -out code-signing.crt -extensions codesigning_ext\n";
system("openssl ca -config sub-ca.conf -in code-signing.csr -out code-signing.crt -extensions codesigning_ext");
