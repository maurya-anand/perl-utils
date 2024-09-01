# perl-utils

### Custom Perl based utilities

### 1. Apply Rich Text Formatting to a Spreadsheet (xlsx)

Create an excel spreadsheet with data from a tab-delimited text file and apply custom text formatting to specified columns.

Using the 'text color' and 'underline' properties, highlight a specific sub string.

1. Requirements

    `Excel::Writer::XLSX`

2. Usage

    ```bash
    perl table-to-spreadsheet.pl <input table delimited file> <output directory <output file prefix>
    ```

   Input

   ![inp](images/paste-A103BA26.png)

   Output

   ![out](images/paste-FEC961A6.png)

### 2. Calculate variant allele frequency from a multi-sample VCF file

1. Usage

    ```bash
    perl calculate-allele-frequency.pl <inut vcf file> > <output file>
    ```

    Output

    The output file will contain the following columns
    - CHR
    - POS
    - REF
    - ALT
    - ALLELE_FREQ
    - TOTAL_GENOTYPE
    - TOTAL_HET
    - TOTAL_HOM
