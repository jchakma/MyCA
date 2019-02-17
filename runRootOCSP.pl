#!/usr/bin/perl

# A script to run a OCSP Responder (Root OCSP Responder)

# Extracting port from root-ca.conf file
open(ROOTCA, "root-ca.conf") || die "Error opening file: $!\n";
@rootCA = <ROOTCA>;
close(ROOTCA);

$lines = join('', @rootCA);

if ($lines =~ /ocsp_url.*?(\d+)/)
{
   $port = "$1";
}

# !!! IMPORTANT !!!
$msg = <<"EOM";
###############################################################################
#
# To test
#
# (1) openssl ocsp -issuer root-ca/root-ca.crt -CAfile root-ca/root-ca.crt -cert root-ca/sub-ca.crt -url http://ocsp-server:9080 
#
###############################################################################
EOM

print "\n$msg\n";

# run the server (will need password for ocsp responder key
print "openssl ocsp -port $port -index root-ca/db/index -rsigner root-ocsp.crt -rkey root-ca/private/root-ocsp.key -CA root-ca/root-ca.crt -text\n";
system("openssl ocsp -port $port -index root-ca/db/index -rsigner root-ocsp.crt -rkey root-ca/private/root-ocsp.key -CA root-ca/root-ca.crt -text");
