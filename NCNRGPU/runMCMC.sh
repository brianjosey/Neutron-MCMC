#!/bin/bash
#SBATCH --job-name=sample01                # Job name, max eight characters
#SBATCH --output=a1_%j.log                 # Standard output and error log
#SBATCH --mail-type=ALL                    # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=example@example.mail   # Where to send mail
#SBATCH --nodelist=c1                      # Which computer, c1 or c2.
##SBATCH --nodes=1                         # Number of nodes (how many compute boxes) Commeted out means maximim for this and the following four lines...
##SBATCH --ntasks=1                        # Number of MPI ranks (nodes*ntasks-per-node)
##SBATCH --ntasks-per-node=1               # How many tasks on each box
##SBATCH --cpus-per-task=80                # Number of cpus per MPI rank
##SBATCH --mem-per-cpu=600mb               # Memory per processor
#SBATCH --time=10:00:00                    # Time limit hrs:min:sec, unpolarized take ~ 4.5-6 hours, polarized ~ 9-12 hours.
 
cd $SLURM_SUBMIT_DIR
#mpirun $MPI_OPTIONS ~conda/refl1d/bin/refl1d --batch --mpi model.py --fit=dream --samples=160000 --burn=500 --time=1 --store=`pwd`/a1_out

~conda/refl1d/bin/python3 rs.py -MCMC                   # Runs MCMC calculations, 64000 iterations with burn of 500
~conda/refl1d/bin/python3 rs.py MCMC_64000_500/ -l      # Auto fits last step using correct roughness and MCMC best fit parameters
~conda/refl1d/bin/python3 rs.py -r                      # Prints result of fit
~conda/refl1d/bin/python3 rs.py -cm protein -conf -1    # Calculates properties and +/- 1 STDEV error, saves to CalculationResults.dat
~conda/refl1d/bin/python3 rs.py -bilayerplot            # Creates data for bilayer plots, saves to bilayerplotdata.dat

