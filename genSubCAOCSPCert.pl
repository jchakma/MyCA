#!/usr/bin/perl

#
# A simple script to generate Sub CA OCSP Signing Cert
#

# generate Sub CA OCSP Signing Cert
# assuming Sub CA cert location: root-ca/sub-ca.crt

#
# A debug message
#
$msg = <<"EOM";
###############################################################################
#
# Creating a certificate for OCSP Signing (OCSP Sub CA Responder)
#
# (1) assuming location of sub-ca cert: root-ca/sub-ca.crt
# (2) OCSP Sub CA Responder certificate will be generated at: sub-ca-ocsp.crt
#
###############################################################################
EOM

print "\n$msg\n";

# at first check how sub-ca.crt looks like
@rootCA = `openssl x509 -in root-ca/sub-ca.crt -noout -text`;
$lines = join('' , @rootCA) ;

if ($lines =~ /Subject\:(.+)/) 
{
   # found Subject Field
   $subj = "$1";

   $subj =~ s/\s+//g;
   $subj =~ s/\,/\//g;
   $subj =~ s/CN.+/CN=OCSP Sub CA Responder/g;
   $subj = "/$subj";
}

print "openssl req -new -newkey rsa:2048 -subj \"$subj\" -keyout root-ca/private/sub-ca-ocsp.key -out sub-ca-ocsp.csr\n";
system("openssl req -new -newkey rsa:2048 -subj \"$subj\" -keyout root-ca/private/sub-ca-ocsp.key -out sub-ca-ocsp.csr");

print "openssl ca -config sub-ca.conf -in sub-ca-ocsp.csr -out sub-ca-ocsp.crt -extensions ocsp_ext -days 365\n";
system("openssl ca -config sub-ca.conf -in sub-ca-ocsp.csr -out sub-ca-ocsp.crt -extensions ocsp_ext -days 365");
