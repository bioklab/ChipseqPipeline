use strict;

my  $bowtie2_index='/mnt/genome.index/hg38.bowtie2/GRCh38_noalt_as/GRCh38_noalt_as';
my  $prefix       = $ARGV[0];
my  $mode         = $ARGV[1];
my  $f1           = $ARGV[2];


my $fastq_option = "";
if($mode eq "PE"){
    my  $f2           = $ARGV[3];
    $fastq_option = " -1 fastq/$f1  -2 fastq/$f2 " ;
}else{
    $fastq_option = " -U fastq/$f1 " ;
}


my $bowtie2_cmd  = " bowtie2 --very-sensitive -p 2 --no-discordant --no-mixed -X 1000 -x ${bowtie2_index}  ${fastq_option}  2>log/${prefix}.bowtie2.log | samtools view -f 2 -F 1804 -q 10 -bhS -  > tmp/${prefix}.bowtie2.bam ";
`$bowtie2_cmd`;

my $samtools_cmd = " samtools sort -o tmp/${prefix}.bowtie2.sort.bam -T ${prefix}.tmp  tmp/${prefix}.bowtie2.bam"; 
`$samtools_cmd`;

my $picard_cmd = " picard MarkDuplicates INPUT=tmp/${prefix}.bowtie2.sort.bam OUTPUT=bam/${prefix}.rmdup.bam METRICS_FILE=log/${prefix}.pciard.metrics.log REMOVE_DUPLICATES=true ";
`$picard_cmd`;  