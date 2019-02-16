#!/usr/bin/perl

#
# A simple script to generate Server CSR (Certificate Signing Request)
#
$DEBUG = 1;

#
# Get some input from console
#

# password for
system "stty -echo";
print "Password for client key: ";
chomp($password1 = <STDIN>);
print "\nRe-type Password for client key: ";
chomp($password2 = <STDIN>);
print "\n";
system "stty echo";

if ("$password1" eq "$password2")
{
} else {
   print "Password does not match ... exiting ...\n";
   exit 1;
}

#
# At first generate a client key
#
print "Generating client key ...\n\n";
print "openssl genrsa -aes128 -passout pass:$password1 -out client.key 2048\n";
system("openssl genrsa -aes128 -passout pass:$password1 -out client.key 2048");

if (1 == $DEBUG)
{
   print "Generated a client key.\n";
}

#
# Generate the client template
#
print "CN (hostname, e.g. host-01.example.com): ";
chomp($CN = <STDIN>);
if ("$CN" eq "") 
{
   $CN = "host-01.example.com";
}

print "E-mail address (e.g. webmaster\@example.com): ";
chomp($EM = <STDIN>);
if ("$EM" eq "")
{
   $EM = "webmaster\@example.com";
}

print "Subject Alternative name (e.g. DNS:host-01.example.com,DNS:*.example.com): ";
chomp($SA = <STDIN>);
if ("$SA" eq "")
{
   $SA = "DNS:host-01.example.com,DNS:*.example.com";
}

$config = <<"END_OF_CONF";
[req]
prompt = no
distinguished_name = dn
req_extensions = ext
input_password = $password1

[dn]
CN = $CN
emailAddress = $EM
O = Example
L = Tokyo
C = JP

[ext]
subjectAltName = $SA
END_OF_CONF

open(ST, "> client.conf");
print ST "$config";
close(ST);

#
# Generate the CSR
#
print "openssl req -new -config client.conf -key client.key -out client.csr\n";
system("openssl req -new -config client.conf -key client.key -out client.csr");

# check the generated CSR
system("openssl req -text -noout -verify -in client.csr");
