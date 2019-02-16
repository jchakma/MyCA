#!/usr/bin/perl

#
# A simple script to create two-tiered CA
#
#  Root CA (root-ca)  [ usually offline ]
#     |
#     |
#  Sub CA (sub-ca)    [ signs / issues certificates ]
#  
$DEBUG = 1;

#
# First create necessary directory structures
#

# root directory
$RD = "root-ca";

# created necessary directories
system("mkdir $RD");
system("mkdir $RD/certs $RD/db $RD/private");
system("chmod 700 $RD/private");
system("touch $RD/db/index");
system("touch $RD/db/index.attr");
system("openssl rand -hex 16 > $RD/db/serial");
system("echo 1001 > $RD/db/crlnumber");

# DEBUG message
if (1 == $DEBUG) 
{
   print "The directory structure that was created ...\n\n";
   system("tree");
}

#
# Root CA Generation
#
$msg = <<"EOM";
###############################################################################
#
# Creating Root CA 
#
# (1) generate a key (need to input password twice)
# (2) generate a CSR (certificate signing request)
# (3) self-sign the cert (need to provide password for the key)
#
# * Need to input same certificate three times.
#
###############################################################################
EOM

print "\n$msg\n";

print "openssl req -new -config root-ca.conf -out $RD/root-ca.csr -keyout $RD/private/root-ca.key\n";
system("openssl req -new -config root-ca.conf -out $RD/root-ca.csr -keyout $RD/private/root-ca.key");

print "openssl ca -selfsign -config root-ca.conf -in $RD/root-ca.csr -out $RD/root-ca.crt -extensions ca_ext\n";
system("openssl ca -selfsign -config root-ca.conf -in $RD/root-ca.csr -out $RD/root-ca.crt -extensions ca_ext");

# DEBUG message
if (1 == $DEBUG)
{
   print "\n\nThe directory structure *after* Root CA is created ...\n\n";
   system("tree"); 
}

#
# Subordinate/Intermediate CA Generation
#
$msg = <<"EOM";
###############################################################################
#
# Creating Sub CA / Intermediate CA
#
# (1) generate a key (need to input password twice)
# (2) generate a CSR (certificate signing request)
# (3) sign it with Root CA (need to provide password for Root CA key)
#
# * Need to input Sub CA password twice and Root CA cert once
#
###############################################################################
EOM

print "\n$msg\n";

print "openssl req -new -config sub-ca.conf -out $RD/sub-ca.csr -keyout $RD/private/sub-ca.key\n";
system("openssl req -new -config sub-ca.conf -out $RD/sub-ca.csr -keyout $RD/private/sub-ca.key");

print "openssl ca -config root-ca.conf -in $RD/sub-ca.csr -out $RD/sub-ca.crt -extensions sub_ca_ext\n";
system("openssl ca -config root-ca.conf -in $RD/sub-ca.csr -out $RD/sub-ca.crt -extensions sub_ca_ext"); 

# DEBUG message
if (1 == $DEBUG)
{
   print "\n\nThe directory structure *after* Subordinate/Intermediate CA is created ...\n\n";
   system("tree"); 
}

$msg = <<"EOM";
###############################################################################
#
# Root CA and Sub CA certificates:
#
# (1) Generated Root CA cert: $RD/root-ca.crt
# (2) Generated Sub CA cert: $RD/sub-ca.crt
#
###############################################################################
EOM

print "\n$msg\n";
