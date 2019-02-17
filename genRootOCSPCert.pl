#!/usr/bin/perl

#
# A simple script to generate Root OCSP Signing Cert
#

# generate Root OCSP Signing Cert
# assuming root cart location: root-ca/root-ca.crt

#
# A debug message
#
$msg = <<"EOM";
###############################################################################
#
# Creating a certificate for OCSP Signing (OCSP Root Responder)
#
# (1) assuming location of root-ca cert: root-ca/root-ca.crt
# (2) OCSP Root Responder certificate will be generated at: root-ocsp.crt
#
###############################################################################
EOM

print "\n$msg\n";

# at first check how root-ca.crt looks like
@rootCA = `openssl x509 -in root-ca/root-ca.crt -noout -text`;
$lines = join('' , @rootCA) ;

if ($lines =~ /Subject\:(.+)/) 
{
   # found Subject Field
   $subj = "$1";

   $subj =~ s/\s+//g;
   $subj =~ s/\,/\//g;
   $subj =~ s/CN.+/CN=OCSP Root Responder/g;
   $subj = "/$subj";
}

print "openssl req -new -newkey rsa:2048 -subj \"$subj\" -keyout root-ca/private/root-ocsp.key -out root-ocsp.csr\n";
system("openssl req -new -newkey rsa:2048 -subj \"$subj\" -keyout root-ca/private/root-ocsp.key -out root-ocsp.csr");

print "openssl ca -config root-ca.conf -in root-ocsp.csr -out root-ocsp.crt -extensions ocsp_ext -days 365\n";
system("openssl ca -config root-ca.conf -in root-ocsp.csr -out root-ocsp.crt -extensions ocsp_ext -days 365");
