#! /bin/bash

# This code analyzes the post-MCMC analysis. It automates all of the steps, excluding exporting to a table and plotting in Igor.
# If this analysis is performed manually, the user would need to enter eleven commands for each sample/file, and respont to the terminal every 2 to 10 minutes.
# Automating allows the user to run the code in the background and focus on other work
# A non-polarized sample takes approximately 20 - 25 minutes per sample, and polarized takes 35 - 40 minutes per sample.

# To run this code, download the MCMC calculations into the appropriate folder and change the path in line 12 to that folder.
# From the terminal go to the file where this is saved, type ./analysis.sh and press enter.
# Don't forget to save the terminal output for later.

for f in ~/path/*;                                          # Direct to the folder one step above the ones containing the calculations
  do
    [ -d $f ];                                              # Cycle through each folder
  	cd "$f";
    echo "Top of analysis step";                            # Creates a landmark for later review
    pwd;                                                    # Prints sample/folder name
    rm Makefile;                                            # Removes cluster versions of Makefile and rs.py
    rm rs.py;
    cp ~/Documents/_ReflScripts/macOS/Makefile .;           # Copies correct versions of Makefile and rs.py into directory
    cp ~/Documents/_ReflScripts/macOS/rs.py .;
    make clean;                                             # Next three steps prepare the directory for fitting and point to ga_refl and python
    make;
    rm gaplot;
    python rs.py MCMC_64000_500/ -l;                        # Auto fits last step using correct roughness and MCMC best fit parameters
    python rs.py -r;                                        # Prints result of fit
    python rs.py -cm protein -conf -1;                      # Calculates properties and +/- 1 STDEV error, saves to CalculationResult.dat
    python rs.py -bilayerplot;                              # Creates data for bilayer plots, saves to bilayerplotdata.dat
    echo "Bottom of analysis step";                         # Creates a second landmark for later review
  done;
