1. Create the following folders in the current directory:
    fastq tmp log bam 

2. Put chipseq reads files (or create links to chipseq reads files) under the "fastq" folder .


3. Prepare a csv file which contains the meta data of chipseq experiments. See example "exp.meta.csv". There are five fields:
   exp_name_chip: name of the chip experiment.
   mode:SE or PE.
   fastq_file_1: fastq file, first  read. 
   fastq_file_2: fastq file, second read (if in SE mode, fastq_file_2 is ignored).
   exp_name_input: name of the input experiment.For an input experiment, exp_name_chip and exp_name_input are the same.

4. Rscript chipseq.pipeline.R exp.meta.csv