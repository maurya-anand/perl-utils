#!/usr/bin/env perl


## usage: perl table-to-spreadsheet.pl example/input.txt ./example results
## script to create a spreadsheet with specific formatting applied to columns

## formatting tasks:
## Apply red text color to the source prefix in the 'Sample Accession'
## Underline the ID in the 'Sample Accession'
## Highlight red color text if 'Total Size, Mb' is less than 100
## Underline and highlight the word 'exome' if present in the 'Study Title'


use strict;
use warnings;
use Data::Dumper;
use Excel::Writer::XLSX;

my $input_tab = $ARGV[0];   # input table 
my $output_dir = $ARGV[1];  # output directory
my $output_name = $ARGV[2]; # output file prefix


my $workbook = Excel::Writer::XLSX->new( "$output_dir/$output_name.xlsx" );
my $worksheet_1 = $workbook->add_worksheet();

my $red_text = $workbook->add_format();
$red_text->set_color('red');
$red_text->set_align('right');

my $underlined_text = $workbook->add_format();
$underlined_text->set_underline();

my $red_underlined_text = $workbook->add_format();
$red_underlined_text->set_underline();
$red_underlined_text->set_color('red');

# set width of the colums for proper visibility. cols 0,1 => width 11
# $worksheet_1->set_column( 0, 3, 11); # alternative syntax
# set_column( $first_col, $last_col, $width, $format, $hidden, $level, $collapsed )
$worksheet_1->set_column( 'A:B', 15);

# set width of the colums for proper visibility. cols 3 => width 80
$worksheet_1->set_column( 'C:C', 100 );

my $row = 0;
my $word_to_highlight = 'exome';

open (TAB,"$input_tab") or die "can't open the input table\n";
while(my $rec=<TAB>){
    chomp $rec;
    if($rec=~ /^Sample/){
        my @header = split(/\t/,$rec);
        # write_string( $row, $column, $string, $format )
        $worksheet_1->write_string($row, 0, $header[0]);
        $worksheet_1->write_string($row, 1, $header[1]);
        $worksheet_1->write_string($row, 2, $header[2]);
    }
    else{   
        # print "$rec\n";
        my @cols = split(/\t/,$rec);
        my $source = '';
        my $id = '';
        if($cols[0]=~/^(\D+)(\d+)/){
            $source = $1;
            $id = $2;
        }
        
        # write_rich_string( $row, $column, format1, text, format2,text)
        $worksheet_1->write_rich_string($row, 0, $red_text,$source,$underlined_text,$id);

        if ($cols[1] < 100){
            # $worksheet->write_number( row, col, value, format );
            $worksheet_1->write_number($row, 1, $cols[1],$red_text);
        }
        else {
            $worksheet_1->write_number($row, 1, $cols[1]);
        }

        if (lc $cols[2]=~ /exome/){
            my $index = index(lc $cols[2], 'exome');
            my $title_1=substr($cols[2],0,$index);
            my $title_2=substr($cols[2],$index,(length $word_to_highlight));
            my $title_3=substr($cols[2],$index + (length $word_to_highlight), (length $cols[2]) );
            # print "$index\t$title_1\t$title_2\t$title_3\t$cols[2]\n";
            $worksheet_1->write_rich_string($row, 2, $title_1,$red_underlined_text,$title_2,$title_3);

        }
        else {
            $worksheet_1->write($row, 2, $cols[2]);
        }
    }
    $row++;
}
