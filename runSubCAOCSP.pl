#!/usr/bin/perl

# A script to run a OCSP Responder (Root OCSP Responder)

# Extracting port from root-ca.conf file
open(SUBCA, "sub-ca.conf") || die "Error opening file: $!\n";
@subCA = <SUBCA>;
close(SUBCA);

$lines = join('', @subCA);

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
# (1) merge root and sub ca cert: cat root-ca/sub-ca.crt root-ca/root-ca.crt > root-sub-ca.crt
# (2) and then: openssl ocsp -issuer root-ca/sub-ca.crt -CAfile root-sub-ca.crt -cert server.crt -url http://ocsp-server-add:$port
#
# Idea behind this is:
#
# (3) server.crt is issued / signed by sub-ca.crt (root-ca -> sub-ca -> server cert).
# (4) Sub CA responder is going to verify the certificate and send the response back (signed response).
# (5) The client (who is sending the verification request) need to verify the signature.
# (6) To verify the signature, it needs to have the whole cert chain upto root ca cert (hence merging of root-ca and sub-ca cert).
#     Here, in this setup, there's only root-ca and sub-ca cert, however, in real world, the trust chain might be:
#     (root-ca -> primary intermediate ca -> intermediate ca -> server cert), in that case CAfile option needs to
#     have these files merged so that it can build the whole trust chain (up to root certificate)
#
###############################################################################
EOM

print "\n$msg\n";

# run the server (will need password for ocsp responder key
print "openssl ocsp -port $port -index root-ca/db/index -rsigner sub-ca-ocsp.crt -rkey root-ca/private/sub-ca-ocsp.key -CA root-ca/sub-ca.crt -text\n";
system("openssl ocsp -port $port -index root-ca/db/index -rsigner sub-ca-ocsp.crt -rkey root-ca/private/sub-ca-ocsp.key -CA root-ca/sub-ca.crt -text");
