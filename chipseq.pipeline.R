require(data.table)
require(plyr)
require(dplyr)
require(foreach)
require(parallel)
require(doParallel)


args          <- commandArgs(TRUE)
exp.meta.file <- args[1]
exp.meta      <- read.csv(file = exp.meta.file,header=FALSE,stringsAsFactors=FALSE)



registerDoParallel(2)
foreach(i = 1:nrow(exp.meta)) %do% {  
    row      <- exp.meta[i,]
    cmd      <- sprintf('perl code/map.one.sample.pl %s %s %s %s',row[,1],row[,2],row[,3],row[,4])
    bam.file <- sprintf('bam/%s.rmdup.bam',row[,1])
    if(file.exists(bam.file) == FALSE){
        system(cmd,wait=TRUE,intern=TRUE)
        print(sprintf("sample %s finished!",row[,1]))
    }else{
        print(sprintf("Reads of sample %s have already been mapped!",row[,1]))
    }
}




flag     <- exp.meta[,1] != exp.meta[,5]
exp.meta <- exp.meta[flag,]
foreach(i = 1:nrow(exp.meta)) %dopar% {  
    row      <- exp.meta[i,]
    mode     <- row[,2]
    if(mode == 'PE'){
        macs2.cmd  <- sprintf('macs2 callpeak -t bam/%s.rmdup.bam  -c bam/%s.rmdup.bam -f BAMPE -q 0.2 --nomodel --outdir macs2.output -n %s -g hs',row[,1],row[,5],row[,1])
    }else{
        macs2.cmd  <- sprintf('macs2 callpeak -t bam/%s.rmdup.bam  -c bam/%s.rmdup.bam -f BAM   -q 0.2           --outdir macs2.output -n %s -g hs',row[,1],row[,5],row[,1])
    }
    macs2.log <- system(macs2.cmd,wait=TRUE,intern=TRUE)
    print(sprintf("sample %s peak calling finished!",row[,1]))
        
}



