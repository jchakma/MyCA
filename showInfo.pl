#!/usr/bin/perl

#
# A script to show all info in a single place
#

# First root-ca info (assuming the info is inside: root-ca.conf file)

# Show root-ca related info
$msg = <<"EOM";
###############################################################################
#
# Showing Root CA related info
#
###############################################################################
EOM

print "\n$msg\n";
printInfo("root-ca.conf");

print "\n- RELATED FILES\n\n";
print "root-ca.crt => root-ca/root-ca.crt\n";
print "root-ca.crl => root-ca.crl (!!! Use ./genCRL.pl to generate CRL !!!)\n";
print "ocsp signing cert / key => root-ocsp.crt / root-ca/private/root-ocsp.key (!!! use: genRootOCSPCert.pl / runRootOCSP.pl !!!)\n";

$msg = <<"EOM";
###############################################################################
#
# Showing Sub CA related info
#
###############################################################################
EOM

print "\n$msg\n";
printInfo("sub-ca.conf");

print "\n- RELATED FILES\n\n";
print "sub-ca.crt => root-ca/sub-ca.crt\n";
print "sub-ca.crl => sub-ca.crl (!!! Use ./genCRL.pl to generate CRL) !!!\n";
print "ocsp signing cert / key => sub-ca-ocsp.crt / root-ca/private/sub-ca-ocsp.key (!!! use genSubCAOCSPCert.pl / runSubCAOCSP.pl !!!)\n";

print "\n\n";

#
# Basically same contents in root-ca.conf / sub-ca.conf
# so processing this via same subroutine
#
sub printInfo 
{
   my $filename = shift;   

   open(FILE, "$filename") || die "Error opening file: $!\n";
   my @CONTENT = <FILE>;
   close(FILE);
   
   my $lines = join('', @CONTENT);

   if ($lines =~ /name\s+\=\s(.+)/)
   {
      $name = "$1";
      print "name = $name\n";
   }

   if ($lines =~ /domain_suffix.*?\=\s(.+)/)
   {
      $domain_suffix = "$1";
      print "domain_suffix: $domain_suffix\n";
   }

   if ($lines =~ /aia_url\s+\=\s(.+)/)
   {
      $aia_url = "$1";

      $aia_url =~ s/\$name/$name/g;
      $aia_url =~ s/\$domain_suffix/$domain_suffix/g;
 
      print "aia_url: $aia_url\n";
   }

   if ($lines =~ /crl_url\s+\=\s(.+)/)
   {
      $crl_url = "$1";
      $crl_url =~ s/\$name/$name/g;
      $crl_url =~ s/\$domain_suffix/$domain_suffix/g;

      print "crl_url: $crl_url\n"; 
   }

   if ($lines =~ /crl_url2\s+\=\s(.+)/)
   {
      $crl_url2 = "$1";
      $crl_url2 =~ s/\$name/$name/g;
      $crl_url2 =~ s/\$domain_suffix/$domain_suffix/g;

      print "crl_url2: $crl_url2\n"; 
   }


   if ($lines =~ /ocsp_url\s+\=\s(.+)/)
   {
      $ocsp_url = "$1";

      $ocsp_url =~ s/\$name/$name/g;
      $ocsp_url =~ s/\$domain_suffix/$domain_suffix/g;

      print "ocsp_url: $ocsp_url\n";
   }
}
