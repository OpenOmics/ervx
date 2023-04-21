# <code>ervx <b>run</b></code>

## 1. About 
The `ervx` executable is composed of several inter-related sub commands. Please see `ervx -h` for all available options.

This part of the documentation describes options and concepts for <code>ervx <b>run</b></code> sub command in more detail. With minimal configuration, the **`run`** sub command enables you to start running ervx pipeline. 

Setting up the ervx pipeline is fast and easy! In its most basic form, <code>ervx <b>run</b></code> only has *two required inputs*.

## 2. Synopsis
```text
$ ervx run [--help] \
      [--mode {slurm,uge,local}] [--job-name JOB_NAME] [--batch-id BATCH_ID] \
      [--tmp-dir TMP_DIR] [--silent] [--sif-cache SIF_CACHE] \ 
      [--singularity-cache SINGULARITY_CACHE] \
      [--dry-run] [--threads THREADS] \
      --input INPUT [INPUT ...] \
      --output OUTPUT
```

The synopsis for each command shows its arguments and their usage. Optional arguments are shown in square brackets.

A user **must** provide a list of FastQ (globbing is supported) to analyze via `--input` argument and an output directory to store results via `--output` argument.

Use you can always use the `-h` option for information on a specific command. 

### 2.1 Required arguments

Each of the following arguments are required. Failure to provide a required argument will result in a non-zero exit-code.

  `--input INPUT [INPUT ...]`  
> **Input FastQ or BAM file(s).**  
> *type: file(s)*  
> 
> One or more FastQ files can be provided. The pipeline does NOT support single-end data. From the command-line, each input file should seperated by a space. Globbing is supported! This makes selecting FastQ files easy. Input FastQ files should always be gzipp-ed.
> 
> ***Example:*** `--input .tests/*.R?.fastq.gz`

---  
  `--output OUTPUT`
> **Path to an output directory.**   
> *type: path*
>   
> This location is where the pipeline will create all of its output files, also known as the pipeline's working directory. If the provided output directory does not exist, it will be created automatically.
> 
> ***Example:*** `--output /data/$USER/ervx_out`

### 2.2 Analysis options

Each of the following arguments are optional, and do not need to be provided. 

...add non-required analysis options 

### 2.3 Orchestration options

Each of the following arguments are optional, and do not need to be provided, except that ***`--sif-cache --mode` `--tmp-dir` and `--shared-resources` are required options on Locus.***

  `--dry-run`            
> **Dry run the pipeline.**  
> *type: boolean flag*
> 
> Displays what steps in the pipeline remain or will be run. Does not execute anything!
>
> ***Example:*** `--dry-run`

---
  `--shared-resources SHARED_RESOURCES`  
> **Local path to shared resources.**  
> *type: path*
>
> The pipeline uses a set of shared reference files that can be re-used across reference genomes. These currently include reference files for kraken and FQScreen. These reference files can be downloaded with the build sub command's `--shared-resources`  option. With that being said, these files only need to be downloaded once. We recommend storing this files in a shared location on the filesystem that other people can access. If you are running the pipeline on Biowulf, you do NOT need to download these reference files! They already exist on the filesystem in a location that anyone can acceess; however, if you are running the pipeline on another cluster or target system, you will need to download the shared resources with the build sub command, and you will need to provide this option every time you run the pipeline. Please provide the same path that was provided to the build sub command's --shared-resources option. Again, if you are running the pipeline on Biowulf, you do NOT need to provide this option. For more information about how to download shared resources, please reference the build sub command's `--shared-resources` option. **This is a required option on Locus, shared resources are already on Locus in /hpcdata/dir/NCBR-337/SHARED_RESOURCES/.**
> 
> ***Example:*** `--shared-resources /hpcdata/dir/NCBR-337/SHARED_RESOURCES/`

---  
  `--silent`            
> **Silence standard output.**  
> *type: boolean flag*
> 
> Reduces the amount of information directed to standard output when submitting master job to the job scheduler. Only the job id of the master job is returned.
>
> ***Example:*** `--silent`

---  
  `--mode {slurm,uge,local}`  
> **Execution Method.**  
> *type: string*  
> *default: slurm*
> 
> Execution Method. Defines the mode or method of execution. Vaild mode options include: slurm or local. 
> 
> ***slurm***    
> The slurm execution method will submit jobs to the [SLURM workload manager](https://slurm.schedmd.com/). It is recommended running ervx in this mode as execution will be significantly faster in a distributed environment. This is the default mode of execution.
>
> ***uge***    
> The uge execution method will submit jobs to the [UGE workload manager](https://supcom.hgc.jp/english/utili_info/manual/uge.html#2694). **This option is required on Locus**.
>
> ***local***  
> Local executions will run serially on compute instance. This is useful for testing, debugging, or when a users does not have access to a high performance computing environment. If this option is not provided, it will default to a local execution mode. 
> 
> ***Example:*** `--mode slurm`

---  
  `--job-name JOB_NAME`  
> **Set the name of the pipeline's master job.**  
> *type: string*
> *default: pl:ervx*
> 
> When submitting the pipeline to a job scheduler, like SLURM, this option always you to set the name of the pipeline's master job. By default, the name of the pipeline's master job is set to "pl:ervx".
> 
> ***Example:*** `--job-name pl_id-42`

---  
  `--singularity-cache SINGULARITY_CACHE`  
> **Overrides the $SINGULARITY_CACHEDIR environment variable.**  
> *type: path*  
> *default: `--output OUTPUT/.singularity`*
>
> Singularity will cache image layers pulled from remote registries. This ultimately speeds up the process of pull an image from DockerHub if an image layer already exists in the singularity cache directory. By default, the cache is set to the value provided to the `--output` argument. Please note that this cache cannot be shared across users. Singularity strictly enforces you own the cache directory and will return a non-zero exit code if you do not own the cache directory! See the `--sif-cache` option to create a shareable resource. 
> 
> ***Example:*** `--singularity-cache /data/$USER/.singularity`

---  
  `--sif-cache SIF_CACHE`
> **Path where a local cache of SIFs are stored.**  
> *type: path*  
>
> Uses a local cache of SIFs on the filesystem. This SIF cache can be shared across users if permissions are set correctly. If a SIF does not exist in the SIF cache, the image will be pulled from Dockerhub and a warning message will be displayed. The `ervx cache` subcommand can be used to create a local SIF cache. Please see `ervx cache` for more information. This command is extremely useful for avoiding DockerHub pull rate limits. It also remove any potential errors that could occur due to network issues or DockerHub being temporarily unavailable. We recommend running ervx with this option when ever possible. **This option is required on Locus**.
> 
> ***Example:*** `--singularity-cache /data/$USER/SIFs`

> ***Example for Locus:*** `--singularity-cache /hpcdata/dir/NCBR-337/SIFs/`

---  
  `--threads THREADS`   
> **Max number of threads for each process.**  
> *type: int*  
> *default: 2*
> 
> Max number of threads for each process. This option is more applicable when running the pipeline with `--mode local`.  It is recommended setting this vaule to the maximum number of CPUs available on the host machine.
> 
> ***Example:*** `--threads 12`


---  
  `--tmp-dir TMP_DIR`   
> **Max number of threads for each process.**  
> *type: path*  
> *default: `/lscratch/$SLURM_JOBID`*
> 
> Path on the file system for writing temporary output files. By default, the temporary directory is set to '/lscratch/$SLURM_JOBID' for backwards compatibility with the NIH's Biowulf cluster; however, if you are running the pipeline on another cluster, this option will need to be specified. Ideally, this path should point to a dedicated location on the filesystem for writing tmp files. On many systems, this location is set to somewhere in /scratch. If you need to inject a variable into this string that should NOT be expanded, please quote this options value in single quotes. **This option is required on Locus**. On Locus this directory is '/hpcdata/scratch/'.
> 
> ***Example:*** `--tmp-dir /scratch/$USER/`

> ***Example for Locus:*** `--tmp-dir /hpcdata/scratch/`

### 2.4 Miscellaneous options  
Each of the following arguments are optional, and do not need to be provided. 

  `-h, --help`            
> **Display Help.**  
> *type: boolean flag*
> 
> Shows command's synopsis, help message, and an example command
> 
> ***Example:*** `--help`

## 3. Example

### Biowulf
```bash 
# Step 1.) Grab an interactive node,
# do not run on head node!
srun -N 1 -n 1 --time=1:00:00 --mem=8gb  --cpus-per-task=2 --pty bash
module purge
module load singularity snakemake

# Step 2A.) Dry-run the pipeline
module load snakemake singularity
./ervx run \
    --input /data/NCBR/*.fastq.gz \
    --output /data/NCBR/project/results \
    --genome mm10_70 \
    --mode slurm \
    --star-2-pass-basic \
    --sif-cache /data/NCBR/dev/SIFs/ \
    --dry-run

# Step 2B.) Run the ervx pipeline
# The slurm mode will submit jobs to 
# the cluster. It is recommended running 
# the pipeline in this mode.
.module load snakemake singularity
./ervx run \
    --input /data/NCBR/*.fastq.gz \
    --output /data/NCBR/project/results \
    --genome mm10_70 \
    --mode slurm \
    --star-2-pass-basic \
    --sif-cache /data/NCBR/dev/SIFs/
```
### Locus
```bash
# Step 1.) Grab an interactive node,
qrsh -l h_vmem=4G -pe threaded 4
module load snakemake
# Change your working directory
cd ervx/
# On Locus --mode --tmp-dir --shared-resources --sif-cache are required options.
# Step 2A.) Dry-run the pipeline
./ervx run \
    --input /hpcdata/dir/NCBR/*.fastq.gz \
    --output /hpcdata/NCBR/project/results/ \
    --genome mm10_70 \
    --mode uge \
    --star-2-pass-basic \
    --sif-cache /hpcdata/dir/NCBR-337/SIFs/ \
    --tmp-dir /hpcdata/scratch/ \
    --shared-resources /hpcdata/dir/NCBR-337/SHARED_RESOURCES/ \
    --dry-run

# Step 2B.) Run the ervx pipeline
./ervx run \
    --input /hpcdata/dir/NCBR/*.fastq.gz \
    --output /hpcdata/NCBR/project/results/ \
    --genome mm10_70 \
    --mode uge \
    --star-2-pass-basic \
    --sif-cache /hpcdata/dir/NCBR-337/SIFs/ \
    --tmp-dir /hpcdata/scratch/ \
    --shared-resources /hpcdata/dir/NCBR-337/SHARED_RESOURCES/
```
