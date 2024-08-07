#
# $Id: fftk_ChargeOpt_ESP.tcl,v 1.3 2024/01/11 23:29:55 gumbart Exp $
#
#==============================================================================
namespace eval ::ForceFieldToolKit::ChargeOpt::ESP:: {
    variable chk
    variable gau
	variable gauLog
	set qmProc $::ForceFieldToolKit::Configuration::qmProc
	set qmMem $::ForceFieldToolKit::Configuration::qmMem
	variable qmCharge 0
	variable qmMult 1
	variable qmRoute "#P HF/6-31G* SCF=Tight Geom=Checkpoint Pop=MK IOp(6/33=2,6/41=10,6/42=17)"   
	variable gauFile
	variable psfFile
	variable pdbFile
	variable netCharge 0
	variable ihfree 1
	variable qwt 0.0005
	variable iqopt 2
	variable numAtoms
	variable resName
	variable respPath
	variable bashPath
	variable inputName
	variable newPsfName
	variable espStatus	
    
    variable qmSoft $::ForceFieldToolKit::qmSoft
}
#======================================================
proc ::ForceFieldToolKit::ChargeOpt::ESP::init {} {

    # localize variables
    variable chk
    variable gau

    set qmProc $::ForceFieldToolKit::Configuration::qmProc
    set qmMem $::ForceFieldToolKit::Configuration::qmMem
    variable qmCharge
    variable qmMult
    variable qmRoute

    variable gauLog

    variable qmSoft $::ForceFieldToolKit::qmSoft

    # Set Variables to Initial value
    set chk {}
    set gau {}

    ::ForceFieldToolKit::${qmSoft}::resetDefaultsESP

    set gauLog {}

}

#======================================================
proc ::ForceFieldToolKit::ChargeOpt::ESP::sanityCheck {} {
    # checks to see that appropriate information is set prior to running

    # returns 1 if all input is sane
    # returns 0 if there is a problem

    # localize relevant ChargeOpt::ESP variables

    variable chk
    variable gau

    set qmProc $::ForceFieldToolKit::Configuration::qmProc
    set qmMem $::ForceFieldToolKit::Configuration::qmMem
    variable qmCharge
    variable qmMult
    variable qmRoute

    # local variables
    set errorList {}
    set errorText ""

    # checks
    # make sure that chk is entered and exists
    if { $chk eq "" } {
        lappend errorList "No CHK/OUT/PDB file was specified."
    } else {
        if { ![file exists $chk] } { lappend errorList "Cannot find CHK/OUT file." }
    }

    # make sure that com is enetered and exists
    if { $gau eq "" } {
        lappend errorList "No output path was specified."
    } else {
        if { ![file writable [file dirname $gau]] } { lappend errorList "Cannot write to output path." }
    }

    # validate gaussian settings (not particularly vigorous validation)
    # qmProc (processors)
    if { $qmProc eq "" } { lappend errorList "No processors were specified." }
    if { $qmProc <= 0 || $qmProc != [expr int($qmProc)] } { lappend errorList "Number of processors must be a positive integer." }
    # qmMem (memory)
    if { $qmMem eq "" } { lappend errorList "No memory was specified." }
    if { $qmMem <= 0 || $qmMem != [expr int($qmMem)]} { lappend errorList "Memory must be a postive integer." }
    # qmCharge (charge)
    if { $qmCharge eq "" } { lappend errorList "No charge was specified." }
    if { $qmCharge != [expr int($qmCharge)] } { lappend errorList "Charge must be an integer." }
    # qmMult (multiplicity)
    if { $qmMult eq "" } { lappend errorList "No multiplicity was specified." }
    if { $qmMult < 0 || $qmMult != [expr int($qmMult)] } { lappend errorList "Multiplicity must be a positive integer." }
    # qmRoute (route card for gaussian; just make sure it isn't empty)
    if { $qmRoute eq "" } { lappend errorList "Route card is empty." }

    # if there is an error, tell the user about it
    # return -1 to tell the calling proc that there is a problem
    if { [llength $errorList] > 0 } {
        foreach ele $errorList {
            set errorText [concat $errorText\n$ele]
        }
        tk_messageBox \
            -type ok \
            -icon warning \
            -message "Application halting due to the following errors:" \
            -detail $errorText

        # there are errors, return the error response
        return 0
    }

    # if you've made it this far, there are no errors
    return 1

}
#==============================================================================
proc ::ForceFieldToolKit::ChargeOpt::ESP::calcPTE { element } {
	# procedure to convert element symbol to pte number

	variable pteNum "Not recognized"
	set ExitVar 0

	# define ordered periodic table
	set elementList {H He Li Be B C N O F Ne Na Mg Al Si P S   \
				Cl Ar K Ca Sc Ti V Cr Mn Fe Co Ni Cu Zn Ga Ge  \
				As Se Br Kr Rb Sr Y Zr Nb Mo Tc Ru Rh Pd Ag Cd \
				In Sn Sb Te I Xe Cs Ba La Ce Pr Nd Pm Sm Eu Gd \
				Tb Dy Ho Er Tm Yb Lu Hf Ta W Re Os Ir Pt Au Hg \
				Tl Pb Bi Po At Rn Fr Ra Ac Th Pa U Np Pu Am Cm \
				Bk Cf Es Fm Md No Lr Rf Db Sg Bh Hs Mt Ds Rg}

	# remove extraneous numbers from element name
	set element [string trim $element "0123456789"]	
	for { set k 0 } { $k < [llength $elementList] } { incr k } {
		if { [string equal -nocase $element [lindex $elementList $k]] } {
			set pteNum [expr $k + 1]
			break
		}
	}

        # Print message if file was not recognised
	if { $pteNum eq "Not recognized" } { 	
            tk_messageBox -type ok -icon warning -message "Action halted on error!" -detail "Element name of the following atom was not recognized.\
             Please check atom names in your input PDB/PSF files: ${element}"
	    return $ExitVar
        } 
	# Return atomic number if recognized
	return $pteNum
}
#==============================================================================
proc ::ForceFieldToolKit::ChargeOpt::ESP::formatRESP { num } {
	# formats values for the data file

	variable numExp
	variable Epos
	variable exp
	variable base
	
	set numExp [format %E $num]
	set Epos [string first "E" $numExp]
	set exp [format %+.2i [expr [ scan [string range $numExp [expr $Epos + 1] end] %d ] + 1]] ;# there was a problem with $Epos > -07; the 'scan' solves the issue
	set base [format "% .6f" [expr [string range $numExp 0 [expr $Epos - 1]]/10.0]]
	return "${base}E${exp}"
}
#==============================================================================
proc ::ForceFieldToolKit::ChargeOpt::ESP::writeGauFile {} {
	# writes a QM input file

       variable chk
       set qmProc $::ForceFieldToolKit::Configuration::qmProc
       set qmMem $::ForceFieldToolKit::Configuration::qmMem
       variable qmCharge
       variable qmMult
       variable qmRoute
       variable gau
       variable qmSoft $::ForceFieldToolKit::qmSoft
 
       # sanity check
       if { ![::ForceFieldToolKit::ChargeOpt::ESP::sanityCheck] } { return }

       ::ForceFieldToolKit::${qmSoft}::writeGauFile_ESP $chk $qmProc $qmMem $qmCharge $qmMult $qmRoute $gau 
}
#==============================================================================
proc ::ForceFieldToolKit::ChargeOpt::ESP::writeDatFile {} {
	# writes a data file

        variable inputName
	variable gauLog
        variable qmSoft $::ForceFieldToolKit::qmSoft
        variable espStatus

	set espStatus "Writing data for RESP..."
	update idletasks
	puts -nonewline "Writing data for RESP..."
        ::ForceFieldToolKit::${qmSoft}::writeDatFile_ESP $inputName $gauLog
	puts "Done."
	set espStatus "IDLE"
}
#==============================================================================
proc ::ForceFieldToolKit::ChargeOpt::ESP::writeInFiles {chargeGroups chargeInit restrainData restrainNum} {
	# writes an input file

	variable inFile
	variable treeData
	variable netCharge
	variable ihfree
	variable qwt
	variable iqopt
	variable numAtoms
	variable resName
	#variable chargeGroups
	variable atomNames
	variable psfNum
	variable line
	variable psfFile
	variable pdbFile 
	variable inputName
        
	variable espStatus
        set espStatus "Writing input file..."
        update idletasks
        puts -nonewline "Writing input file..."

	set pdbFile $::ForceFieldToolKit::Configuration::geomOptPDB
	set moleculeID [mol new $psfFile]
	mol addfile $pdbFile
	set selAll [atomselect $moleculeID all]
	set numAtoms [$selAll num]

	# name .in/.qin file based on resname
	set inFile [open ${inputName}.in w]
	set qinFile [open ${inputName}.qin w]

	# begin writing .in file
	puts -nonewline $inFile ${inputName}
	puts $inFile " run #1"
	puts $inFile " &cntrl"
	puts $inFile ""
	puts -nonewline $inFile " ihfree="
	puts -nonewline $inFile $ihfree
	puts $inFile ","
	puts -nonewline $inFile " qwt="
	puts -nonewline $inFile $qwt
	puts $inFile ","
	puts -nonewline $inFile " iqopt="
	puts $inFile $iqopt
	puts $inFile ""
	puts $inFile "&end"
	puts $inFile "   1.0"
	puts $inFile ${inputName}
	if { $netCharge == 0 } {
		puts -nonewline $inFile "  "
		puts -nonewline $inFile $netCharge
	
	} else {
		puts -nonewline $inFile [format " %+d" $netCharge]
	}
	puts -nonewline $inFile "   "
	puts $inFile $numAtoms

	# expands the data so there is precisely one entry per atom
	# atomData: name  charge  restType  restTo
	for { set i 0 } { $i <= [llength $chargeInit] } { incr i } {
		for { set j 0 } { $j < [llength [lindex $chargeGroups $i]] } { incr j } {
			lappend atomData [list [lindex [lindex $chargeGroups $i] $j] [lindex $chargeInit $i] [lindex $restrainData $i] [lindex $restrainNum $i]]
		}
	}

	for {set i 0} { $i < [$selAll num] } {incr i} {
	   # qin file
	   if { [expr $i % 8] == 0 && $i > 0 } {
	      puts $qinFile ""
	   }
	   # find atomData index
	   set temp [atomselect $moleculeID "index $i"]
	   set ind [lsearch -index 0 $atomData [$temp get name]]
	   # in file
   	   puts -nonewline $inFile "  "
	   # get atomic number, but check if element is recognized 
	   set pte [::ForceFieldToolKit::ChargeOpt::ESP::calcPTE [$temp get element]] ;# name was replaced by element
	   if { $pte ne 0} {
	       puts -nonewline $inFile $pte
	   } else {
	       close $inFile
	       close $qinFile
	       return
	   }
	   if { $ind >= 0 } {
              if { [string equal [lindex $atomData $ind 2] "Static"] } {
                 puts $inFile "   -1"
	         puts -nonewline $qinFile [format " % .6f" [lindex $atomData $ind 1]]	         
              } elseif { [string equal [lindex $atomData $ind 2] "Dynamic"] } {
	         puts -nonewline $qinFile [format " % .6f" [lindex $atomData $ind 1]]
	         set restTo [lindex $atomData $ind 3]
                 if { [string equal $restTo [$temp get name]] } {
	            puts -nonewline $inFile "    "
	            puts $inFile 0
	         } else {
		    set selRestTo [atomselect $moleculeID "name $restTo"]	         
	            if { [$selRestTo num] > 0 } {
	               puts -nonewline $inFile "    "
	               puts $inFile [$selRestTo get serial]	               
	            } else {
                      tk_messageBox \
                        -type ok \
                        -icon warning \
                        -message "Application halting on error" \
                        -detail "Atom $restTo not found in the currently loaded molecule!" 
                      # close output and terminate the proc
                      puts $outFile "\nffTK has halted on error. Atom $restTo not found in the currently loaded molecule!\n"; flush $outFile; close $outFile
                      if { $debug } { puts $debugLog "\nffTK has halted on error.  Atom $restTo not found in the currently loaded molecule!\n"; flush $debugLog; close $debugLog }
                      return
	            }
	            $selRestTo delete   
                 }
	      } else {
	         puts $inFile "    0"
	         puts -nonewline $qinFile [format " % .6f" [lindex $atomData $ind 1]]
	      }
	   } else {
             tk_messageBox \
               -type ok \
               -icon warning \
               -message "Application halting on error" \
               -detail "Atom [$temp get name] not found in Charge Constraint list!" 
             # close output and terminate the proc
             puts $outFile "\nffTK has halted on error. Atom [$temp get name] not found in Charge Constraint list!\n"; flush $outFile; close $outFile
             if { $debug } { puts $debugLog "\nffTK has halted on error.  Atom [$temp get name] not found in Charge Constraint list!\n"; flush $debugLog; close $debugLog }
             return
	   }
	   $temp delete
	}
	$selAll delete
	
	puts $inFile ""
	close $inFile
	
	close $qinFile

	mol delete $moleculeID
        puts "Done."
        set espStatus "IDLE"
}
#==============================================================================
# CGM Note: Writing shell files and then running them makes me nervous.  Does this require an external dependency?
#           If this is for a long-running backgroung process we should either tell the user to run the shell script
#           or use a vwait to return interactivity.  this latter approach might necesitate that we write a job manager
#           utility for ffTK.  there are some other processes that would benefit from this as well.
#           ExecTool is only used with linux version?  is this a limitation in ExecTool or lazy coding?
proc ::ForceFieldToolKit::ChargeOpt::ESP::runESP {} {
	# calls RESP from FFTK
	
	variable respPath
	variable bashPath
	variable respDir
	variable bashDir
	variable OS
	variable batFile
	variable shFile
	variable resName
	variable espStatus
	variable inputName
	
	set espStatus "Running..."
	update idletasks
	set OS $::tcl_platform(platform)
	
	# run RESP on Windows
	if { $OS  == "windows" } {

		# create temporary batch and shell files to run RESP
		set batFile [open ${inputName}.bat w+]
		set shFile  [open ${inputName}.sh w+]
		set bashDir [string trimright $bashPath [lrange [file split $bashPath] end end]]
		set respDir [string trimright $respPath ".exe"]
	
		puts $batFile "PATH=${bashDir}"
		puts -nonewline $batFile "bash "
		puts -nonewline $batFile [pwd]
		puts $batFile "/${inputName}.sh"
	
		puts -nonewline $shFile ${respDir} -O -i ${inputName}.in -o ${inputName}.out -p ${inputName}.pch -t ${inputName}.chg -q ${inputName}.qin -e ${inputName}.dat
	
		close $batFile
		close $shFile

		# run RESP and delete batch and shell files
		exec "${inputName}.bat"
		file delete ${inputName}.bat
		file delete ${inputName}.sh
	}

	# run RESP on Unix
	if { $OS == "unix" } {
		::ExecTool::exec $respPath -O -i ${inputName}.in -o ${inputName}.out -p ${inputName}.pch -t ${inputName}.chg -q ${inputName}.qin -e ${inputName}.dat
	}

	set espStatus "IDLE"
	
	puts $espStatus
}
#==============================================================================
# CGM Note: this seems like a guiProc and not a ChargeOpt Proc
proc ::ForceFieldToolKit::ChargeOpt::ESP::updatePSF {} {
	# update the psf with the optimized charges
	
	variable psfFile
	variable newPsfName
	variable inputName

	set optCharges {}

	set pdbFile $::ForceFieldToolKit::Configuration::geomOptPDB
	set moleculeID [mol new $psfFile]
	mol addfile $pdbFile
	set selAll [atomselect $moleculeID all]
	set numAtoms [$selAll num]

	set chg [open ${inputName}.chg r]
        
	while { [gets $chg line] > 0 } {
	   foreach ele $line { 
	      lappend optCharges $ele
	   }
	}
	close $chg

	if { [llength $optCharges] != $numAtoms } {
          tk_messageBox \
              -type ok \
              -icon warning \
              -message "Application halting on error" \
              -detail "The number of charges read from the resp run do not match the number in the currently loaded PSF file.\n" 
          # close output and terminate the proc
          puts $outFile "\nffTK has halted on error. The number of charges read from the resp run do not match the number in the currently loaded PSF file.\n"; flush $outFile; close $outFile
          if { $debug } { puts $debugLog "\nffTK has halted on error.  The number of charges read from the resp run do not match the number in the currently loaded PSF file.\n"; flush $debugLog; close $debugLog }
          return
	}

	for {set i 0} {$i < $numAtoms} {incr i} {
	   set temp [atomselect $moleculeID "index $i"]
	   $temp set charge [lindex $optCharges $i]
	   $temp delete
	}
	$selAll writepsf ${newPsfName}
	$selAll delete
	mol delete $moleculeID
}
#==============================================================================
