<div align="center">
   
  <h1>ervx 🔬</h1>
  
  **_Endogenous Retrovirus Expression Pipeline for Human and Mouse_**

  [![tests](https://github.com/OpenOmics/ervx/workflows/tests/badge.svg)](https://github.com/OpenOmics/ervx/actions/workflows/main.yaml) [![docs](https://github.com/OpenOmics/ervx/workflows/docs/badge.svg)](https://github.com/OpenOmics/ervx/actions/workflows/docs.yml) [![GitHub issues](https://img.shields.io/github/issues/OpenOmics/ervx?color=brightgreen)](https://github.com/OpenOmics/ervx/issues)  [![GitHub license](https://img.shields.io/github/license/OpenOmics/ervx)](https://github.com/OpenOmics/ervx/blob/main/LICENSE) 
  
  <i>
    This is the home of the pipeline, ervx. Its long-term goals: to accurately characterize endogenous retrovirus expression like no pipeline before!
  </i>
</div>

## Overview
Welcome to ervx! Before getting started, we highly recommend reading through [ervx's documentation](https://openomics.github.io/ervx/).

The **`./ervx`** pipeline is composed several inter-related sub commands to setup and run the pipeline across different systems. Each of the available sub commands perform different functions: 

 * [<code>ervx <b>run</b></code>](https://openomics.github.io/ervx/usage/run/): Run the ervx pipeline with your input files.
 * [<code>ervx <b>unlock</b></code>](https://openomics.github.io/ervx/usage/unlock/): Unlocks a previous runs output directory.
 * [<code>ervx <b>cache</b></code>](https://openomics.github.io/ervx/usage/cache/): Cache remote resources locally, coming soon!

**ervx** is a comprehensive pipeline to characterize endogenous retrovirus expression in human and mouse samples. It relies on technologies like [Singularity<sup>1</sup>](https://singularity.lbl.gov/) to maintain the highest-level of reproducibility. The pipeline consists of a series of data processing and quality-control steps orchestrated by [Snakemake<sup>2</sup>](https://snakemake.readthedocs.io/en/stable/), a flexible and scalable workflow management system, to submit jobs to a cluster.

The pipeline is compatible with data generated from Illumina short-read sequencing technologies. As input, it accepts a set of FastQ files and can be run locally on a compute instance or on-premise using a cluster. A user can define the method or mode of execution. The pipeline can submit jobs to a cluster using a job scheduler like SLURM and UGE. A hybrid approach ensures the pipeline is accessible to all users.

Before getting started, we highly recommend reading through the [usage](https://openomics.github.io/ervx/usage/run/) section of each available sub command.

For more information about issues or trouble-shooting a problem, please checkout our [FAQ](https://openomics.github.io/ervx/faq/questions/) prior to [opening an issue on Github](https://github.com/OpenOmics/ervx/issues).

## Dependencies
**Requires:** `singularity>=3.5`  `snakemake>=6.0`

At the current moment, the pipeline uses docker images for every step in the pipeline! With that being said, [snakemake](https://snakemake.readthedocs.io/en/stable/getting_started/installation.html) and [singularity](https://singularity.lbl.gov/all-releases) must be installed on the target system. Snakemake orchestrates the execution of each step in the pipeline. To guarantee the highest level of reproducibility, each step of the pipeline will rely on versioned images from [DockerHub](https://hub.docker.com/orgs/nciccbr/repositories). Snakemake uses singularity to pull these images onto the local filesystem prior to job execution, and as so, snakemake and singularity will be the only two dependencies in the future.

## Installation
### Biowulf
Please clone this repository using the following commands:
```bash
# Clone Repository from Github
git clone https://github.com/OpenOmics/ervx.git
# Change your working directory
cd ervx/
# Add dependencies to $PATH
# Biowulf users should run
module load snakemake singularity
# Get usage information
./ervx -h
```

### Locus
Please clone this repository using the following commands:
```bash
# Clone Repository from Github
git clone https://github.com/OpenOmics/ervx.git
# Add dependencies to $PATH
# LOCUS users should run
qrsh -l h_vmem=4G -pe threaded 4
module load snakemake
# Change your working directory
cd ervx/
# Get usage information
./ervx -h
```

## Run
### Biowulf
```bash
module load snakemake singularity
./ervx run \
    --input /data/NCBR/*.fastq.gz \
    --output /data/NCBR/project/results \
    --genome mm10_70 \
    --mode slurm \
    --star-2-pass-basic \
    --sif-cache /data/NCBR/dev/SIFs/ \
    --dry-run
```

### Locus
```bash
module load snakemake
# On Locus --mode --tmp-dir --shared-resources are required arguments.
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
```

## Contribute 
This site is a living document, created for and by members like you. ervx is maintained by the members of OpenOmics and is improved by continous feedback! We encourage you to contribute new content and make improvements to existing content via pull request to our [GitHub repository](https://github.com/OpenOmics/ervx).

## References
<sup>**1.**  Kurtzer GM, Sochat V, Bauer MW (2017). Singularity: Scientific containers for mobility of compute. PLoS ONE 12(5): e0177459.</sup>  
<sup>**2.**  Koster, J. and S. Rahmann (2018). "Snakemake-a scalable bioinformatics workflow engine." Bioinformatics 34(20): 3600.</sup>  
