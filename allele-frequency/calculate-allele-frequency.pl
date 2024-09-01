#!/usr/bin/env perl

# usage: perl calculate-allele-frequency.pl example/genotypes.vcf > allele_frequencies.tsv
# script to calculate allele frequency from a multi sample VCF file

use strict;
use warnings;

my $inp_vcf = $ARGV[0]; # input VCF file

open(VCF, "$inp_vcf") or die "can't open the VCF file";

print "CHR\tPOS\tREF\tALT\tALLELE_FREQ\tTOTAL_GENOTYPE\tTOTAL_HET\tTOTAL_HOM\n";

while (my $row=<VCF>) {
	chomp $row;
	my $homfreq=0;
	my $hetfreq=0;
	my $count=0;
	if ($row=~ /#/){ next;} # ignoring the header rows
	my ($chr, $pos, $rsid, $ref, $alt, $qual, $filter, $info, $format, @samp)= split (/\s+/,$row);
	foreach my $freq (@samp){
		if ($freq =~ m{1[/|]1}) {
			$homfreq++;
		}
		if ($freq =~ m{0[/|]1|1[/|]0}) {
			$hetfreq++;
		}
		if ($freq =~ m{0[/|]1|1[/|]0|0[/|]0|1[/|]1}) {
			$count++;
		}
		}
	if ($count> 0){
		my $allelefreq= ((2*$homfreq)+$hetfreq)/(2*$count);
		print "$chr\t$pos\t$ref\t$alt\t$allelefreq\t$count\t$hetfreq\t$homfreq\n";
	}
}
