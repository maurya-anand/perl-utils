# perl-utils

## Custom Perl based utilities

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
    perl allele-frequency.pl --vcf VCF_FILE [--out OUTPUT_FILE] [--withnames]
    ```

    Output:

    By default, the output will contain the following coulms and will be displayed on `stdout`:

    - CHR
    - POS
    - REF
    - ALT
    - ALLELE_FREQ
    - TOTAL_GENOTYPE
    - TOTAL_HET
    - TOTAL_HOM
    - SAMPLE_NAME(s) (included if `--withnames` parameter is specified)

    If the `--out` parameter is specified, the output will be writen to a file.
    
    Use as an executable binary:

    ```bash
    curl -o freq https://raw.githubusercontent.com/maurya-anand/perl-utils/refs/heads/main/allele-frequency/allele-frequency.pl && chmod +x freq
    ```

    ```bash
    ./freq --vcf VCF_FILE [--out OUTPUT_FILE] [--withnames]
    ```
