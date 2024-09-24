#!/usr/bin/env perl

# script to calculate allele frequency from a multi sample VCF file
# usage: perl calculate-allele-frequency.pl --vcf example/genotypes.vcf --out example/allele_frequencies.tsv

use strict;
use warnings;
use Getopt::Long;
my ($inpVCF, $outFile);
GetOptions(
	'vcf=s' => \$inpVCF,
	'out=s' => \$outFile,
) or die "Usage: $0 --vcf VCF_FILE --out OUTPUT_FILE\n";
if (!defined $inpVCF | !defined $outFile) {
	die "Please provide both the VCF and output files.\nUsage: $0 --vcf VCF_FILE --out OUTPUT_FILE\n";
}
open(VCF, "$inpVCF") or die "Unable to read the input file: $inpVCF\n";
open(OUT, ">$outFile") or die "Unable to write to the output file: $outFile\n";
print OUT "CHR\tPOS\tREF\tALT\tALT_ALLELE_FREQ\tMINOR_ALLELE\tMINOR_ALLELE_FREQ\tTOTAL_GENOTYPE\tTOTAL_HET_GENOTYPE\tTOTAL_HOM_ALT_GENOTYPE\tTOTAL_HOM_REF_GENOTYPE\n";
while (my $row=<VCF>) {
	chomp $row;
	my $homRefGTCount=0;
	my $homAltGTCount=0;
	my $totalHetGTCount=0;
	my $totalGTcount=0;
	my $minorAlleleFreq;
	my $minorAllele;
	if ($row=~ /#/){ next;} # ignoring the header rows
	my ($chr, $pos, $rsid, $ref, $alt, $qual, $filter, $info, $format, @samp)= split (/\s+/,$row);	
	foreach my $freq (@samp){
		if ($freq =~ m{0[/|]0}) {
			$homRefGTCount++;
		}
		if ($freq =~ m{1[/|]1}) {
			$homAltGTCount++;
		}
		if ($freq =~ m{0[/|]1|1[/|]0}) {
			$totalHetGTCount++;
		}
		if ($freq =~ m{0[/|]1|1[/|]0|0[/|]0|1[/|]1}) {
			$totalGTcount++;
		}
	}
	if ($totalGTcount> 0) {
		my $refAllelefreq= ((2*$homRefGTCount)+$totalHetGTCount)/(2*$totalGTcount);
		my $altAllelefreq= ((2*$homAltGTCount)+$totalHetGTCount)/(2*$totalGTcount);
		if ($refAllelefreq < $altAllelefreq) {
			$minorAlleleFreq = $refAllelefreq;
			$minorAllele = $ref;
		} else {
			$minorAlleleFreq = $altAllelefreq;
			$minorAllele = $alt;
		}
		print OUT "$chr\t$pos\t$ref\t$alt\t$altAllelefreq\t$minorAllele\t$minorAlleleFreq\t$totalGTcount\t$totalHetGTCount\t$homAltGTCount\t$homRefGTCount\n";
	}
}