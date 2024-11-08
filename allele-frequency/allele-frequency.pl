#!/usr/bin/env perl

# script to calculate allele frequency from a multi sample VCF file
# usage: perl allele-frequency.pl --vcf example/genotypes.vcf [--out example/allele_frequencies.tsv] [--withnames]

use strict;
use warnings;
use Getopt::Long;
my ( $inpVCF, $outFile, $withNames );
my @sample_names;
GetOptions(
    'vcf=s'     => \$inpVCF,
    'out=s'     => \$outFile,
    'withnames' => \$withNames,
) or die "Usage: $0 --vcf VCF_FILE [--out OUTPUT_FILE] [--withnames]\n";
if ( !defined $inpVCF ) {
    die "Please provide the VCF file.\nUsage: $0 --vcf VCF_FILE [--out OUTPUT_FILE] [--withnames]\n";
}
else {
    open( VCF, "$inpVCF" ) or die "Unable to read the input file: $inpVCF\n";
}
if ( defined $outFile ) {
    open( OUT, ">$outFile" ) or die "Unable to write to the output file: $outFile\n";
}
else {
    *OUT = *STDOUT;
}
if ( defined $withNames ) {
    print OUT "CHR\tPOS\tREF\tALT\tALT_ALLELE_FREQ\tMINOR_ALLELE\tMINOR_ALLELE_FREQ\tTOTAL_GENOTYPE\tTOTAL_HET_GENOTYPE\tTOTAL_HOM_ALT_GENOTYPE\tTOTAL_HOM_REF_GENOTYPE\tSAMPLE_NAME(s)\n";
}
else {
    print OUT "CHR\tPOS\tREF\tALT\tALT_ALLELE_FREQ\tMINOR_ALLELE\tMINOR_ALLELE_FREQ\tTOTAL_GENOTYPE\tTOTAL_HET_GENOTYPE\tTOTAL_HOM_ALT_GENOTYPE\tTOTAL_HOM_REF_GENOTYPE\n";
}
while ( my $row = <VCF> ) {
    chomp $row;
    if ( $row =~ /^##/ ) {
        next;
    }
    if ( $row =~ /^#CHROM/ ) {
        my @header = split( /\s+/, $row );
        @sample_names = @header[ 9 .. $#header ];
        next;
    }
    my ( $chr, $pos, $rsid, $ref, $alt, $qual, $filter, $info, $format, @samp) = split( /\s+/, $row );
    my $homRefGTCount   = 0;
    my $homAltGTCount   = 0;
    my $totalHetGTCount = 0;
    my $totalGTcount    = 0;
    my $minorAlleleFreq;
    my $minorAllele;
    my @samNames;
    for ( my $idx = 0 ; $idx <= $#samp ; $idx++ ) {
        if ( $samp[$idx] =~ m{0[/|]0} ) {
            $homRefGTCount++;
        }
        if ( $samp[$idx] =~ m{1[/|]1} ) {
            $homAltGTCount++;
        }
        if ( $samp[$idx] =~ m{0[/|]1|1[/|]0} ) {
            $totalHetGTCount++;
        }
        if ( $samp[$idx] =~ m{0[/|]1|1[/|]0|0[/|]0|1[/|]1} ) {
            $totalGTcount++;
            push @samNames, $sample_names[$idx];
        }
    }
    if ( $totalGTcount > 0 ) {
        my $refAllelefreq = ( ( 2 * $homRefGTCount ) + $totalHetGTCount ) / ( 2 * $totalGTcount );
        my $altAllelefreq = ( ( 2 * $homAltGTCount ) + $totalHetGTCount ) / ( 2 * $totalGTcount );
        if ( $refAllelefreq < $altAllelefreq ) {
            $minorAlleleFreq = $refAllelefreq;
            $minorAllele     = $ref;
        }
        else {
            $minorAlleleFreq = $altAllelefreq;
            $minorAllele     = $alt;
        }
        my $sample_names_str = join( ",", @samNames );
        if ( defined $withNames ) {
            print OUT "$chr\t$pos\t$ref\t$alt\t$altAllelefreq\t$minorAllele\t$minorAlleleFreq\t$totalGTcount\t$totalHetGTCount\t$homAltGTCount\t$homRefGTCount\t$sample_names_str\n";
        }
        else {
            print OUT "$chr\t$pos\t$ref\t$alt\t$altAllelefreq\t$minorAllele\t$minorAlleleFreq\t$totalGTcount\t$totalHetGTCount\t$homAltGTCount\t$homRefGTCount\n";
        }
    }
}
close VCF;
close OUT if defined $outFile;