#
# $Id: fftk_guiInterface.tcl,v 1.51 2024/01/11 23:29:55 gumbart Exp $
#

#======================================================
namespace eval ::ForceFieldToolKit::gui {

    # General Variables
    variable w
    variable qmSoft $::ForceFieldToolKit::qmSoft

    # BuildPar Variables
    variable bparIdMissingAnalyzeMolID
    variable bparVDWInputParFile
    variable bparVDWele
    variable bparVDWparSet
    variable bparVDWtvNodeIDs
    variable bparVDWrefComment
    variable bparCGenFFMolID
    variable bparCGenFFTvSort

    # GenZMatrix Variables
    variable gzmAtomLabels
    variable gzmVizSpheresDon
    variable gzmVizSpheresAcc

    # ChargeOpt Variables
    variable coptAtomLabel
    variable coptAtomLabelInd
    variable coptEditGroup
    variable coptEditInit
    variable coptEditLowBound
    variable coptEditUpBound
    variable coptEditLog
    variable coptEditAtomName
    variable coptEditWeight
    variable coptBuildScript
    variable coptEditFinalCharge
    variable coptPSFNewDir
    variable coptPSFNewFilename
    variable coptPrevLogFile
    variable coptStatus
    variable coptFinalChargeTotal

    # ESP ChargeOpt Variables
    variable espEditRestraint
    variable espEditGroup
    variable espEditInit
    variable espEditRestNum

    variable espAtomTypeList

    # BondAngleOpt Variables
    variable baoptParInProg
    variable baoptEditBA
    variable baoptEditDef
    variable baoptEditFC
    variable baoptEditEq
    variable baoptStatus
    variable baoptBuildScript
    variable baoptReturnObjCurrent
    variable baoptReturnObjPrevious

    # GenDihScan Variables
    variable gdsAtomLabels
    variable gdsEditIndDef
    variable gdsEditEqVal
    variable gdsEditPlusMinus
    variable gdsEditStepSize

    # GenImprScan Variables
    variable imsAtomLabels
    variable imsEditIndDef
    variable imsEditEqVal
    variable imsEditPlusMinus
    variable imsEditStepSize

    # DihOpt Variables
    variable doptEditDef
    variable doptEditFC
    variable doptEditMult
    variable doptEditDelta
    variable doptStatus
    variable doptBuildScript
    variable doptQMEStatus
    variable doptMMEStatus
    variable doptDihAllStatus
    variable doptEditColor
    variable doptResultsPlotHandle
    variable doptResultsPlotWin
    variable doptResultsPlotCount
    variable doptP
    variable doptResultsPlotHandle
    variable doptRefineEditDef
    variable doptRefineEditFC
    variable doptRefineEditMult
    variable doptRefineEditDelta
    variable doptRefineStatus
    variable doptRefineCount

    # ImprOpt Variables
    variable imoptEditDef
    variable imoptEditFC
    variable imoptEditMult
    variable imoptEditDelta
    variable imoptStatus
    variable imoptBuildScript
    variable imoptQMEStatus
    variable imoptMMEStatus
    variable imoptImprAllStatus
    variable imoptEditColor
    variable imoptResultsPlotHandle
    variable imoptResultsPlotWin
    variable imoptResultsPlotCount
    variable imoptP
    variable imoptResultsPlotHandle
#    variable imoptRefineEditDef
#    variable imoptRefineEditFC
#    variable imoptRefineEditMult
#    variable imoptRefineEditDelta
#    variable imoptRefineStatus
#    variable imoptRefineCount

    # Misc Variables
    variable psfType
    variable pdbType
    variable parType
    variable topType
    variable gauType
    variable logType
    variable allType
    variable chkType
}
#======================================================



#======================================================
#   GUI SETUP
#======================================================
proc fftk {} {

    return [eval ::ForceFieldToolKit::gui::fftk_gui]

}

proc ::ForceFieldToolKit::gui::fftk_gui {} {
    # Call QM variable
    variable qmSoft $::ForceFieldToolKit::qmSoft

    # STYLE SETUP
    # set variables for controlling element paddings (style)
    set vbuttonPadX 5; # vertically aligned std buttons
    set vbuttonPadY 0
    set hbuttonPadX "5 0"; # horzontally aligned std buttons
    set hbuttonPadY 0
    set buttonRunPadX 10; # large buttons that launch procs
    set buttonRunPadY "0 10"
    set entryPadX 0; # single line entry
    set entryPadY 0
    set hsepPadX 10; # horizontal separators
    set hsepPadY 10
    set vsepPadX 0; # vertical separators
    set vsepPadY 0
    set labelFramePadX 0; # label frames
    set labelFramePadY "10 0"
    set labelFrameInternalPadding 5
    set placeHolderPadX 0; # placeholders for label frames
    set placeHolderPadY "10 0"

    # define some special symbols that are commonly used
    # tree element open and close indicators
    set downPoint \u25BC
    set rightPoint \u25B6
    # accept and cancel indicators
    # old symbols for checkmark (\u2713) and x (\u2715) are unrecognized on most newer linux OSes
    # sqrt is the closest functioning symbol for checkmark.  'x' works for cancel cross
    set accept \u221A
    set cancel x
    # motion indicators
    set upArrow \u2191
    set downArrow \u2193
    # other common symbols
    set ff \uFB00
    set plusMinus \u00B1
    set degree \u00B0
    set theta \u03B8
    set sub0 \u2080

    # setup the theme depending on what is available
    set themeList [ttk::style theme names]
    if { [lsearch -exact $themeList "aqua"] != -1 } {
        ttk::style theme use aqua
        set placeHolderPadX 18
        # better special symbols for accept/cancel are available on mac
        set accept \u2713
        set cancel \u2715
    } elseif { [lsearch -exact $themeList "clam"] != -1 } {
        ttk::style theme use clam
    } elseif { [lsearch -exact $themeList "classic"] != -1 } {
        ttk::style theme use classic
    } else {
        ttk::style theme use default
    }

    # setup type lists for file dialogs
    set ::ForceFieldToolKit::gui::psfType { {{PSF Files} {.psf}} {{All Files} *} }
    set ::ForceFieldToolKit::gui::pdbType { {{PDB Files} {.pdb}} {{All Files} *} }
    set ::ForceFieldToolKit::gui::parType { {{Parameter Files} {.par .prm .inp}} {{All Files} *} }
    set ::ForceFieldToolKit::gui::topType { {{Topology Files} {.top .rtf .inp}} {{All Files} *} }
    set ::ForceFieldToolKit::gui::gauType { {{Gaussian Input Files} {.gau .com}} {{All Files} *} }
    set ::ForceFieldToolKit::gui::AllInpType { {{QM Input Files} {.gau .com .inp}} {{All Files} *} }
    set ::ForceFieldToolKit::gui::ORCAinpType { {{ORCA Input Files} {.inp}} {{All Files} *} }
    set ::ForceFieldToolKit::gui::logType { {{QM/ffTK Log Files} {.log .out}} {{All Files} *} }
    set ::ForceFieldToolKit::gui::AllLogType { {{QM Output Files} {.log .out}} {{All Files} *} }
    set ::ForceFieldToolKit::gui::ORCAoutType { {{ORCA Output Files} {.out}} {{All Files} *} }
    set ::ForceFieldToolKit::gui::allType { {{All Files} *} }
    set ::ForceFieldToolKit::gui::chkType { {{Gaussian Checkpoint Files} {.chk}} {{All Files} *} }
    set ::ForceFieldToolKit::gui::AllChkType { {{QM Checkpoint/Output Files} {.chk .out}} {{All Files} *} }
    set ::ForceFieldToolKit::gui::ESPChkType { {{QM Checkpoint/Output/PDB Files} {.chk .out .pdb}} {{All Files} *} }
    set ::ForceFieldToolKit::gui::molType { {{MOL Files} {.mol2 .pdb}} {{All Files} *} }
    set ::ForceFieldToolKit::gui::strType { {{STR Files} {.str}} {{All Files} *} }

    # Variables to Initialize
    variable w
    # initialize
    ::ForceFieldToolKit::gui::init

    if { [winfo exists .fftk_gui] } {
        wm deiconify .fftk_gui
        return
    }
    set w [toplevel ".fftk_gui"]
    wm title $w "Force Field Toolkit (${ff}TK) GUI"
    # allow .fftk_gui to expand with .
    grid columnconfigure $w 0 -weight 1
    grid rowconfigure $w 0 -weight 1

    # set a default initial geometry
    # note that height will resize as required by gridded components, width does not
    # 800 is a graceful width for all
    wm geometry $w 825x500

    # build/grid a high level frame (hlf) just inside the window to contain the notebook
    ttk::frame $w.hlf
    grid $w.hlf -column 0 -row 0 -sticky nsew
    # allow hlf to resize with window
    grid columnconfigure $w.hlf 0 -weight 1
    grid rowconfigure $w.hlf 0 -weight 1


    # build/grid the notebook (nb)
    # will contain tabs for each major task in parameterization
    # tabs will be added in each individual section as needed (see below)
    ttk::notebook $w.hlf.nb
    grid $w.hlf.nb -column 0 -row 0 -sticky nsew


    # build/grid the console
    ttk::labelframe $w.hlf.console -labelanchor nw -padding $labelFrameInternalPadding
    ttk::label $w.hlf.console.lblWidget -text "GUI Event Log (ON) <click to toggle>" -anchor w -font TkDefaultFont
    $w.hlf.console configure -labelwidget $w.hlf.console.lblWidget
    ttk::label $w.hlf.consolePlaceHolder -text "GUI Event Log (OFF) <click to toggle>" -anchor w -font TkDefaultFont

    # setup mouse bindings to turn console on and off
    bind $w.hlf.console.lblWidget <Button-1> {
        grid remove .fftk_gui.hlf.console
        grid .fftk_gui.hlf.consolePlaceHolder
        set ::ForceFieldToolKit::gui::consoleState 0
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }
    bind $w.hlf.consolePlaceHolder <Button-1> {
        grid remove .fftk_gui.hlf.consolePlaceHolder
        grid .fftk_gui.hlf.console
        set ::ForceFieldToolKit::gui::consoleState 1
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }

    set console $w.hlf.console

    ttk::treeview $console.log -selectmode none -yscrollcommand ".fftk_gui.hlf.console.scroll set"
        $console.log configure -columns {num msg time} -show {} -height 3
        $console.log heading num -text "num"
        $console.log heading msg -text "msg"
        $console.log heading time -text "time"
        $console.log column num -width 50 -stretch 0 -anchor w
        $console.log column msg -width 100 -stretch 1 -anchor w
        $console.log column time -width 200 -stretch 0 -anchor e
    ttk::scrollbar $console.scroll -orient vertical -command ".fftk_gui.hlf.console.log yview"

    grid $console -column 0 -row 1 -sticky nswe -padx 15 -pady "5 0"
    grid columnconfigure $console 0 -weight 1
    grid $console.log -column 0 -row 0 -sticky nswe
    grid $console.scroll -column 1 -row 0 -sticky nswe

    grid $w.hlf.consolePlaceHolder -column 0 -row 1 -sticky nswe -padx 22 -pady 5

    # send message to the console logging startup
    ::ForceFieldToolKit::gui::consoleMessage "ffTK Startup"

    # turn off by default - necessary for screens with limited vertical space
    grid remove $w.hlf.console
    set ::ForceFieldToolKit::gui::consoleState 0
    #::ForceFieldToolKit::gui::resizeToActiveTab
    #grid $w.hlf.consolePlaceHolder


    # ffTK citation
    # construct new fonts
    set fontOpts {}
    foreach {flag val} [font configure TkDefaultFont] {lappend fontOpts $val}
    lassign $fontOpts font_f font_s font_w font_sl font_u font_o
    set font_s [expr {$font_s - 1}] ; # reducing pt size by one looks better next to unformatted text
    if { [lsearch [font names] TkDefaultFontItalic] == -1 } { font create TkDefaultFontItalic -family $font_f -size $font_s -weight $font_w -slant italic -underline $font_u -overstrike $font_o }
    if { [lsearch [font names] TkDefaultFontBold] == -1 } { font create TkDefaultFontBold -family $font_f -size $font_s -weight bold -slant $font_sl -underline $font_u -overstrike $font_o }
    unset fontOpts font_f font_s font_w font_sl font_u font_o

#    ttk::frame $console.citeFrame
#    ttk::label $console.citeFrame.lbl1 -text "To cite ${ff}TK please use:  C.G. Mayne, J. Saam, K. Schulten, E. Tajkhorshid, J.C. Gumbart. "
#    #ttk::label $console.citeFrame.lbl1 -text "To cite ${ff}TK please use:  Mayne, C. G. et al. "
#    ttk::label $console.citeFrame.lbl2 -text "J. Comput. Chem. " -font TkDefaultFontItalic
#    ttk::label $console.citeFrame.lbl3 -text "2013" -font TkDefaultFontBold
#    ttk::label $console.citeFrame.lbl4 -text ", 34, 2757-2770."
#
#    grid $console.citeFrame -column 0 -row 1
#        grid $console.citeFrame.lbl1 -column 1 -row 0
#        grid $console.citeFrame.lbl2 -column 2 -row 0
#        grid $console.citeFrame.lbl3 -column 3 -row 0
#        grid $console.citeFrame.lbl4 -column 4 -row 0

    ttk::frame $w.hlf.citeFrame
    ttk::separator $w.hlf.citeFrame.sep1 -orient horizontal
    ttk::label $w.hlf.citeFrame.lbl1 -text "To cite ${ff}TK please use:  C.G. Mayne, J. Saam, K. Schulten, E. Tajkhorshid, J.C. Gumbart. "
    ttk::label $w.hlf.citeFrame.lbl2 -text "J. Comput. Chem. " -font TkDefaultFontItalic
    ttk::label $w.hlf.citeFrame.lbl3 -text "2013" -font TkDefaultFontBold
    ttk::label $w.hlf.citeFrame.lbl4 -text ", 34, 2757-2770."

    grid $w.hlf.citeFrame -column 0 -row 2 -sticky nswe -padx 15 -pady "0 5"
        grid $w.hlf.citeFrame.sep1 -sticky nwe -column 0 -columnspan 6 -row 0
        grid $w.hlf.citeFrame.lbl1 -column 1 -row 1
        grid $w.hlf.citeFrame.lbl2 -column 2 -row 1
        grid $w.hlf.citeFrame.lbl3 -column 3 -row 1
        grid $w.hlf.citeFrame.lbl4 -column 4 -row 1
    grid columnconfigure $w.hlf.citeFrame {0 5} -weight 1



    #---------------------------------------------------#
    #  BuildPar   tab                                   #
    #---------------------------------------------------#

    # build the frame, add it to the notebook
    ttk::frame $w.hlf.nb.buildpar -width 500 -height 500
    $w.hlf.nb add $w.hlf.nb.buildpar -text "BuildPar"
    # allow frame to change width with window
    grid columnconfigure $w.hlf.nb.buildpar 0 -weight 1

    # for shorter naming convention
    set bpar $w.hlf.nb.buildpar

    # IDENTIFY MISSING PARAMETERS frame
    # ---------------------------------
    # Building an initial parameter file for missing parameters
    ttk::labelframe $bpar.missingPars -labelanchor nw -padding $labelFrameInternalPadding
    ttk::label $bpar.missingPars.lblWidget -text "$downPoint Identify Missing Parameters" -anchor w -font TkDefaultFont
    $bpar.missingPars configure -labelwidget $bpar.missingPars.lblWidget
    ttk::label $bpar.missingParsPlaceHolder -text "$rightPoint Identify Missing Parameters" -anchor w -font TkDefaultFont

    # set mouse click bindings to expand/contract buildpar settings
    bind $bpar.missingPars.lblWidget <Button-1> {
        grid remove .fftk_gui.hlf.nb.buildpar.missingPars
        grid .fftk_gui.hlf.nb.buildpar.missingParsPlaceHolder
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }
    bind $bpar.missingParsPlaceHolder <Button-1> {
        grid remove .fftk_gui.hlf.nb.buildpar.missingParsPlaceHolder
        grid .fftk_gui.hlf.nb.buildpar.missingPars
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }

    # build id missing elements
    ttk::label $bpar.missingPars.psfPathLbl -text "Input PSF File:" -anchor center
    ttk::entry $bpar.missingPars.psfPath -textvariable ::ForceFieldToolKit::BuildPar::idMissingPSF -width 40
    ttk::button $bpar.missingPars.psfPathBrowse -text "Browse" \
        -command {
            set tempfile [tk_getOpenFile -title "Select PSF File" -filetypes $::ForceFieldToolKit::gui::psfType]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::BuildPar::idMissingPSF $tempfile }
        }

    ttk::label $bpar.missingPars.pdbPathLbl -text "Input PDB File:" -anchor center
    ttk::entry $bpar.missingPars.pdbPath -textvariable ::ForceFieldToolKit::BuildPar::idMissingPDB -width 40
    ttk::button $bpar.missingPars.pdbPathBrowse -text "Browse" \
        -command {
            set tempfile [tk_getOpenFile -title "Select PDB File" -filetypes $::ForceFieldToolKit::gui::pdbType]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::BuildPar::idMissingPDB $tempfile }
        }

    ttk::label $bpar.missingPars.parFilesBoxLbl -text "Associated Parameter Files:" -anchor w
    ttk::treeview $bpar.missingPars.parFilesBox -selectmode browse -yscrollcommand "$bpar.missingPars.parScroll set"
        $bpar.missingPars.parFilesBox configure -columns {filename} -show {} -height 3
        $bpar.missingPars.parFilesBox column filename -stretch 1
    ttk::scrollbar $bpar.missingPars.parScroll -orient vertical -command "$bpar.missingPars.parFilesBox yview"
    ttk::button $bpar.missingPars.add -text "Add" \
        -command {
            set tempfiles [tk_getOpenFile -title "Select Parameter File(s)" -multiple 1 -filetypes $::ForceFieldToolKit::gui::parType]
            foreach tempfile $tempfiles {
                if {![string eq $tempfile ""]} { .fftk_gui.hlf.nb.buildpar.missingPars.parFilesBox insert {} end -values [list $tempfile] }
            }
        }
    ttk::button $bpar.missingPars.delete -text "Delete" -command { .fftk_gui.hlf.nb.buildpar.missingPars.parFilesBox delete [.fftk_gui.hlf.nb.buildpar.missingPars.parFilesBox selection] }
    ttk::button $bpar.missingPars.clear -text "Clear" -command { .fftk_gui.hlf.nb.buildpar.missingPars.parFilesBox delete [.fftk_gui.hlf.nb.buildpar.missingPars.parFilesBox children {}] }

    ttk::separator $bpar.missingPars.sep1 -orient horizontal

    # frame for viz missing elements goes here
    ttk::button $bpar.missingPars.analyze -text "Analyze" \
        -command {
            # clear out any existing data
            if { $::ForceFieldToolKit::gui::bparIdMissingAnalyzeMolID != -1 && [lsearch [molinfo list] $::ForceFieldToolKit::gui::bparIdMissingAnalyzeMolID] != -1 } {
                # the ::ForceFieldToolKit::gui::bparIdMissingAnalyzeMolID is set and exists
                ::ForceFieldToolKit::SharedFcns::ParView::clearParViewObjList -::ForceFieldToolKit::gui::bparIdMissingAnalyzeMolID $::ForceFieldToolKit::gui::bparIdMissingAnalyzeMolID
                mol delete $::ForceFieldToolKit::gui::bparIdMissingAnalyzeMolID
                set ::ForceFieldToolKit::gui::bparIdMissingAnalyzeMolID -1
            } elseif { $::ForceFieldToolKit::gui::bparIdMissingAnalyzeMolID != -1 && [lsearch [molinfo list] $::ForceFieldToolKit::gui::bparIdMissingAnalyzeMolID] == -1 } {
                # the ::ForceFieldToolKit::gui::bparIdMissingAnalyzeMolID is set but does not exist (i.e., it has been manually deleted)
                set ::ForceFieldToolKit::SharedFcns::ParView::objList($::ForceFieldToolKit::gui::bparIdMissingAnalyzeMolID) {}
            }
            # set the RefParList
            set ::ForceFieldToolKit::BuildPar::idMissingRefParList {}
            foreach tvItem [.fftk_gui.hlf.nb.buildpar.missingPars.parFilesBox children {}] {
                lappend ::ForceFieldToolKit::BuildPar::idMissingRefParList [lindex [.fftk_gui.hlf.nb.buildpar.missingPars.parFilesBox item $tvItem -values] 0]
            }
            # run the proc
            ::ForceFieldToolKit::gui::bparAnalyzeMissingPars
        }
    ttk::separator $bpar.missingPars.sep2 -orient horizontal

    ttk::frame $bpar.missingPars.vizFrame
        ttk::label $bpar.missingPars.vizFrame.bondsLbl -text "Bonds" -anchor w
        ttk::treeview $bpar.missingPars.vizFrame.bondsTv -selectmode extended -yscrollcommand "$bpar.missingPars.vizFrame.bondsScroll set"
            $bpar.missingPars.vizFrame.bondsTv configure -columns {type1 type2 active indsList} -displaycolumns {type1 type2} -show {} -height 4
            foreach col {type1 type2} {
                $bpar.missingPars.vizFrame.bondsTv heading $col -text $col
                $bpar.missingPars.vizFrame.bondsTv column $col -width 50 -stretch 1 -anchor center
            }

        ttk::label $bpar.missingPars.vizFrame.anglesLbl -text "Angles" -anchor w
        ttk::treeview $bpar.missingPars.vizFrame.anglesTv -selectmode extended -yscrollcommand "$bpar.missingPars.vizFrame.anglesScroll set"
            $bpar.missingPars.vizFrame.anglesTv configure -columns {type1 type2 type3 active indsList} -displaycolumns {type1 type2 type3} -show {} -height 4
            foreach col {type1 type2 type3} {
                $bpar.missingPars.vizFrame.anglesTv heading $col -text $col
                $bpar.missingPars.vizFrame.anglesTv column $col -width 50 -stretch 1 -anchor center
            }

        ttk::label $bpar.missingPars.vizFrame.dihedralsLbl -text "Dihedrals" -anchor w
        ttk::treeview $bpar.missingPars.vizFrame.dihedralsTv -selectmode extended -yscrollcommand "$bpar.missingPars.vizFrame.dihedralsScroll set"
            $bpar.missingPars.vizFrame.dihedralsTv configure -columns {type1 type2 type3 type4 active indsList} -displaycolumns {type1 type2 type3 type4} -show {} -height 4
            foreach col {type1 type2 type3 type4} {
                $bpar.missingPars.vizFrame.dihedralsTv heading $col -text $col
                $bpar.missingPars.vizFrame.dihedralsTv column $col -width 50 -stretch 1 -anchor center
            }

        ttk::label $bpar.missingPars.vizFrame.nonbondedLbl -text "Nonbonded" -anchor w
        ttk::treeview $bpar.missingPars.vizFrame.nonbondedTv -selectmode extended -yscrollcommand "$bpar.missingPars.vizFrame.nonbondedScroll set"
            $bpar.missingPars.vizFrame.nonbondedTv configure -columns {type active indsList} -displaycolumns {type} -show {} -height 4
            $bpar.missingPars.vizFrame.nonbondedTv heading type -text "type"
            $bpar.missingPars.vizFrame.nonbondedTv column type -width 50 -stretch 1 -anchor center

        # tv scrollbars (programatic created)
        foreach tv {bonds angles dihedrals nonbonded} { ttk::scrollbar $bpar.missingPars.vizFrame.${tv}Scroll -orient vertical -command "$bpar.missingPars.vizFrame.${tv}Tv yview" }

        # tv bindings (programatic applied)
        foreach tv {bondsTv anglesTv dihedralsTv nonbondedTv} {
            # selection change
            bind $bpar.missingPars.vizFrame.${tv} <<TreeviewSelect>> "::ForceFieldToolKit::gui::bparShowMissingParsElements"
            # deselect all
            bind $bpar.missingPars.vizFrame.${tv} <KeyPress-Escape> ".fftk_gui.hlf.nb.buildpar.missingPars.vizFrame.${tv} selection remove \[.fftk_gui.hlf.nb.buildpar.missingPars.vizFrame.${tv} children {}\]"
            # deselect one
            bind $bpar.missingPars.vizFrame.${tv} <ButtonPress-2> "
                set currID \[.fftk_gui.hlf.nb.buildpar.missingPars.vizFrame.${tv} identify row %x %y\]
                if { \[lsearch \[.fftk_gui.hlf.nb.buildpar.missingPars.vizFrame.${tv} selection\] \$currID\] != -1 } { .fftk_gui.hlf.nb.buildpar.missingPars.vizFrame.${tv} selection remove \$currID }
            "
            # state change on double-click
            .fftk_gui.hlf.nb.buildpar.missingPars.vizFrame.${tv} tag configure inactive -foreground gray
            bind $bpar.missingPars.vizFrame.${tv} <Double-ButtonPress-1> "::ForceFieldToolKit::gui::bparToggleStateMissingPars $tv"
        }


    # end of viz frame
    ttk::separator $bpar.missingPars.sep3 -orient horizontal

    ttk::label $bpar.missingPars.outPathLbl -text "Output PAR File:" -anchor center
    ttk::entry $bpar.missingPars.outPath -textvariable ::ForceFieldToolKit::BuildPar::idMissingParOutPath -width 40
    ttk::button $bpar.missingPars.outPathBrowse -text "SaveAs" \
        -command {
            set temppath [tk_getSaveFile -title "Save the Initial Parameter File As..." -filetypes $::ForceFieldToolKit::gui::parType -defaultextension {.par}]
            if {![string eq $temppath ""]} { set ::ForceFieldToolKit::BuildPar::idMissingParOutPath $temppath }
        }

    ttk::separator $bpar.missingPars.sep4 -orient horizontal

    ttk::button $bpar.missingPars.buildInitParFile -text "Write Initial Parameter File" \
        -command {
            # construct lists of the active parameters
            set bondlist {}
            foreach tvItem [.fftk_gui.hlf.nb.buildpar.missingPars.vizFrame.bondsTv children {}] {
                set state [.fftk_gui.hlf.nb.buildpar.missingPars.vizFrame.bondsTv set $tvItem active]
                lassign [lrange [.fftk_gui.hlf.nb.buildpar.missingPars.vizFrame.bondsTv item $tvItem -values ] 0 1] b1 b2
                if { $state } {
                    lappend bondlist [list $b1 $b2]
                } else {
                    lappend bondlist [list "!${b1}" $b2]
                }
                unset state b1 b2
            }
            set anglelist {}
            foreach tvItem [.fftk_gui.hlf.nb.buildpar.missingPars.vizFrame.anglesTv children {}] {
                set state [.fftk_gui.hlf.nb.buildpar.missingPars.vizFrame.anglesTv set $tvItem active]
                lassign [lrange [.fftk_gui.hlf.nb.buildpar.missingPars.vizFrame.anglesTv item $tvItem -values ] 0 2] a1 a2 a3
                if { $state } {
                    lappend anglelist [list $a1 $a2 $a3]
                } else {
                    lappend anglelist [list "!${a1}" $a2 $a3]
                }
                unset state a1 a2 a3
            }
            set dihlist {}
            foreach tvItem [.fftk_gui.hlf.nb.buildpar.missingPars.vizFrame.dihedralsTv children {}] {
                set state [.fftk_gui.hlf.nb.buildpar.missingPars.vizFrame.dihedralsTv set $tvItem active]
                lassign [lrange [.fftk_gui.hlf.nb.buildpar.missingPars.vizFrame.dihedralsTv item $tvItem -values ] 0 3] d1 d2 d3 d4
                if { $state } {
                    lappend dihlist [list $d1 $d2 $d3 $d4]
                } else {
                    lappend dihlist [list "!${d1}" $d2 $d3 $d4]
                }
                unset state d1 d2 d3 d4
            }
            set nonblist {}
            foreach tvItem [.fftk_gui.hlf.nb.buildpar.missingPars.vizFrame.nonbondedTv children {}] {
                set state [.fftk_gui.hlf.nb.buildpar.missingPars.vizFrame.nonbondedTv set $tvItem active]
                set nb [.fftk_gui.hlf.nb.buildpar.missingPars.vizFrame.nonbondedTv set $tvItem type]
                if { $state } {
                    lappend nonblist $nb
                } else {
                    lappend nonblist "!${nb}"
                }
                unset state nb
            }
            # send the data to the proc
            ::ForceFieldToolKit::BuildPar::buildInitParFile [list $bondlist $anglelist $dihlist $nonblist]
        }

    ttk::label $bpar.missingPars.warning -foreground red -text "WARNING: Assign missing LJ parameters prior to using initial parameter file." -anchor center

    # Grid id missing elements
    grid $bpar.missingPars -column 0 -row 0 -sticky nswe -padx $labelFramePadX -pady $labelFramePadY
    grid columnconfigure $bpar.missingPars 1 -weight 1
    grid rowconfigure $bpar.missingPars {0 1 3 4 5 12} -uniform rt1
    grid rowconfigure $bpar.missingPars 6 -weight 1
    grid rowconfigure $bpar.missingPars {8 15} -minsize 50 -weight 0
    grid remove $bpar.missingPars
    grid $bpar.missingParsPlaceHolder -column 0 -row 0 -sticky nswe -padx $placeHolderPadX -pady $placeHolderPadY

    grid $bpar.missingPars.psfPathLbl     -column 0 -row 0 -sticky nswe
    grid $bpar.missingPars.psfPath        -column 1 -row 0 -columnspan 2 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $bpar.missingPars.psfPathBrowse  -column 3 -row 0 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY

    grid $bpar.missingPars.pdbPathLbl     -column 0 -row 1 -sticky nswe
    grid $bpar.missingPars.pdbPath        -column 1 -row 1 -columnspan 2 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $bpar.missingPars.pdbPathBrowse  -column 3 -row 1 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY

    grid $bpar.missingPars.parFilesBoxLbl  -column 0 -row 2 -columnspan 2 -sticky nswe
    grid $bpar.missingPars.parFilesBox     -column 0 -row 3 -columnspan 2 -rowspan 4 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $bpar.missingPars.parScroll       -column 2 -row 3 -rowspan 4 -sticky nswe
    grid $bpar.missingPars.add             -column 3 -row 3 -sticky nwe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $bpar.missingPars.delete          -column 3 -row 4 -sticky nwe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $bpar.missingPars.clear           -column 3 -row 5 -sticky nwe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $bpar.missingPars.sep1            -column 0 -row 7 -columnspan 4 -sticky we -padx $hsepPadX -pady $hsepPadY

    # frame for viz missing elements goes here
    grid $bpar.missingPars.analyze         -column 0 -row 8 -columnspan 4 -sticky nswe -padx $buttonRunPadX -pady $buttonRunPadY
    grid $bpar.missingPars.sep2            -column 0 -row 9 -columnspan 4 -sticky we -padx $hsepPadX -pady "0 $hsepPadY"

    grid $bpar.missingPars.vizFrame        -column 0 -row 10 -columnspan 4 -sticky nswe -padx "0 $vbuttonPadX"
        grid $bpar.missingPars.vizFrame.bondsLbl        -column 0 -row 0 -sticky nswe
        grid $bpar.missingPars.vizFrame.bondsTv         -column 0 -row 1 -sticky nswe
        grid $bpar.missingPars.vizFrame.bondsScroll      -column 1 -row 1 -sticky ns -padx "0 5"

        grid $bpar.missingPars.vizFrame.anglesLbl       -column 2 -row 0 -sticky nswe
        grid $bpar.missingPars.vizFrame.anglesTv        -column 2 -row 1 -sticky nswe
        grid $bpar.missingPars.vizFrame.anglesScroll     -column 3 -row 1 -sticky ns -padx "0 5"

        grid $bpar.missingPars.vizFrame.dihedralsLbl    -column 4 -row 0 -sticky nswe
        grid $bpar.missingPars.vizFrame.dihedralsTv     -column 4 -row 1 -sticky nswe
        grid $bpar.missingPars.vizFrame.dihedralsScroll  -column 5 -row 1 -sticky ns -padx "0 5"

        grid $bpar.missingPars.vizFrame.nonbondedLbl    -column 6 -row 0 -sticky nswe
        grid $bpar.missingPars.vizFrame.nonbondedTv     -column 6 -row 1 -sticky nswe
        grid $bpar.missingPars.vizFrame.nonbondedScroll -column 7 -row 1 -sticky ns -padx "0 5"

        grid columnconfigure $bpar.missingPars.vizFrame {0 2 4 6} -minsize 50
        grid columnconfigure $bpar.missingPars.vizFrame 0 -weight 2
        grid columnconfigure $bpar.missingPars.vizFrame 2 -weight 3
        grid columnconfigure $bpar.missingPars.vizFrame 4 -weight 4
        grid columnconfigure $bpar.missingPars.vizFrame 6 -weight 1
        grid columnconfigure $bpar.missingPars.vizFrame {1 3 5 7} -weight 0

    # end of viz frame
    grid $bpar.missingPars.sep3            -column 0 -row 11 -columnspan 4 -sticky we -padx $hsepPadX -pady $hsepPadY
    grid $bpar.missingPars.outPathLbl      -column 0 -row 12 -sticky nswe
    grid $bpar.missingPars.outPath         -column 1 -row 12 -columnspan 2 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $bpar.missingPars.outPathBrowse   -column 3 -row 12 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $bpar.missingPars.sep4            -column 0 -row 14 -columnspan 4 -sticky we -padx $hsepPadX -pady $hsepPadY
    grid $bpar.missingPars.buildInitParFile -column 0 -row 15 -columnspan 4 -sticky nswe -padx $buttonRunPadX -pady $buttonRunPadY
    grid $bpar.missingPars.warning         -column 0 -row 16 -columnspan 4 -sticky nswe -padx 10 -pady "5 10"


    # ASSIGN MISSING VDW frame
    # ------------------------
    # Build frame for assigning missing VDW parameters
    ttk::labelframe $bpar.vdwPars -labelanchor nw -padding $labelFrameInternalPadding
    ttk::label $bpar.vdwPars.lblWidget -text "$downPoint Assign Missing VDW/LJ Parameters by Analogy" -anchor w -font TkDefaultFont
    $bpar.vdwPars configure -labelwidget $bpar.vdwPars.lblWidget
    ttk::label $bpar.vdwParsPlaceHolder -text "$rightPoint Assign Missing VDW/LJ Parameters by Analogy" -anchor w -font TkDefaultFont

    # set mouse click bindings to expand/contract buildpar vdw settings
    bind $bpar.vdwPars.lblWidget <Button-1> {
        grid remove .fftk_gui.hlf.nb.buildpar.vdwPars
        grid .fftk_gui.hlf.nb.buildpar.vdwParsPlaceHolder
        grid rowconfigure .fftk_gui.hlf.nb.buildpar 1 -weight 0
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }
    bind $bpar.vdwParsPlaceHolder <Button-1> {
        grid remove .fftk_gui.hlf.nb.buildpar.vdwParsPlaceHolder
        grid .fftk_gui.hlf.nb.buildpar.vdwPars
        grid rowconfigure .fftk_gui.hlf.nb.buildpar 1 -weight 1
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }

    # grid the overall frame
    grid $bpar.vdwPars -column 0 -row 1 -sticky nswe -padx $labelFramePadX -pady $labelFramePadY
    grid columnconfigure $bpar.vdwPars 0 -weight 1
    grid remove $bpar.vdwPars
    grid $bpar.vdwParsPlaceHolder -column 0 -row 1 -sticky nswe -padx $placeHolderPadX -pady $placeHolderPadY


    # build vdw input elements
    ttk::frame $bpar.vdwPars.input
    ttk::label $bpar.vdwPars.input.lbl -text "Incomplete PAR File:" -anchor w
    ttk::entry $bpar.vdwPars.input.parfile -textvariable ::ForceFieldToolKit::gui::bparVDWInputParFile
    ttk::button $bpar.vdwPars.input.browse -text "Browse" \
        -command {
            set tempfile [tk_getOpenFile -title "Select a Parameter File" -filetypes $::ForceFieldToolKit::gui::parType]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::gui::bparVDWInputParFile $tempfile }
        }
    ttk::button $bpar.vdwPars.input.load -text "Load" \
        -command {
            # simple validation
            if { $::ForceFieldToolKit::gui::bparVDWInputParFile eq "" || ![file exists $::ForceFieldToolKit::gui::bparVDWInputParFile] } {
                tk_messageBox -type ok -icon warning -message "Action halted on error!" -detail "Cannot find input parameter file."
                return
            }
            # load vdw data into the TV box
            .fftk_gui.hlf.nb.buildpar.vdwPars.missingPars.tv delete [.fftk_gui.hlf.nb.buildpar.vdwPars.missingPars.tv children {}]
            set vdws [lindex [::ForceFieldToolKit::SharedFcns::readParFile $::ForceFieldToolKit::gui::bparVDWInputParFile] end]
            foreach ele $vdws {
                set type [lindex $ele 0]
                set eps [lindex $ele 1 0]
                set rmin [lindex $ele 1 1]
                set eps14 [lindex $ele 2 0]
                set rmin14 [lindex $ele 2 1]
                .fftk_gui.hlf.nb.buildpar.vdwPars.missingPars.tv insert {} end -values [list $type $eps $rmin $eps14 $rmin14]
                unset type eps rmin eps14 rmin14
            }
            unset vdws
            ::ForceFieldToolKit::gui::consoleMessage "Incomplete PAR file loaded"
        }
    ttk::button $bpar.vdwPars.input.update -text "Update File" \
        -command {
            # simple validation
            if { $::ForceFieldToolKit::gui::bparVDWInputParFile eq "" || ![file exists $::ForceFieldToolKit::gui::bparVDWInputParFile] || ![file writable $::ForceFieldToolKit::gui::bparVDWInputParFile] } {
                tk_messageBox -type ok -icon warning -message "Action halted on error!" -detail "Cannot find input parameter file."
                return
            } elseif { [llength [.fftk_gui.hlf.nb.buildpar.vdwPars.missingPars.tv children {}]] == 0 } {
                tk_messageBox -type ok -icon warning -message "Action halted on error!" -detail "No VDW/LJ parameters to update."
                return
            }
            # update the vdw/lj parameters based on what's in tv box
            set inputParData [::ForceFieldToolKit::SharedFcns::readParFile $::ForceFieldToolKit::gui::bparVDWInputParFile]
            set vdws {}
            foreach ele [.fftk_gui.hlf.nb.buildpar.vdwPars.missingPars.tv children {}] {
                set vdwData [.fftk_gui.hlf.nb.buildpar.vdwPars.missingPars.tv item $ele -values]
                set type [lindex $vdwData 0]
                set eps [lindex $vdwData 1]
                set rmin [lindex $vdwData 2]
                set eps14 [lindex $vdwData 3]
                set rmin14 [lindex $vdwData 4]
                lappend vdws [list $type [list $eps $rmin] [list $eps14 $rmin14] {}]
            }
            lset inputParData end $vdws
            ::ForceFieldToolKit::SharedFcns::writeParFile $inputParData $::ForceFieldToolKit::gui::bparVDWInputParFile
            ::ForceFieldToolKit::gui::consoleMessage "Incomplete PAR file updated (overwritten)"
        }

    # grid vdw input elements
    grid $bpar.vdwPars.input -column 0 -row 0 -sticky nswe
    grid columnconfigure $bpar.vdwPars.input 1 -weight 1
    grid columnconfigure $bpar.vdwPars.input {2 3 4} -uniform ct1

    grid $bpar.vdwPars.input.lbl -column 0 -row 0 -sticky nswe
    grid $bpar.vdwPars.input.parfile -column 1 -row 0 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $bpar.vdwPars.input.browse -column 2 -row 0 -sticky nswe -padx $hbuttonPadX -pady $hbuttonPadY
    grid $bpar.vdwPars.input.load -column 3 -row 0 -sticky nswe -padx $hbuttonPadX -pady $hbuttonPadY
    grid $bpar.vdwPars.input.update -column 4 -row 0 -sticky nswe -padx $hbuttonPadX -pady $hbuttonPadY

    # build vdw parameter elements
    ttk::frame $bpar.vdwPars.missingPars
    ttk::label $bpar.vdwPars.missingPars.lbl -text "VDW/LJ Parameters" -anchor w
    ttk::label $bpar.vdwPars.missingPars.typeLbl -text "Type" -anchor center
    ttk::label $bpar.vdwPars.missingPars.epsLbl -text "Epsilon" -anchor center
    ttk::label $bpar.vdwPars.missingPars.rminLbl -text "Rmin/2" -anchor center
    ttk::label $bpar.vdwPars.missingPars.eps14Lbl -text "Epsilon,1-4" -anchor center
    ttk::label $bpar.vdwPars.missingPars.rmin14Lbl -text "Rmin/2,1-4" -anchor center
    ttk::treeview $bpar.vdwPars.missingPars.tv -selectmode browse -yscroll "$bpar.vdwPars.missingPars.scroll set"
        $bpar.vdwPars.missingPars.tv configure -column {type eps rmin eps14 rmin14} -show {} -height 3
        $bpar.vdwPars.missingPars.tv heading type -text "Type" -anchor center
        $bpar.vdwPars.missingPars.tv heading eps -text "Epsilon" -anchor center
        $bpar.vdwPars.missingPars.tv heading rmin -text "Rmin/2" -anchor center
        $bpar.vdwPars.missingPars.tv heading eps14 -text "Epsilon,1-4" -anchor center
        $bpar.vdwPars.missingPars.tv heading rmin14 -text "Rmin/2,1-4" -anchor center
        $bpar.vdwPars.missingPars.tv column type -width 100 -stretch 1 -anchor center
        $bpar.vdwPars.missingPars.tv column eps -width 100 -stretch 1 -anchor center
        $bpar.vdwPars.missingPars.tv column rmin -width 100 -stretch 1 -anchor center
        $bpar.vdwPars.missingPars.tv column eps14 -width 100 -stretch 1 -anchor center
        $bpar.vdwPars.missingPars.tv column rmin14 -width 100 -stretch 1 -anchor center
    ttk::scrollbar $bpar.vdwPars.missingPars.scroll -orient vertical -command "$bpar.vdwPars.missingPars.tv yview"

    ttk::button $bpar.vdwPars.missingPars.setFromRef -text "Set from Reference" \
        -command {
            if { [.fftk_gui.hlf.nb.buildpar.vdwPars.missingPars.tv selection] == {} || [.fftk_gui.hlf.nb.buildpar.vdwPars.refvdw.tv selection] == {} } {
                return
            } else {
                set refPars [.fftk_gui.hlf.nb.buildpar.vdwPars.refvdw.tv set [.fftk_gui.hlf.nb.buildpar.vdwPars.refvdw.tv selection] ljPars]
                .fftk_gui.hlf.nb.buildpar.vdwPars.missingPars.tv set [.fftk_gui.hlf.nb.buildpar.vdwPars.missingPars.tv selection] eps [lindex $refPars 0 0]
                .fftk_gui.hlf.nb.buildpar.vdwPars.missingPars.tv set [.fftk_gui.hlf.nb.buildpar.vdwPars.missingPars.tv selection] rmin [lindex $refPars 0 1]
                .fftk_gui.hlf.nb.buildpar.vdwPars.missingPars.tv set [.fftk_gui.hlf.nb.buildpar.vdwPars.missingPars.tv selection] eps14 [lindex $refPars 1 0]
                .fftk_gui.hlf.nb.buildpar.vdwPars.missingPars.tv set [.fftk_gui.hlf.nb.buildpar.vdwPars.missingPars.tv selection] rmin14 [lindex $refPars 1 1]
            }
        }

    # grid vdw parameter elements
    grid rowconfigure $bpar.vdwPars 1 -weight 1
    grid $bpar.vdwPars.missingPars -column 0 -row 1 -sticky nswe
    grid columnconfigure $bpar.vdwPars.missingPars {0 1 2 3 4} -weight 1 -minsize 10 -uniform ct1
    grid rowconfigure $bpar.vdwPars.missingPars 2 -weight 1

    grid $bpar.vdwPars.missingPars.lbl -column 0 -row 0 -columnspan 4 -sticky nswe
    grid $bpar.vdwPars.missingPars.typeLbl -column 0 -row 1 -sticky nswe
    grid $bpar.vdwPars.missingPars.epsLbl -column 1 -row 1 -sticky nswe
    grid $bpar.vdwPars.missingPars.rminLbl -column 2 -row 1 -sticky nswe
    grid $bpar.vdwPars.missingPars.eps14Lbl -column 3 -row 1 -sticky nswe
    grid $bpar.vdwPars.missingPars.rmin14Lbl -column 4 -row 1 -sticky nswe

    grid $bpar.vdwPars.missingPars.tv -column 0 -row 2 -columnspan 5 -sticky nswe -pady "0 10"
    grid $bpar.vdwPars.missingPars.scroll -column 5 -row 2 -sticky nswe -pady "0 10"

    grid $bpar.vdwPars.missingPars.setFromRef -column 1 -columnspan 3 -row 3 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY


    # build/grid a separator
    ttk::frame $bpar.vdwPars.sepFrame
    ttk::separator $bpar.vdwPars.sepFrame.sep1 -orient horizontal
    ttk::separator $bpar.vdwPars.sepFrame.sep2 -orient horizontal

    grid $bpar.vdwPars.sepFrame -column 0 -row 2 -sticky nswe
    grid columnconfigure $bpar.vdwPars.sepFrame 0 -weight 1
    grid $bpar.vdwPars.sepFrame.sep1 -column 0 -row 0 -sticky nswe -padx $hsepPadX -pady "10 2"
    grid $bpar.vdwPars.sepFrame.sep2 -column 0 -row 1 -sticky nswe -padx $hsepPadX -pady "2 10"



    # build vdw reference parameter loader
    ttk::frame $bpar.vdwPars.refvdw
    ttk::label $bpar.vdwPars.refvdw.lbl -text "Reference Parameter Set Browser" -anchor center -font "TkHeadingFont"
    ttk::label $bpar.vdwPars.refvdw.eleLbl -text "Element" -anchor w
    ttk::menubutton $bpar.vdwPars.refvdw.ele -direction below -menu $bpar.vdwPars.refvdw.ele.menu -textvariable ::ForceFieldToolKit::gui::bparVDWele
    menu $bpar.vdwPars.refvdw.ele.menu -tearoff no
    ttk::label $bpar.vdwPars.refvdw.parSetLbl -text "Parameter Set" -anchor w
    ttk::menubutton $bpar.vdwPars.refvdw.parSet -direction below -menu $bpar.vdwPars.refvdw.parSet.menu -textvariable ::ForceFieldToolKit::gui::bparVDWparSet
    menu $bpar.vdwPars.refvdw.parSet.menu -tearoff no
    ttk::button $bpar.vdwPars.refvdw.load -text "Load Topology + Parameter Set" -command { ::ForceFieldToolKit::gui::bparLoadRefVDWData }
    ttk::button $bpar.vdwPars.refvdw.clear -text "Clear" \
        -command {
            .fftk_gui.hlf.nb.buildpar.vdwPars.refvdw.tv delete [.fftk_gui.hlf.nb.buildpar.vdwPars.refvdw.tv children {}]
            set ::ForceFieldToolKit::gui::bparVDWtvNodeIDs {}
            .fftk_gui.hlf.nb.buildpar.vdwPars.refvdw.ele.menu delete 0 end
            .fftk_gui.hlf.nb.buildpar.vdwPars.refvdw.parSet.menu delete 0 end
            set ::ForceFieldToolKit::gui::bparVDWele {}
            set ::ForceFieldToolKit::gui::bparVDWparSet {}
            set ::ForceFieldToolKit::gui::bparVDWrefComment {}

            # message the console
            ::ForceFieldToolKit::gui::consoleMessage "Ref. VDW/LJ parameter set(s) cleared"
        }

    ttk::treeview $bpar.vdwPars.refvdw.tv -selectmode browse -yscrollcommand "$bpar.vdwPars.refvdw.scroll set"
        $bpar.vdwPars.refvdw.tv configure -column {ele type ljPars filename comments} -display {ele type ljPars filename} -show {headings} -height 5
        $bpar.vdwPars.refvdw.tv heading ele -text "Ele"
        $bpar.vdwPars.refvdw.tv heading type -text "Type"
        $bpar.vdwPars.refvdw.tv heading ljPars -text "VDW/LJ Parameters"
        $bpar.vdwPars.refvdw.tv heading filename -text "Filename"
        $bpar.vdwPars.refvdw.tv column ele -width 50 -stretch 0 -anchor center
        $bpar.vdwPars.refvdw.tv column type -width 100 -stretch 0 -anchor center
        $bpar.vdwPars.refvdw.tv column ljPars -width 300 -stretch 0 -anchor center
        $bpar.vdwPars.refvdw.tv column filename -width 150 -stretch 1 -anchor w
    ttk::scrollbar $bpar.vdwPars.refvdw.scroll -orient vertical -command "$bpar.vdwPars.refvdw.tv yview"

    ttk::label $bpar.vdwPars.refvdw.commentLbl -text "Parameter Comment(s):" -anchor w
    ttk::label $bpar.vdwPars.refvdw.comment -textvariable ::ForceFieldToolKit::gui::bparVDWrefComment -anchor w

    # grid vdw reference parameter loader
    grid rowconfigure $bpar.vdwPars 3 -weight 3
    grid $bpar.vdwPars.refvdw -column 0 -row 3 -sticky nswe
    grid columnconfigure $bpar.vdwPars.refvdw {4} -weight 1
    grid columnconfigure $bpar.vdwPars.refvdw 0 -minsize 75
    grid columnconfigure $bpar.vdwPars.refvdw 1 -minsize 200

    grid $bpar.vdwPars.refvdw.lbl -column 0 -row 0 -columnspan 6 -sticky nswe
    grid $bpar.vdwPars.refvdw.eleLbl -column 0 -row 1 -sticky nswe
    grid $bpar.vdwPars.refvdw.ele -column 0 -row 2 -sticky nswe;# -padx $hbuttonPadX -pady $hbuttonPadY
    grid $bpar.vdwPars.refvdw.parSetLbl -column 1 -row 1 -sticky nswe
    grid $bpar.vdwPars.refvdw.parSet -column 1 -row 2 -sticky nswe -padx $hbuttonPadX -pady $hbuttonPadY

    grid $bpar.vdwPars.refvdw.load -column 2 -row 2 -sticky nswe -padx $hbuttonPadX -pady $hbuttonPadY
    grid $bpar.vdwPars.refvdw.clear -column 3 -row 2 -sticky nswe -padx $hbuttonPadX -pady $hbuttonPadY

    grid rowconfigure $bpar.vdwPars.refvdw 3 -weight 1
    grid $bpar.vdwPars.refvdw.tv -column 0 -row 3 -columnspan 5 -sticky nswe
    grid $bpar.vdwPars.refvdw.scroll -column 5 -row 3 -sticky nswe

    grid $bpar.vdwPars.refvdw.commentLbl -column 0 -row 4 -columnspan 6 -sticky nswe
    grid $bpar.vdwPars.refvdw.comment -column 0 -row 5 -columnspan 6 -sticky nswe -padx "10 0"

    # set a binding to copy the comments from tv to the label
    bind $bpar.vdwPars.refvdw.tv <<TreeviewSelect>> {
        set tvcomments {}
        foreach entry [.fftk_gui.hlf.nb.buildpar.vdwPars.refvdw.tv set [.fftk_gui.hlf.nb.buildpar.vdwPars.refvdw.tv selection] comments] {
            set tvcomments [concat $tvcomments\n$entry]
        }
        set ::ForceFieldToolKit::gui::bparVDWrefComment $tvcomments
    }


    # PREPARE PARAMETERIZATION FROM CGENFF (the program) OUTPUT
    # ---------------------------
    # These tools will provide convenient interfact to construct a PSF/PDB
    # file pair from input PDB/MOL2 and the CGenFF-exported STR file
    # CGenFF Program is formerly known as ParamChem

    # Build frame for processing CGenFF Data
    ttk::labelframe $bpar.cgenff -labelanchor nw -padding $labelFrameInternalPadding
    ttk::label $bpar.cgenff.lblWidget -text "$downPoint Prepare Parameterization from CGenFF Program Output" -anchor w -font TkDefaultFont
    $bpar.cgenff configure -labelwidget $bpar.cgenff.lblWidget
    ttk::label $bpar.cgenffPlaceHolder -text "$rightPoint Prepare Parameterization from CGenFF Program Output" -anchor w -font TkDefaultFont

    # set mouse click bindings to expand/contract buildpar vdw settings
    bind $bpar.cgenff.lblWidget <Button-1> {
        grid remove .fftk_gui.hlf.nb.buildpar.cgenff
        grid .fftk_gui.hlf.nb.buildpar.cgenffPlaceHolder
        grid rowconfigure .fftk_gui.hlf.nb.buildpar 2 -weight 0
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }
    bind $bpar.cgenffPlaceHolder <Button-1> {
        grid remove .fftk_gui.hlf.nb.buildpar.cgenffPlaceHolder
        grid .fftk_gui.hlf.nb.buildpar.cgenff
        grid rowconfigure .fftk_gui.hlf.nb.buildpar 2 -weight 1
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }

    # grid the overall frame
    grid $bpar.cgenff -column 0 -row 2 -sticky nswe -padx $labelFramePadX -pady $labelFramePadY
    grid columnconfigure $bpar.cgenff 0 -weight 1
    grid remove $bpar.cgenff
    grid $bpar.cgenffPlaceHolder -column 0 -row 2 -sticky nswe -padx $placeHolderPadX -pady $placeHolderPadY

    # build a label pointing to CGenFF Website
    ttk::frame $bpar.cgenff.info
    ttk::label $bpar.cgenff.info.text1 -text "For information on the CGenFF Program see: " -anchor w
    ttk::label $bpar.cgenff.info.text2 -foreground blue -text "http://cgenff.paramchem.org" -anchor w
    bind $bpar.cgenff.info.text2 <Button-1> { vmd_open_url "http://cgenff.paramchem.org" }

    # grid label pointing to CGenFF Website
    grid $bpar.cgenff.info -column 0 -row 0 -sticky nsw
    grid $bpar.cgenff.info.text1 -column 0 -row 0 -sticky nsw
    grid $bpar.cgenff.info.text2 -column 1 -row 0 -sticky nsw


    # build cgenff io elements
    ttk::labelframe $bpar.cgenff.io -labelanchor nw -padding $labelFrameInternalPadding -text "Input/Output"
    ttk::label  $bpar.cgenff.io.molLbl -text "Input PDB/MOL2:" -anchor w
    ttk::entry  $bpar.cgenff.io.mol -textvariable ::ForceFieldToolKit::BuildPar::cgenffMol
    ttk::button $bpar.cgenff.io.molBrowse -text "Browse" \
        -command {
            set tempfile [tk_getOpenFile -title "Select PDB or MOL2 File" -filetypes $::ForceFieldToolKit::gui::molType]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::BuildPar::cgenffMol $tempfile }
        }
    ttk::label  $bpar.cgenff.io.strLbl -text "CGenFF STR File:" -anchor w
    ttk::entry  $bpar.cgenff.io.str -textvariable ::ForceFieldToolKit::BuildPar::cgenffStr
    ttk::button $bpar.cgenff.io.strBrowse -text "Browse" \
        -command {
            set tempfile [tk_getOpenFile -title "Select CGenFF STR File" -filetypes $::ForceFieldToolKit::gui::strType]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::BuildPar::cgenffStr $tempfile }
        }

    ttk::label  $bpar.cgenff.io.outpathLbl -text "Output Folder:" -anchor w
    ttk::entry  $bpar.cgenff.io.outpath -textvariable ::ForceFieldToolKit::BuildPar::cgenffOutPath
    ttk::button $bpar.cgenff.io.outpathBrowse -text "Browse" \
        -command {
            set temppath [tk_chooseDirectory -title "Select the Output Folder"]
            if {![string eq $temppath ""]} { set ::ForceFieldToolKit::BuildPar::cgenffOutPath $temppath }
        }
    ttk::label $bpar.cgenff.io.resnameLbl -text "Resname:"
    ttk::frame $bpar.cgenff.io.container
    ttk::entry $bpar.cgenff.io.container.resname -textvariable ::ForceFieldToolKit::BuildPar::cgenffResname -width 8 -justify center
    ttk::label  $bpar.cgenff.io.container.chainLbl -text "Chain:"
    ttk::entry  $bpar.cgenff.io.container.chain -textvariable ::ForceFieldToolKit::BuildPar::cgenffChain -width 4 -justify center
    ttk::label  $bpar.cgenff.io.container.segLbl -text "Segment:"
    ttk::entry  $bpar.cgenff.io.container.seg -textvariable ::ForceFieldToolKit::BuildPar::cgenffSegment -width 4 -justify center
    ttk::button $bpar.cgenff.io.container.resGetFromMol -text "Get From Input" \
        -command {
            if { [file exists $::ForceFieldToolKit::BuildPar::cgenffMol] } {
                # load molecule
                set molid [mol new $::ForceFieldToolKit::BuildPar::cgenffMol waitfor all]
                # get data
                set sel [atomselect $molid "all"]
                set ::ForceFieldToolKit::BuildPar::cgenffResname [lindex [lsort -unique [$sel get resname]] 0]
                set ::ForceFieldToolKit::BuildPar::cgenffChain   [lindex [lsort -unique [$sel get chain]] 0]
                set ::ForceFieldToolKit::BuildPar::cgenffSegment [lindex [lsort -unique [$sel get segname]] 0]
                if { [llength $::ForceFieldToolKit::BuildPar::cgenffSegment] == 0 } {
                   set ::ForceFieldToolKit::BuildPar::cgenffSegment $::ForceFieldToolKit::BuildPar::cgenffChain
                }
                # clean up
                $sel delete
                mol delete $molid
            } else {
                return
            }
        }

    # grid cgenff io elements
    grid $bpar.cgenff.io -column 0 -row 1 -sticky nswe  -padx $labelFramePadX -pady $labelFramePadY

    grid $bpar.cgenff.io.molLbl        -column 0 -row 0 -sticky nse
    grid $bpar.cgenff.io.mol           -column 1 -row 0 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $bpar.cgenff.io.molBrowse     -column 2 -row 0 -padx $vbuttonPadX -pady $vbuttonPadY
    grid $bpar.cgenff.io.strLbl        -column 0 -row 1 -sticky nse
    grid $bpar.cgenff.io.str           -column 1 -row 1 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $bpar.cgenff.io.strBrowse     -column 2 -row 1 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY

    grid $bpar.cgenff.io.outpathLbl    -column 0 -row 2 -sticky nse
    grid $bpar.cgenff.io.outpath       -column 1 -row 2 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $bpar.cgenff.io.outpathBrowse -column 2 -row 2 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $bpar.cgenff.io.resnameLbl    -column 0 -row 3 -sticky nse
    grid $bpar.cgenff.io.container     -column 1 -row 3 -sticky nswe
    grid $bpar.cgenff.io.container.resname       -column 0 -row 0 -sticky nsw -padx $entryPadX -pady $entryPadY
    grid $bpar.cgenff.io.container.chainLbl      -column 1 -row 0
    grid $bpar.cgenff.io.container.chain         -column 2 -row 0 -sticky nsw -padx $entryPadX -pady $entryPadY
    grid $bpar.cgenff.io.container.segLbl        -column 3 -row 0
    grid $bpar.cgenff.io.container.seg           -column 4 -row 0 -sticky nsw -padx $entryPadX -pady $entryPadY
    grid $bpar.cgenff.io.container.resGetFromMol -column 5 -row 0 -sticky nsw -padx $vbuttonPadX -pady $vbuttonPadY

    grid columnconfigure $bpar.cgenff.io {0 2} -weight 0
    grid columnconfigure $bpar.cgenff.io {1}   -weight 1
    grid rowconfigure    $bpar.cgenff.io {0 1 2 3} -uniform rt1

    # horizontal separator
    grid [ttk::separator $bpar.cgenff.sep1 -orient horizontal] -column 0 -row 2 -sticky we -padx $hsepPadX -pady $hsepPadY

    # build tools
    ttk::frame $bpar.cgenff.tools
    ttk::button $bpar.cgenff.tools.analyze -text "Analyze Input"     -command { ::ForceFieldToolKit::gui::bparCGenFFAnalyze }
    ttk::button $bpar.cgenff.tools.writePsfPdb -text "Write PSF/PDB" -command { ::ForceFieldToolKit::gui::bparCGenFFWritePSFPDB }
    ttk::button $bpar.cgenff.tools.writePar -text "Write PAR"        -command { ::ForceFieldToolKit::gui::bparCGenFFWritePAR }
    ttk::button $bpar.cgenff.tools.color -text "Color By Penalty"    -command {} -state disabled
    ttk::button $bpar.cgenff.tools.clear -text "Clear"               -command {
        if { $::ForceFieldToolKit::gui::bparCGenFFMolID != -1 && [lsearch [molinfo list] $::ForceFieldToolKit::gui::bparCGenFFMolID] != -1 } {
            mol delete $::ForceFieldToolKit::gui::bparCGenFFMolID
            set ::ForceFieldToolKit::gui::bparCGenFFMolID -1
        }
        foreach ele {bonds angles dihedrals impropers} {
            .fftk_gui.hlf.nb.buildpar.cgenff.pars.${ele}Tv delete [.fftk_gui.hlf.nb.buildpar.cgenff.pars.${ele}Tv children {}]
        }
        .fftk_gui.hlf.nb.buildpar.cgenff.pars configure -text "CGenFF Parameter Data"
    }

    # grid tools
    grid $bpar.cgenff.tools -column 0 -row 3

    grid $bpar.cgenff.tools.analyze     -column 0 -row 0 -sticky nswe -padx $hbuttonPadX -pady $hbuttonPadY
    grid $bpar.cgenff.tools.writePsfPdb -column 1 -row 0 -sticky nswe -padx $hbuttonPadX -pady $hbuttonPadY
    grid $bpar.cgenff.tools.writePar    -column 2 -row 0 -sticky nswe -padx $hbuttonPadX -pady $hbuttonPadY
    #grid $bpar.cgenff.tools.color       -column 3 -row 0 -sticky nswe -padx $hbuttonPadX -pady $hbuttonPadY
    grid $bpar.cgenff.tools.clear       -column 4 -row 0 -sticky nswe -padx $hbuttonPadX -pady $hbuttonPadY

    grid columnconfigure $bpar.cgenff.tools {0 1 2  4} -uniform ct1
    grid columnconfigure $bpar.cgenff.tools {0 1 2 3 4} -weight 0

    # horizontal separator
    grid [ttk::separator $bpar.cgenff.sep2 -orient horizontal] -column 0 -row 4 -sticky we -padx $hsepPadX -pady $hsepPadY

    # build parameter analysis elements
    ttk::labelframe $bpar.cgenff.pars -labelanchor nw -padding $labelFrameInternalPadding -text "CGenFF Parameter Data"

    # labels, tvs, and scrollbars (programmatically)
    foreach ele {bonds angles dihedrals impropers} {
        ttk::label     $bpar.cgenff.pars.${ele}Lbl    -text "[string toupper $ele]"
        ttk::treeview  $bpar.cgenff.pars.${ele}Tv     -selectmode extended -yscrollcommand "$bpar.cgenff.pars.${ele}Scroll set"
        ttk::scrollbar $bpar.cgenff.pars.${ele}Scroll -orient vertical -command "$bpar.cgenff.pars.${ele}Tv yview"
    }

    # configure tvs (is there a reasonabl way to do these programmatically?)
    # bonds
    $bpar.cgenff.pars.bondsTv configure -columns {typedef k b0 penalty comments indlist} -displaycolumns {typedef k b0 penalty} -show {headings} -height 4
    $bpar.cgenff.pars.bondsTv heading typedef -text "Type Def." -anchor center -command { ::ForceFieldToolKit::gui::bparCGenFFSortPars bonds typedef 0 }
    $bpar.cgenff.pars.bondsTv heading k       -text "k"         -anchor center -command { ::ForceFieldToolKit::gui::bparCGenFFSortPars bonds k       1 }
    $bpar.cgenff.pars.bondsTv heading b0      -text "b${sub0}"  -anchor center -command { ::ForceFieldToolKit::gui::bparCGenFFSortPars bonds b0      2 }
    $bpar.cgenff.pars.bondsTv heading penalty -text "Penalty"   -anchor center -command { ::ForceFieldToolKit::gui::bparCGenFFSortPars bonds penalty 3 }
    $bpar.cgenff.pars.bondsTv column typedef -width 200 -stretch 4 -anchor center
    foreach ele {k b0 penalty} { $bpar.cgenff.pars.bondsTv column $ele -width 100 -stretch 2 -anchor center }

    # angles
    $bpar.cgenff.pars.anglesTv configure -columns {typedef k theta kub s penalty comments indlist} -displaycolumns {typedef k theta kub s penalty} -show {headings} -height 4
    $bpar.cgenff.pars.anglesTv heading typedef -text "Type Def." -anchor center -command { ::ForceFieldToolKit::gui::bparCGenFFSortPars angles typedef 0 }
    $bpar.cgenff.pars.anglesTv heading k       -text "k"         -anchor center -command { ::ForceFieldToolKit::gui::bparCGenFFSortPars angles k       1 }
    $bpar.cgenff.pars.anglesTv heading theta   -text "$theta"    -anchor center -command { ::ForceFieldToolKit::gui::bparCGenFFSortPars angles theta   2 }
    $bpar.cgenff.pars.anglesTv heading kub     -text "kub"       -anchor center -command { ::ForceFieldToolKit::gui::bparCGenFFSortPars angles kub     3 }
    $bpar.cgenff.pars.anglesTv heading s       -text "s"         -anchor center -command { ::ForceFieldToolKit::gui::bparCGenFFSortPars angles s       4 }
    $bpar.cgenff.pars.anglesTv heading penalty -text "Penalty"   -anchor center -command { ::ForceFieldToolKit::gui::bparCGenFFSortPars angles penalty 5 }
    $bpar.cgenff.pars.anglesTv column typedef -width 200 -stretch 4 -anchor center
    $bpar.cgenff.pars.anglesTv column penalty -width 100 -stretch 2 -anchor center
    foreach ele {k theta kub s} { $bpar.cgenff.pars.anglesTv column $ele -width 25 -stretch 1 -anchor center }

    # dihedrals
    $bpar.cgenff.pars.dihedralsTv configure -columns {typedef k n delta penalty comments indlist} -displaycolumns {typedef k n delta penalty} -show {headings} -height 4
    $bpar.cgenff.pars.dihedralsTv heading typedef -text "Type Def." -anchor center -command { ::ForceFieldToolKit::gui::bparCGenFFSortPars dihedrals typedef 0 }
    $bpar.cgenff.pars.dihedralsTv heading k       -text "k"         -anchor center -command { ::ForceFieldToolKit::gui::bparCGenFFSortPars dihedrals k       1 }
    $bpar.cgenff.pars.dihedralsTv heading n       -text "n"         -anchor center -command { ::ForceFieldToolKit::gui::bparCGenFFSortPars dihedrals n       2 }
    $bpar.cgenff.pars.dihedralsTv heading delta   -text "d"         -anchor center -command { ::ForceFieldToolKit::gui::bparCGenFFSortPars dihedrals delta   3 }
    $bpar.cgenff.pars.dihedralsTv heading penalty -text "Penalty"   -anchor center -command { ::ForceFieldToolKit::gui::bparCGenFFSortPars dihedrals penalty 4 }
    $bpar.cgenff.pars.dihedralsTv column typedef -width 200 -stretch 4 -anchor center
    foreach ele {k penalty} { $bpar.cgenff.pars.dihedralsTv column $ele -width 100 -stretch 2 -anchor center }
    foreach ele {n delta  } { $bpar.cgenff.pars.dihedralsTv column $ele -width 50  -stretch 1 -anchor center }

    # impropers
    $bpar.cgenff.pars.impropersTv configure -columns {typedef k psi penalty comments indlist} -displaycolumns {typedef k psi penalty} -show {headings} -height 4
    $bpar.cgenff.pars.impropersTv heading typedef -text "Type Def." -anchor center -command { ::ForceFieldToolKit::gui::bparCGenFFSortPars impropers typedef 0 }
    $bpar.cgenff.pars.impropersTv heading k       -text "k"         -anchor center -command { ::ForceFieldToolKit::gui::bparCGenFFSortPars impropers k       1 }
    $bpar.cgenff.pars.impropersTv heading psi     -text "psi"       -anchor center -command { ::ForceFieldToolKit::gui::bparCGenFFSortPars impropers psi     2 }
    $bpar.cgenff.pars.impropersTv heading penalty -text "Penalty"   -anchor center -command { ::ForceFieldToolKit::gui::bparCGenFFSortPars impropers penalty 3 }
    $bpar.cgenff.pars.impropersTv column typedef -width 200 -stretch 4 -anchor center
    foreach ele {k psi penalty} { $bpar.cgenff.pars.impropersTv column $ele -width 100 -stretch 2 -anchor center }

    # grid parameter analysis elements
    grid $bpar.cgenff.pars -column 0 -row 5 -sticky nswe -padx $labelFramePadX -pady $labelFramePadY

    set parlist {bonds angles dihedrals impropers}
    for {set i 0} {$i < [llength $parlist]} {incr i} {
        set ele [lindex $parlist $i]
        grid $bpar.cgenff.pars.${ele}Lbl    -column 0 -row [expr {$i*2}]   -sticky nw
        grid $bpar.cgenff.pars.${ele}Tv     -column 0 -row [expr {$i*2+1}] -sticky nswe
        grid $bpar.cgenff.pars.${ele}Scroll -column 1 -row [expr {$i*2+1}] -sticky ns
    }

    grid rowconfigure $bpar.cgenff 5 -weight 1 ; # allow this row in the cgenff frame to expand (all others are fixed)
    grid columnconfigure $bpar.cgenff.pars 0 -weight 1
    grid rowconfigure $bpar.cgenff.pars {0 2 4 6} -weight 0 -uniform rt1
    grid rowconfigure $bpar.cgenff.pars {1 3 5 7} -weight 1

    # TV Bindings
    # Note that tvs will take up a lot of vertical space, so we'll need to play the hide/show game like we do for labelframes inside tabs
    # We can do this by binding a toggle proc to the label and using a state normal/disabled to give a font-based visual indication
    # Upon load/analysis we should autohide any Tvs that aren't populated
    # Think if we can do this programmatically; also consider grouping tvs and scroll into a single frame
    # ALSO, esc deselects, selection draws graphic objects

    # bind bonds
    bind $bpar.cgenff.pars.bondsLbl <Button-1> {
        if { [.fftk_gui.hlf.nb.buildpar.cgenff.pars.bondsLbl cget -state] eq "disabled" } {
            .fftk_gui.hlf.nb.buildpar.cgenff.pars.bondsLbl configure -state normal
            grid .fftk_gui.hlf.nb.buildpar.cgenff.pars.bondsTv
            grid .fftk_gui.hlf.nb.buildpar.cgenff.pars.bondsScroll
            grid rowconfigure .fftk_gui.hlf.nb.buildpar.cgenff.pars 1 -weight 1
        } else {
            .fftk_gui.hlf.nb.buildpar.cgenff.pars.bondsLbl configure -state disabled
            grid remove .fftk_gui.hlf.nb.buildpar.cgenff.pars.bondsTv
            grid remove .fftk_gui.hlf.nb.buildpar.cgenff.pars.bondsScroll
            grid rowconfigure .fftk_gui.hlf.nb.buildpar.cgenff.pars 1 -weight 0
        }
    }
    bind $bpar.cgenff.pars.bondsTv <KeyPress-Escape> { .fftk_gui.hlf.nb.buildpar.cgenff.pars.bondsTv selection set {} }
    bind $bpar.cgenff.pars.bondsTv <<TreeviewSelect>> { ::ForceFieldToolKit::gui::bparCGenFFTvSelectionDidChange }

    # bind angles
    bind $bpar.cgenff.pars.anglesLbl <Button-1> {
        if { [.fftk_gui.hlf.nb.buildpar.cgenff.pars.anglesLbl cget -state] eq "disabled" } {
            .fftk_gui.hlf.nb.buildpar.cgenff.pars.anglesLbl configure -state normal
            grid .fftk_gui.hlf.nb.buildpar.cgenff.pars.anglesTv
            grid .fftk_gui.hlf.nb.buildpar.cgenff.pars.anglesScroll
            grid rowconfigure .fftk_gui.hlf.nb.buildpar.cgenff.pars 3 -weight 1
        } else {
            .fftk_gui.hlf.nb.buildpar.cgenff.pars.anglesLbl configure -state disabled
            grid remove .fftk_gui.hlf.nb.buildpar.cgenff.pars.anglesTv
            grid remove .fftk_gui.hlf.nb.buildpar.cgenff.pars.anglesScroll
            grid rowconfigure .fftk_gui.hlf.nb.buildpar.cgenff.pars 3 -weight 0
        }
    }
    bind $bpar.cgenff.pars.anglesTv <KeyPress-Escape> { .fftk_gui.hlf.nb.buildpar.cgenff.pars.anglesTv selection set {} }
    bind $bpar.cgenff.pars.anglesTv <<TreeviewSelect>> { ::ForceFieldToolKit::gui::bparCGenFFTvSelectionDidChange }

    # bind dihedrals
    bind $bpar.cgenff.pars.dihedralsLbl <Button-1> {
        if { [.fftk_gui.hlf.nb.buildpar.cgenff.pars.dihedralsLbl cget -state] eq "disabled" } {
            .fftk_gui.hlf.nb.buildpar.cgenff.pars.dihedralsLbl configure -state normal
            grid .fftk_gui.hlf.nb.buildpar.cgenff.pars.dihedralsTv
            grid .fftk_gui.hlf.nb.buildpar.cgenff.pars.dihedralsScroll
            grid rowconfigure .fftk_gui.hlf.nb.buildpar.cgenff.pars 5 -weight 1
        } else {
            .fftk_gui.hlf.nb.buildpar.cgenff.pars.dihedralsLbl configure -state disabled
            grid remove .fftk_gui.hlf.nb.buildpar.cgenff.pars.dihedralsTv
            grid remove .fftk_gui.hlf.nb.buildpar.cgenff.pars.dihedralsScroll
            grid rowconfigure .fftk_gui.hlf.nb.buildpar.cgenff.pars 5 -weight 0
        }
    }
    bind $bpar.cgenff.pars.dihedralsTv <KeyPress-Escape> { .fftk_gui.hlf.nb.buildpar.cgenff.pars.dihedralsTv selection set {} }
    bind $bpar.cgenff.pars.dihedralsTv <<TreeviewSelect>> { ::ForceFieldToolKit::gui::bparCGenFFTvSelectionDidChange }

    # bind impropers
    bind $bpar.cgenff.pars.impropersLbl <Button-1> {
        if { [.fftk_gui.hlf.nb.buildpar.cgenff.pars.impropersLbl cget -state] eq "disabled" } {
            .fftk_gui.hlf.nb.buildpar.cgenff.pars.impropersLbl configure -state normal
            grid .fftk_gui.hlf.nb.buildpar.cgenff.pars.impropersTv
            grid .fftk_gui.hlf.nb.buildpar.cgenff.pars.impropersScroll
            grid rowconfigure .fftk_gui.hlf.nb.buildpar.cgenff.pars 7 -weight 1
        } else {
            .fftk_gui.hlf.nb.buildpar.cgenff.pars.impropersLbl configure -state disabled
            grid remove .fftk_gui.hlf.nb.buildpar.cgenff.pars.impropersTv
            grid remove .fftk_gui.hlf.nb.buildpar.cgenff.pars.impropersScroll
            grid rowconfigure .fftk_gui.hlf.nb.buildpar.cgenff.pars 7 -weight 0
        }
    }
    bind $bpar.cgenff.pars.impropersTv <KeyPress-Escape> { .fftk_gui.hlf.nb.buildpar.cgenff.pars.impropersTv selection set {} }
    bind $bpar.cgenff.pars.impropersTv <<TreeviewSelect>> { ::ForceFieldToolKit::gui::bparCGenFFTvSelectionDidChange }


    # UPDATE PARAMETERS frame
    # -----------------------
    # Build frame for updating parameters after optimization
    ttk::labelframe $bpar.update -labelanchor nw -padding $labelFrameInternalPadding
    ttk::label $bpar.update.lblWidget -text "$downPoint Update Parameter File with Optimized Parameters" -anchor w -font TkDefaultFont
    $bpar.update configure -labelwidget $bpar.update.lblWidget
    ttk::label $bpar.updatePlaceHolder -text "$rightPoint Update Parameter File with Optimized Parameters" -anchor w -font TkDefaultFont

    # set mouse click bindings to expand/contract buildpar settings
    bind $bpar.update.lblWidget <Button-1> {
        grid remove .fftk_gui.hlf.nb.buildpar.update
        grid .fftk_gui.hlf.nb.buildpar.updatePlaceHolder
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }
    bind $bpar.updatePlaceHolder <Button-1> {
        grid remove .fftk_gui.hlf.nb.buildpar.updatePlaceHolder
        grid .fftk_gui.hlf.nb.buildpar.update
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }

    # build update elements
    ttk::label $bpar.update.inputParPathLbl -text "Input Parameter File:" -anchor center
    ttk::entry $bpar.update.inputParPath -textvariable ::ForceFieldToolKit::BuildPar::updateInputParPath
    ttk::button $bpar.update.inputParPathBrowse -text "Browse" \
        -command {
            set tempfile [tk_getOpenFile -title "Select the Input Parameter File" -filetypes $::ForceFieldToolKit::gui::parType]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::BuildPar::updateInputParPath $tempfile }
        }
    ttk::label $bpar.update.optLogPathLbl -text "Optimization LOG File:" -anchor center
    ttk::entry $bpar.update.optLogPath -textvariable ::ForceFieldToolKit::BuildPar::updateLogPath
    ttk::button $bpar.update.optLogPathBrowse -text "Browse" \
        -command {
            set tempfile [tk_getOpenFile -title "Select the Optimization Log File" -filetypes $::ForceFieldToolKit::gui::logType]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::BuildPar::updateLogPath $tempfile }
        }
    ttk::label $bpar.update.outParPathLbl -text "Output Parameter File:" -anchor center
    ttk::entry $bpar.update.outParPath -textvariable ::ForceFieldToolKit::BuildPar::updateOutParPath
    ttk::button $bpar.update.outParPathBrowse -text "SaveAs" \
        -command {
            set temppath [tk_getSaveFile -title "Save the Updated Parameter File As..." -filetypes $::ForceFieldToolKit::gui::parType -defaultextension {.par}]
            if {![string eq $temppath ""]} { set ::ForceFieldToolKit::BuildPar::updateOutParPath $temppath }
        }
    ttk::separator $bpar.update.sep1 -orient horizontal
    ttk::button $bpar.update.buildUpdatedFile -text "Write Updated Parameter File" \
        -command {
            ::ForceFieldToolKit::BuildPar::buildUpdatedParFile
            ::ForceFieldToolKit::gui::consoleMessage "Updated PAR file written"
        }

    # grid update elements
    grid $bpar.update -column 0 -row 3 -sticky nswe -padx $labelFramePadX -pady $labelFramePadY
    grid columnconfigure $bpar.update 1 -weight 1
    grid rowconfigure $bpar.update {0 1 2} -uniform rt1
    grid rowconfigure $bpar.update 5 -minsize 50 -weight 0
    grid remove $bpar.update
    grid $bpar.updatePlaceHolder -column 0 -row 3 -sticky nswe -padx $placeHolderPadX -pady $placeHolderPadY

    grid $bpar.update.inputParPathLbl -column 0 -row 0 -sticky nswe
    grid $bpar.update.inputParPath -column 1 -row 0 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $bpar.update.inputParPathBrowse -column 2 -row 0 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $bpar.update.optLogPathLbl -column 0 -row 1 -sticky nswe
    grid $bpar.update.optLogPath -column 1 -row 1 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $bpar.update.optLogPathBrowse -column 2 -row 1 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $bpar.update.outParPathLbl -column 0 -row 2 -sticky nswe
    grid $bpar.update.outParPath -column 1 -row 2 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $bpar.update.outParPathBrowse -column 2 -row 2 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $bpar.update.sep1 -column 0 -row 4 -columnspan 3 -sticky we -padx 10 -padx $hsepPadX -pady $hsepPadY
    grid $bpar.update.buildUpdatedFile -column 0 -row 5 -columnspan 3 -sticky nswe -padx $buttonRunPadX -pady $buttonRunPadY

    #---------------------------------------------------#
    #  QM software selector                             #
    #---------------------------------------------------#
    #
    # Generate a menu for the QM selector. The menu is the same for all the tabs.
    # Set the qmSoft variable and apply default values everytime the QM selector is used.
    menu $w.menuQMSelector -tearoff no
    $w.menuQMSelector add command -label "Gaussian" -command {
       set ::ForceFieldToolKit::qmSoft "Gaussian"
       set ::ForceFieldToolKit::scriptExt ".gau"

       ::ForceFieldToolKit::Gaussian::resetDefaultsGeomOpt
       ::ForceFieldToolKit::Gaussian::resetDefaultsGenZMatrix
       ::ForceFieldToolKit::Gaussian::resetDefaultsESP
       ::ForceFieldToolKit::Gaussian::resetDefaultsGenBonded
       ::ForceFieldToolKit::Gaussian::resetDefaultsGenDihScan
    }
    $w.menuQMSelector add command -label "ORCA"     -command {
       set ::ForceFieldToolKit::qmSoft "ORCA"
       set ::ForceFieldToolKit::scriptExt ".orca"

       ::ForceFieldToolKit::ORCA::resetDefaultsGeomOpt
       ::ForceFieldToolKit::ORCA::resetDefaultsGenZMatrix
       ::ForceFieldToolKit::ORCA::resetDefaultsESP
       ::ForceFieldToolKit::ORCA::resetDefaultsGenBonded
       ::ForceFieldToolKit::ORCA::resetDefaultsGenDihScan
    }
    $w.menuQMSelector add command -label "Psi4"     -command {
       set ::ForceFieldToolKit::qmSoft "Psi4"
       set ::ForceFieldToolKit::scriptExt ".py"

       ::ForceFieldToolKit::Psi4::resetDefaultsGeomOpt
       ::ForceFieldToolKit::Psi4::resetDefaultsGenZMatrix
       ::ForceFieldToolKit::Psi4::resetDefaultsESP
       ::ForceFieldToolKit::Psi4::resetDefaultsGenBonded
       ::ForceFieldToolKit::Psi4::resetDefaultsGenDihScan
    }

    #---------------------------------------------------#
    #  GeomOpt tab                                      #
    #---------------------------------------------------#

    # build the geomopt frame, add it to the notebook as a tab
    ttk::frame $w.hlf.nb.geomopt
    $w.hlf.nb add $w.hlf.nb.geomopt -text "Opt. Geometry"
    # allow the frame to expand width with the nb
    grid columnconfigure $w.hlf.nb.geomopt 0 -weight 1

    # for shorter naming notation
    set gopt $w.hlf.nb.geomopt

    # IO Section
    # ----------
    # build the io elements
    ttk::labelframe $gopt.io -labelanchor nw -padding $labelFrameInternalPadding -text "Input/Output"
    ttk::label $gopt.io.psfLbl -text "Input PSF File:" -anchor center
    ttk::entry $gopt.io.psf -textvariable ::ForceFieldToolKit::GeomOpt::psf
    ttk::button $gopt.io.psfBrowse -text "Browse"   \
        -command {
            set tempfile [tk_getOpenFile -title "Select a PSF File" -filetypes $::ForceFieldToolKit::gui::psfType]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::GeomOpt::psf $tempfile }
        }
    ttk::label $gopt.io.pdbLbl -text "Input PDB File:" -anchor center
    ttk::entry $gopt.io.pdb -textvariable ::ForceFieldToolKit::GeomOpt::pdb
    ttk::button $gopt.io.pdbBrowse -text "Browse"   \
        -command {
            set tempfile [tk_getOpenFile -title "Select a PDB File" -filetypes $::ForceFieldToolKit::gui::pdbType]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::GeomOpt::pdb $tempfile }
        }
    ttk::label $gopt.io.comLbl -text "Output QM File:" -anchor center
    ttk::entry $gopt.io.com -textvariable ::ForceFieldToolKit::GeomOpt::com
    ttk::button $gopt.io.comSaveAs -text "SaveAs" \
        -command { set tempfile [tk_getSaveFile -title "Save the QM Input File As..." -filetypes $::ForceFieldToolKit::gui::AllInpType -defaultextension $::ForceFieldToolKit::scriptExt]
                if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::GeomOpt::com $tempfile }
        }

    # grid the io elements
    grid $gopt.io -column 0 -row 0 -sticky nswe -padx $labelFramePadX -pady $labelFramePadY
    grid columnconfigure $gopt.io 1 -weight 1

    grid $gopt.io.psfLbl    -column 0 -row 0 -sticky nswe
    grid $gopt.io.psf       -column 1 -row 0 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $gopt.io.psfBrowse -column 2 -row 0 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $gopt.io.pdbLbl    -column 0 -row 1 -sticky nswe
    grid $gopt.io.pdb       -column 1 -row 1 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $gopt.io.pdbBrowse -column 2 -row 1 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $gopt.io.comLbl    -column 0 -row 2 -sticky nswe
    grid $gopt.io.com       -column 1 -row 2 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $gopt.io.comSaveAs -column 2 -row 2 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY

    # QM Settings
    # -----------------
    # build the gaussian settings elements
    ttk::labelframe $gopt.gaussian -labelanchor nw -padding $labelFrameInternalPadding -text "QM Settings"

    ttk::menubutton $gopt.gaussian.selector -direction below -menu $w.menuQMSelector -textvariable ::ForceFieldToolKit::qmSoft -width 15

    ttk::label $gopt.gaussian.procLbl -text "Processors:" -anchor w
    ttk::entry $gopt.gaussian.proc -textvariable ::ForceFieldToolKit::Configuration::qmProc -width 2 -justify center
    ttk::label $gopt.gaussian.memLbl -text "Memory(GB):" -anchor w
    ttk::entry $gopt.gaussian.mem -textvariable ::ForceFieldToolKit::Configuration::qmMem -width 2 -justify center
    ttk::label $gopt.gaussian.chargeLbl -text "Charge:" -anchor w
    ttk::entry $gopt.gaussian.charge -textvariable ::ForceFieldToolKit::GeomOpt::qmCharge -width 2 -justify center
    ttk::label $gopt.gaussian.multLbl -text "Multiplicity:" -anchor w
    ttk::entry $gopt.gaussian.mult -textvariable ::ForceFieldToolKit::GeomOpt::qmMult -width 2 -justify center
    ttk::label $gopt.gaussian.routeLbl -text "Route:" -anchor center
    ttk::entry $gopt.gaussian.route -textvariable ::ForceFieldToolKit::GeomOpt::qmRoute
    ttk::button $gopt.gaussian.resetDefaults -text "Reset to Defaults" -command { ::ForceFieldToolKit::${::ForceFieldToolKit::qmSoft}::resetDefaultsGeomOpt }



    # grid the gaussian settings elements
    grid $gopt.gaussian -column 0 -row 1 -sticky nswe -padx $labelFramePadX -pady $labelFramePadY
    grid rowconfigure $gopt.gaussian {0 2} -uniform rt1

    grid $gopt.gaussian.selector -column 0 -row 0 -columnspan 5 -sticky nsw

    grid $gopt.gaussian.procLbl -column 0 -row 1 -sticky nswe
    grid $gopt.gaussian.proc -column 1 -row 1 -sticky we
    grid $gopt.gaussian.memLbl -column 2 -row 1 -sticky nswe
    grid $gopt.gaussian.mem -column 3 -row 1 -sticky we
    grid $gopt.gaussian.chargeLbl -column 4 -row 1 -sticky nswe
    grid $gopt.gaussian.charge -column 5 -row 1 -sticky we
    grid $gopt.gaussian.multLbl -column 6 -row 1 -sticky nswe
    grid $gopt.gaussian.mult -column 7 -row 1 -sticky we
    grid $gopt.gaussian.resetDefaults -column 8 -row 1 -sticky nswe -padx $hbuttonPadX -pady $hbuttonPadY
    grid $gopt.gaussian.routeLbl -column 0 -row 2 -sticky nswe
    grid $gopt.gaussian.route -column 1 -row 2 -columnspan 8 -sticky nswe

    # Run Buttons
    # -----------
    ttk::button $gopt.writeCom -text "Write QM Software Input File" \
        -command {
        # For the moment, stop the procedure if ORCA was selected
#        if {$::ForceFieldToolKit::qmSoft eq "ORCA"} {
#           ::ForceFieldToolKit::ORCA::tempORCAmessage
#           return
#        }
        ::ForceFieldToolKit::GeomOpt::writeComFile
        ::ForceFieldToolKit::gui::consoleMessage "QM input file written for geometry optimization"
    }
    grid rowconfigure $gopt 2 -minsize 50
    grid $gopt.writeCom -column 0 -row 2 -sticky nswe -padx 10 -pady "10 0"; # -padx $buttonRunPadX -pady $buttonRunPadY

    ttk::separator $gopt.sep1 -orient horizontal
    grid $gopt.sep1 -column 0 -row 3 -sticky we -padx $hsepPadX -pady $hsepPadY


    # UPDATE SECTION
    # --------------
    # build update section
    ttk::labelframe $gopt.update -labelanchor nw -padding $labelFrameInternalPadding -text "Write Updated PDB"
    ttk::label $gopt.update.psfLbl -text "Input PSF File:" -anchor center
    ttk::entry $gopt.update.psf -textvariable ::ForceFieldToolKit::GeomOpt::psf
    ttk::button $gopt.update.psfBrowse -text "Browse" \
        -command {
            set tempfile [tk_getOpenFile -title "Select a PSF File" -filetypes $::ForceFieldToolKit::gui::psfType]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::GeomOpt::psf $tempfile }
        }
    ttk::label $gopt.update.pdbLbl -text "Original PDB File:" -anchor center
    ttk::entry $gopt.update.pdb -textvariable ::ForceFieldToolKit::GeomOpt::pdb
    ttk::button $gopt.update.pdbBrowse -text "Browse" \
        -command {
            set tempfile [tk_getOpenFile -title "Select a PDB File" -filetypes $::ForceFieldToolKit::gui::pdbType]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::GeomOpt::pdb $tempfile }
        }
    ttk::label $gopt.update.logLbl -text "QM Output File:" -anchor center
    ttk::entry $gopt.update.log -textvariable ::ForceFieldToolKit::GeomOpt::logFile
    ttk::button $gopt.update.logBrowse -text "Browse" \
        -command {
            set tempfile [tk_getOpenFile -title "Select an Output File" -filetypes $::ForceFieldToolKit::gui::AllLogType]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::GeomOpt::logFile $tempfile }
        }
    ttk::label $gopt.update.outPdbLbl -text "Output PDB File:" -anchor center
    ttk::entry $gopt.update.outPdb -textvariable ::ForceFieldToolKit::GeomOpt::optPdb
    ttk::button $gopt.update.outPdbSaveAs -text "SaveAs" \
        -command {
            set tempfile [tk_getSaveFile -title "Save Optimized Geometry to PDB File As..." -filetypes $::ForceFieldToolKit::gui::pdbType -defaultextension {.pdb}]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::GeomOpt::optPdb $tempfile }
        }

    # grid update section
    grid $gopt.update -column 0 -row 4 -sticky nswe
    grid columnconfigure $gopt.update 1 -weight 1
    grid rowconfigure $gopt.update {0 1 2} -uniform ct1
    grid $gopt.update.psfLbl    -column 0 -row 0 -sticky nswe
    grid $gopt.update.psf       -column 1 -row 0 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $gopt.update.psfBrowse -column 2 -row 0 -sticky nswe -padx $hbuttonPadX -pady $hbuttonPadY
    grid $gopt.update.pdbLbl    -column 0 -row 1 -sticky nswe
    grid $gopt.update.pdb       -column 1 -row 1 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $gopt.update.pdbBrowse -column 2 -row 1 -sticky nswe -padx $hbuttonPadX -pady $hbuttonPadY
    grid $gopt.update.logLbl    -column 0 -row 2 -sticky nswe
    grid $gopt.update.log       -column 1 -row 2 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $gopt.update.logBrowse -column 2 -row 2 -sticky nswe -padx $hbuttonPadX -pady $hbuttonPadY
    grid $gopt.update.outPdbLbl -column 0 -row 3 -sticky nswe
    grid $gopt.update.outPdb    -column 1 -row 3 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $gopt.update.outPdbSaveAs -column 2 -row 3 -sticky nswe -padx $hbuttonPadX -pady $hbuttonPadY

    # build update buttons
    ttk::frame $gopt.runUpdate
    ttk::button $gopt.runUpdate.loadLog -text "Load QM Output File" -command {
            # For the moment, stop the procedure if ORCA was selected
#            if {$::ForceFieldToolKit::qmSoft eq "ORCA"} {
#               ::ForceFieldToolKit::ORCA::tempORCAmessage
#               return
#            }
            ::ForceFieldToolKit::GeomOpt::loadLogFile
         }
    ttk::button $gopt.runUpdate.writeOptGeom -text "Write Optimized Geometry to PDB" -command {
            # For the moment, stop the procedure if ORCA was selected
#            if {$::ForceFieldToolKit::qmSoft eq "ORCA"} {
#               ::ForceFieldToolKit::ORCA::tempORCAmessage
#               return
#            }
            ::ForceFieldToolKit::GeomOpt::writeOptPDB
	 }
    # grid update buttons
    #grid rowconfigure $gopt 5 -minsize 50
    grid $gopt.runUpdate -column 0 -row 5 -sticky nswe
    grid columnconfigure $gopt.runUpdate {0 1} -uniform ct1 -weight 1
    grid rowconfigure $gopt.runUpdate 0 -minsize 50
    grid $gopt.runUpdate.loadLog -column 0 -row 0 -sticky nswe -padx "10 5" -pady "10 0"; # -padx $buttonRunPadX -pady $buttonRunPadY
    grid $gopt.runUpdate.writeOptGeom -column 1 -row 0 -sticky nswe -padx "5 10" -pady "10 0"; # -padx $buttonRunPadX -pady $buttonRunPadY


    # --------------------------------------------------#
    # Charge Optimization Method Selector               #
    # --------------------------------------------------#
    # create an entry for the charge optimization method selector (menubutton)
    # that will be reused across several tabs

    menu $w.chargeMethodSelectorMenu -tearoff no
    $w.chargeMethodSelectorMenu add command -label "Water Interaction" -command { ::ForceFieldToolKit::gui::coptSelectMethod "waterInt" } ; # e.g., CHARMM
    $w.chargeMethodSelectorMenu add command -label "RESP Fitting"      -command { ::ForceFieldToolKit::gui::coptSelectMethod "resp" }     ; # e.g., AMBER


    #---------------------------------------------------#
    #  GenZMatrix tab                                   #
    #---------------------------------------------------#

    # Add the Charge method selector in before the pre-existing contents
    # Note that this could have been done by creating a selector frame
    # and bundling the two frames together into the notebook, however,
    # this would have broken any absolute paths to exisitng window elements
    # and that would be a nightmare to track down and fix.  It is easier to
    # adjust the row assignments manually.

    # Create the frame and add to the notebook as a tab.  Allow it to resize with the tab
    ttk::frame $w.hlf.nb.genzmat
    $w.hlf.nb add $w.hlf.nb.genzmat -text "Water Int."
    grid columnconfigure $w.hlf.nb.genzmat 0 -weight 1

    # variable for easier naming convention
    set gzm $w.hlf.nb.genzmat

    # Charge Optimization Method Selector
    # -----------------------------------
    ttk::frame      $gzm.chargeMethodSelector
    ttk::label      $gzm.chargeMethodSelector.lbl      -text "Charge Optimization Method: " -anchor w -font TkDefaultFont
    ttk::menubutton $gzm.chargeMethodSelector.selector -direction below -menu $w.chargeMethodSelectorMenu -textvariable ::ForceFieldToolKit::gui::coptMethod -width 15
    ttk::separator  $gzm.chargeMethodSelectorSep -orient horizontal

    grid $gzm.chargeMethodSelector    -column 0 -row 0 -sticky nswe -padx $hsepPadX -pady $labelFramePadY
    grid $gzm.chargeMethodSelector.lbl      -column 0 -row 0 -sticky nwe
    grid $gzm.chargeMethodSelector.selector -column 1 -row 0 -sticky nsw
    grid $gzm.chargeMethodSelectorSep -column 0 -row 1 -sticky nwe -padx $hsepPadX -pady $hsepPadY

    grid columnconfigure $gzm.chargeMethodSelector 1 -minsize 15 -weight 1

    # IO Section
    #-----------------
    # build io section
    # label frame to contain the io elements
    ttk::labelframe $gzm.io -labelanchor nw -padding $labelFrameInternalPadding -text "Input/Output"
    # elements
    ttk::label $gzm.io.psfLbl -text "PSF File:" -anchor w
    ttk::entry $gzm.io.psfPath -textvariable ::ForceFieldToolKit::GenZMatrix::psfPath -width 44
    ttk::button $gzm.io.psfBrowse -text "Browse" \
        -command {
            set tempfile [tk_getOpenFile -title "Select a PSF File" -filetypes $::ForceFieldToolKit::gui::psfType]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::GenZMatrix::psfPath $tempfile }
        }
    ttk::label $gzm.io.pdbLbl -text "PDB File:" -anchor w
    ttk::entry $gzm.io.pdbPath -textvariable ::ForceFieldToolKit::Configuration::geomOptPDB -width 44
    ttk::button $gzm.io.pdbBrowse -text "Browse" \
        -command {
            set tempfile [tk_getOpenFile -title "Select a PDB File" -filetypes $::ForceFieldToolKit::gui::pdbType]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::Configuration::geomOptPDB $tempfile }
        }
    ttk::label $gzm.io.outFolderLbl -text "Output Path:" -anchor w
    ttk::entry $gzm.io.outFolderPath -textvariable ::ForceFieldToolKit::GenZMatrix::outFolderPath -width 44
    ttk::button $gzm.io.outFolderBrowse -text "Browse" \
        -command {
            set temppath [tk_chooseDirectory -title "Select the Output Folder"]
            if {![string eq $temppath ""]} { set ::ForceFieldToolKit::GenZMatrix::outFolderPath $temppath }
        }
    ttk::label $gzm.io.basenameLbl -text "Basename:" -anchor w
    # need a frame to align basename entry box and load button
    ttk::frame $gzm.io.subcontainer1
    ttk::entry $gzm.io.subcontainer1.basename -textvariable ::ForceFieldToolKit::GenZMatrix::basename -width 10
    ttk::button $gzm.io.subcontainer1.takeFromTop -text "Basename From TOP" \
        -command {
            # simple validation
            if { [llength [molinfo list]] == 0 } {
                tk_messageBox -type ok -icon warning -message "Action halted on error!" -detail "No PSF/PDBs are loaded in VMD."
                return
            }
            set ::ForceFieldToolKit::GenZMatrix::basename [lindex [[atomselect top all] get resname] 0]
        }
    ttk::button $gzm.io.subcontainer1.loadPsfPdb -text "Load PSF/PDB" \
        -command {
            # simple validation
            if { $::ForceFieldToolKit::GenZMatrix::psfPath eq "" || ![file exists $::ForceFieldToolKit::GenZMatrix::psfPath] } {
                tk_messageBox -type ok -icon warning -message "Action halted on error!" -detail "Cannot find PSF file."
                return
            }
            if { $::ForceFieldToolKit::Configuration::geomOptPDB eq "" || ![file exists $::ForceFieldToolKit::Configuration::geomOptPDB] } {
                tk_messageBox -type ok -icon warning -message "Action halted on error!" -detail "Cannot find PDB file."
                return
            }
            ::ForceFieldToolKit::SharedFcns::LonePair::initFromPSF $::ForceFieldToolKit::GenZMatrix::psfPath $::ForceFieldToolKit::GenZMatrix::basename
            mol addfile $::ForceFieldToolKit::Configuration::geomOptPDB
            ::ForceFieldToolKit::gui::consoleMessage "PSF/PDB loaded (Water Int.)"
        }

    # grid io section
    grid $gzm.io -column 0 -row 2 -sticky nwe -padx $labelFramePadX -pady $labelFramePadY
    grid columnconfigure $gzm.io 1 -weight 1
    grid rowconfigure $gzm.io {0 1 2 3} -uniform rt1

    grid $gzm.io.psfLbl          -column 0 -row 0
    grid $gzm.io.psfPath         -column 1 -row 0 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $gzm.io.psfBrowse       -column 2 -row 0 -padx $vbuttonPadX -pady $vbuttonPadY
    grid $gzm.io.pdbLbl          -column 0 -row 1
    grid $gzm.io.pdbPath         -column 1 -row 1 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $gzm.io.pdbBrowse       -column 2 -row 1 -padx $vbuttonPadX -pady $vbuttonPadY
    grid $gzm.io.outFolderLbl    -column 0 -row 2
    grid $gzm.io.outFolderPath   -column 1 -row 2 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $gzm.io.outFolderBrowse -column 2 -row 2 -padx $vbuttonPadX -pady $vbuttonPadY
    grid $gzm.io.basenameLbl     -column 0 -row 3
    grid $gzm.io.subcontainer1   -column 1 -row 3 -sticky we

    grid columnconfigure $gzm.io.subcontainer1 0 -weight 1
    grid $gzm.io.subcontainer1.basename    -column 0 -row 0 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $gzm.io.subcontainer1.takeFromTop -column 1 -row 0 -sticky nswe -padx $hbuttonPadX -pady $hbuttonPadY
    grid $gzm.io.subcontainer1.loadPsfPdb  -column 2 -row 0 -sticky nswe -padx $hbuttonPadX -pady $hbuttonPadY


    # HB Donor/Acceptors Section
    #---------------------------
    # build hb donors/acceptors section
    # labelframe to contain all of the elements
    ttk::labelframe $gzm.hbDonAcc -labelanchor nw -padding $labelFrameInternalPadding -text "Hydrogen Bonding Atoms"
    # elements
    ttk::label  $gzm.hbDonAcc.donLbl       -text "Donor Indices (Interact with oxygen of water)"      -anchor w
    ttk::entry  $gzm.hbDonAcc.donList      -textvariable ::ForceFieldToolKit::GenZMatrix::donList     -width 44
    ttk::label  $gzm.hbDonAcc.accLbl       -text "Acceptor Indices (Interact with hydrogen of water)" -anchor w
    ttk::entry  $gzm.hbDonAcc.accList      -textvariable ::ForceFieldToolKit::GenZMatrix::accList     -width 44
    ttk::button $gzm.hbDonAcc.toggleLabels -text "Toggle Atom Labels" \
        -command {
            if { [llength [molinfo list]] == 0 } { return }
            ::ForceFieldToolKit::gui::gzmToggleLabels
        }
    ttk::button $gzm.hbDonAcc.toggleSpheres -text "Toggle Sphere Viz." \
        -command {
            if { [llength [molinfo list]] == 0 } { return }
            ::ForceFieldToolKit::gui::gzmToggleSpheres
        }
    ttk::button $gzm.hbDonAcc.autoDetect -text "AutoDetect Indices" \
        -command {
            if { [llength [molinfo list]] == 0 } { return }
            ::ForceFieldToolKit::gui::gzmAutoDetect
        }
    ttk::button $gzm.hbDonAcc.clear -text "Clear Lists" \
        -command {
            set ::ForceFieldToolKit::GenZMatrix::donList {}
            set ::ForceFieldToolKit::GenZMatrix::accList {}
        }

    # grid hb donors/acceptors section
    grid $gzm.hbDonAcc -column 0 -row 3 -sticky nswe -padx $labelFramePadX -pady $labelFramePadY
    grid columnconfigure $gzm.hbDonAcc  0        -weight 1
    grid rowconfigure    $gzm.hbDonAcc {0 1 2 3} -uniform rt1

    grid $gzm.hbDonAcc.donLbl        -column 0 -row 0 -sticky nswe
    grid $gzm.hbDonAcc.toggleLabels  -column 1 -row 0 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $gzm.hbDonAcc.donList       -column 0 -row 1 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $gzm.hbDonAcc.toggleSpheres -column 1 -row 1 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $gzm.hbDonAcc.accLbl        -column 0 -row 2 -sticky nswe
    grid $gzm.hbDonAcc.autoDetect    -column 1 -row 2 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $gzm.hbDonAcc.accList       -column 0 -row 3 -sticky nswe
    grid $gzm.hbDonAcc.clear         -column 1 -row 3 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY


    # QM Settings Section
    #--------------------

    # build section to modify QM settings
    # frame to contain elements
    ttk::labelframe $gzm.qm -labelanchor nw -padding $labelFrameInternalPadding -text "QM Software Settings"
    # elements
    # add QM Selector first
    ttk::menubutton $gzm.qm.selector -direction below -menu $w.menuQMSelector -textvariable ::ForceFieldToolKit::qmSoft -width 15

    ttk::label $gzm.qm.procLbl   -text "Processors:" -anchor w
    ttk::entry $gzm.qm.proc      -textvariable ::ForceFieldToolKit::Configuration::qmProc -width 2 -justify center
    ttk::label $gzm.qm.memLbl    -text "Memory (GB):" -anchor w
    ttk::entry $gzm.qm.mem       -textvariable ::ForceFieldToolKit::Configuration::qmMem -width 2 -justify center
    ttk::label $gzm.qm.chargeLbl -text "Charge:" -anchor w
    ttk::entry $gzm.qm.charge    -textvariable ::ForceFieldToolKit::GenZMatrix::qmCharge -width 2 -justify center
    ttk::label $gzm.qm.multLbl   -text "Multiplicity:" -anchor w
    ttk::entry $gzm.qm.mult      -textvariable ::ForceFieldToolKit::GenZMatrix::qmMult -width 2 -justify center
    ttk::button $gzm.qm.defaults -text "Reset to Defaults" -command { ::ForceFieldToolKit::${::ForceFieldToolKit::qmSoft}::resetDefaultsGenZMatrix }
    ttk::label $gzm.qm.routeLbl  -text "Route:" -justify center
    ttk::entry $gzm.qm.route     -textvariable ::ForceFieldToolKit::GenZMatrix::qmRoute

    # grid the section elements
    grid $gzm.qm -column 0 -row 4 -sticky nsew -padx $labelFramePadX -pady $labelFramePadY
    grid rowconfigure $gzm.qm {0 1} -uniform rt1

    grid $gzm.qm.selector   -column 0 -row 0 -columnspan 5 -sticky nsw

    grid $gzm.qm.procLbl   -column 0 -row 1 -sticky w
    grid $gzm.qm.proc      -column 1 -row 1 -sticky w    -padx $entryPadX -pady $entryPadY
    grid $gzm.qm.memLbl    -column 2 -row 1 -sticky w
    grid $gzm.qm.mem       -column 3 -row 1 -sticky w    -padx $entryPadX -pady $entryPadY
    grid $gzm.qm.chargeLbl -column 4 -row 1 -sticky w
    grid $gzm.qm.charge    -column 5 -row 1 -sticky w    -padx $entryPadX -pady $entryPadY
    grid $gzm.qm.multLbl   -column 6 -row 1 -sticky w
    grid $gzm.qm.mult      -column 7 -row 1 -sticky w    -padx $entryPadX -pady $entryPadY
    grid $gzm.qm.defaults  -column 8 -row 1 -sticky nswe -padx $hbuttonPadX -pady $hbuttonPadY
    grid $gzm.qm.routeLbl  -column 0 -row 2 -sticky w    -padx $entryPadX -pady $entryPadY
    grid $gzm.qm.route     -column 1 -row 2 -sticky nswe -columnspan 8


    # Generate Section
    #-----------------
    ttk::separator $gzm.sep1 -orient horizontal
    grid $gzm.sep1 -column 0 -row 5 -sticky we -padx $hsepPadX -pady $hsepPadY

    ttk::frame $gzm.run
    ttk::button $gzm.run.generate -text "Write QM Software Input Files" -command {
            # For the moment, stop the procedure if ORCA was selected
#            if {$::ForceFieldToolKit::qmSoft eq "ORCA"} {
#               ::ForceFieldToolKit::ORCA::tempORCAmessage
#               return
#            }
        set molID [::ForceFieldToolKit::SharedFcns::LonePair::loadMolExcludeLP $::ForceFieldToolKit::GenZMatrix::psfPath $::ForceFieldToolKit::Configuration::geomOptPDB]
        ::ForceFieldToolKit::GenZMatrix::genZmatrix
        ::ForceFieldToolKit::GenZMatrix::writeSPfiles
        mol delete $molID
    }
    ttk::button $gzm.run.loadCOM -text "Load QM Input Files" \
        -command {
            # For the moment, stop the procedure if ORCA was selected
#            if {$::ForceFieldToolKit::qmSoft eq "ORCA"} {
#               ::ForceFieldToolKit::ORCA::tempORCAmessage
#               return
#            }
            set ::ForceFieldToolKit::gui::gzmCOMfiles [tk_getOpenFile -title "Select QM File(s) to Load" -multiple 1 -filetypes $::ForceFieldToolKit::gui::AllInpType]
            if { [llength $::ForceFieldToolKit::gui::gzmCOMfiles] eq 0 } {
               return
            } else {
               foreach comfile $::ForceFieldToolKit::gui::gzmCOMfiles {
               # set molId [mol new]
               # ::QMtool::use_vmd_molecule $molId
               # ::QMtool::read_gaussian_input $comfile $molId
                   set molId [::ForceFieldToolKit::GenZMatrix::loadCOMFile $comfile]
                   mol rename $molId "[file rootname [file tail $comfile]]"
               }
            }
            ::ForceFieldToolKit::gui::consoleMessage "QM files loaded (Water Int.)"
        }
    ttk::button $gzm.run.loadLOG -text "Load QM Output Files" \
        -command {
            # For the moment, stop the procedure if ORCA was selected
#            if {$::ForceFieldToolKit::qmSoft eq "ORCA"} {
#               ::ForceFieldToolKit::ORCA::tempORCAmessage
#               return
#	    }
            set ::ForceFieldToolKit::gui::gzmLOGfiles [tk_getOpenFile -title "Select QM Output File(s) to Load" -multiple 1 -filetypes $::ForceFieldToolKit::gui::AllLogType]
            if { [llength $::ForceFieldToolKit::gui::gzmLOGfiles] eq 0 } {
                return
            } else {
                set molList {}
                foreach logfile $::ForceFieldToolKit::gui::gzmLOGfiles {
	 	            set molId [::ForceFieldToolKit::GenZMatrix::loadLOGFile $logfile]
                    #set molId [mol new]
                    #::QMtool::use_vmd_molecule $molId
                    #catch { ::QMtool::read_gaussian_log $logfile $molId }
                    #::QMtool::read_gaussian_log $logfile $molId
                    mol rename $molId "[file rootname [file tail $logfile]]"
                    mol modselect 0 $molId "all and not element X"
                    lappend molList $molId
                }
                # Determine which mol has the most frames, and make that top for better visualization purposes
                set bestMol 0
                set mostFrames 0
                #puts "molList: $molList"
                foreach entry $molList {
                    set frameNum [molinfo $entry get numframes]
                    #puts "molid $entry has $frameNum frames"
                    if { $frameNum > $mostFrames } {
                        set bestMol $entry
                        set mostFrames $frameNum
                    }
                }
                mol top $bestMol
                unset molList bestMol mostFrames
            }
            ::ForceFieldToolKit::gui::consoleMessage "QM output files loaded (Water Int.)"
        }

    grid $gzm.run -column 0 -row 6 -columnspan 3 -sticky nswe
    grid rowconfigure    $gzm.run 0       -minsize 50
    grid columnconfigure $gzm.run {0 1 2} -uniform ct2 -weight 1

    grid $gzm.run.generate -column 0 -row 0 -sticky nswe -padx $buttonRunPadX -pady $buttonRunPadY
    grid $gzm.run.loadCOM  -column 1 -row 0 -sticky nswe -padx $buttonRunPadX -pady $buttonRunPadY
    grid $gzm.run.loadLOG  -column 2 -row 0 -sticky nswe -padx $buttonRunPadX -pady $buttonRunPadY


    #---------------------------------------------------#
    #  ChargeOpt  tab                                   #
    #---------------------------------------------------#

    # build the chargeopt frame, add it to the notebook as a tab
    ttk::frame $w.hlf.nb.chargeopt
    $w.hlf.nb add $w.hlf.nb.chargeopt -text "Opt. Charges"
    # allow the chargeopt frame to expand with the nb, column only (ie. width)
    grid columnconfigure $w.hlf.nb.chargeopt 0 -weight 1

    # for shorter naming notation
    set copt $w.hlf.nb.chargeopt

    # See notes for GZM tab with regards to the Charge Optimization Method Selector
    # Charge Optimization Method Selector
    # -----------------------------------
    ttk::frame      $copt.chargeMethodSelector
    ttk::label      $copt.chargeMethodSelector.lbl      -text "Charge Optimization Method: " -anchor w -font TkDefaultFont
    ttk::menubutton $copt.chargeMethodSelector.selector -direction below -menu $w.chargeMethodSelectorMenu -textvariable ::ForceFieldToolKit::gui::coptMethod -width 15
    ttk::separator  $copt.chargeMethodSelectorSep -orient horizontal

    grid $copt.chargeMethodSelector    -column 0 -row 0 -sticky nswe -padx $hsepPadX -pady $labelFramePadY
    grid $copt.chargeMethodSelector.lbl      -column 0 -row 0 -sticky nwe
    grid $copt.chargeMethodSelector.selector -column 1 -row 0 -sticky nsw
    grid $copt.chargeMethodSelectorSep -column 0 -row 1 -sticky nwe -padx $hsepPadX -pady $hsepPadY

    grid columnconfigure $copt.chargeMethodSelector 1 -minsize 15 -weight 1


    # Input section
    #----------------------
    # build label frame
    ttk::labelframe $copt.input -labelanchor nw -padding $labelFrameInternalPadding
    ttk::label $copt.input.lblWidget -text "$downPoint Input" -anchor w -font TkDefaultFont
    $copt.input configure -labelwidget $copt.input.lblWidget

    # build placeholder label (when compacted)
    ttk::label $copt.inputPlaceHolder -text "$rightPoint Input" -anchor w -font TkDefaultFont

    # set mouse click bindings to expand/contract input settings
    bind $copt.input.lblWidget <Button-1> {
        grid remove .fftk_gui.hlf.nb.chargeopt.input
        grid .fftk_gui.hlf.nb.chargeopt.inputPlaceHolder
        grid rowconfigure .fftk_gui.hlf.nb.chargeopt 2 -weight 0
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }
    bind $copt.inputPlaceHolder <Button-1> {
        grid remove .fftk_gui.hlf.nb.chargeopt.inputPlaceHolder
        grid .fftk_gui.hlf.nb.chargeopt.input
        grid rowconfigure .fftk_gui.hlf.nb.chargeopt 2 -weight 1
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }

    # build elements
    ttk::label $copt.input.psfLbl -text "PSF File:"
    ttk::entry $copt.input.psfPath -textvariable ::ForceFieldToolKit::ChargeOpt::psfPath
    ttk::button $copt.input.psfBrowse -text "Browse" \
        -command {
            set tempfile [tk_getOpenFile -title "Select a PSF File" -filetypes $::ForceFieldToolKit::gui::psfType]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::ChargeOpt::psfPath $tempfile }
        }
    ttk::label $copt.input.pdbLbl -text "PDB File:"
    ttk::entry $copt.input.pdbPath -textvariable ::ForceFieldToolKit::Configuration::geomOptPDB
    ttk::button $copt.input.pdbBrowse -text "Browse" \
        -command {
            set tempfile [tk_getOpenFile -title "Select a PDB File" -filetypes $::ForceFieldToolKit::gui::pdbType]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::Configuration::geomOptPDB $tempfile }
        }
    ttk::label $copt.input.resLbl -text "Residue Name:"
    ttk::entry $copt.input.resName -textvariable ::ForceFieldToolKit::ChargeOpt::resName -justify center
    ttk::button $copt.input.resTakeFromTop -text "Resname From TOP" \
        -command {
            if { [llength [molinfo list]] == 0 } { tk_messageBox -type ok -icon warning -message "Action halted on error!" -detail "No PSF/PDB loaded in VMD."; return }
            set ::ForceFieldToolKit::ChargeOpt::resName [lindex [[atomselect top all] get resname] 0]
        }

    ttk::separator $copt.input.sep1 -orient vertical

    ttk::button $copt.input.load -text "Load PSF/PDB" \
        -command {
            if { $::ForceFieldToolKit::ChargeOpt::psfPath eq "" || ![file exists $::ForceFieldToolKit::ChargeOpt::psfPath] } {
                tk_messageBox -type ok -icon warning -message "Action halted on error!" -detail "Cannot find PSF file."
                return
            }
            if { $::ForceFieldToolKit::Configuration::geomOptPDB eq "" || ![file exists $::ForceFieldToolKit::Configuration::geomOptPDB] } {
                tk_messageBox -type ok -icon warning -message "Action halted on error!" -detail "Cannot find PDB file."
                return
            }
            mol new $::ForceFieldToolKit::ChargeOpt::psfPath
            mol addfile $::ForceFieldToolKit::Configuration::geomOptPDB
            # reTypeFromPSF/reChargeFromPSF has been depreciated
            #::ForceFieldToolKit::SharedFcns::reTypeFromPSF $::ForceFieldToolKit::ChargeOpt::psfPath "top"
            #::ForceFieldToolKit::SharedFcns::reChargeFromPSF $::ForceFieldToolKit::ChargeOpt::psfPath "top"
            ::ForceFieldToolKit::gui::consoleMessage "PSF/PDB files loaded (Opt. Charges)"
        }
    ttk::label $copt.input.labelSelectLbl -text "Label Atoms" -anchor s -justify center
    ttk::menubutton $copt.input.labelSelect -direction below -menu $copt.input.labelSelect.menu -textvariable ::ForceFieldToolKit::gui::coptAtomLabel -width 6
    menu $copt.input.labelSelect.menu -tearoff no
    $copt.input.labelSelect.menu add command -label "None" -command { set ::ForceFieldToolKit::gui::coptAtomLabel None; ::ForceFieldToolKit::gui::coptShowAtomLabels }
    $copt.input.labelSelect.menu add command -label "Index" -command { set ::ForceFieldToolKit::gui::coptAtomLabel Index; ::ForceFieldToolKit::gui::coptShowAtomLabels }
    $copt.input.labelSelect.menu add command -label "Name" -command { set ::ForceFieldToolKit::gui::coptAtomLabel Name; ::ForceFieldToolKit::gui::coptShowAtomLabels }
    $copt.input.labelSelect.menu add command -label "Type" -command { set ::ForceFieldToolKit::gui::coptAtomLabel Type; ::ForceFieldToolKit::gui::coptShowAtomLabels }
    $copt.input.labelSelect.menu add command -label "Charge" -command { set ::ForceFieldToolKit::gui::coptAtomLabel Charge; ::ForceFieldToolKit::gui::coptShowAtomLabels }

    ttk::separator $copt.input.sep2 -orient horizontal

    ttk::label $copt.input.parFilesBoxLbl -text "Parameter Files (both pre-defined and in-progress)" -anchor w
    ttk::treeview $copt.input.parFilesBox -selectmode browse -yscrollcommand "$copt.input.parScroll set"
        $copt.input.parFilesBox configure -columns {filename} -show {} -height 3
        $copt.input.parFilesBox column filename -stretch 1
    ttk::scrollbar $copt.input.parScroll -orient vertical -command "$copt.input.parFilesBox yview"
    ttk::button $copt.input.parAdd -text "Add" \
        -command {
            set tempfiles [tk_getOpenFile -title "Select Parameter File(s)" -multiple 1 -filetypes $::ForceFieldToolKit::gui::parType]
            foreach tempfile $tempfiles {
                if {![string eq $tempfile ""]} { .fftk_gui.hlf.nb.chargeopt.input.parFilesBox insert {} end -values [list $tempfile] }
            }
        }
    ttk::button $copt.input.parDelete -text "Delete" -command { .fftk_gui.hlf.nb.chargeopt.input.parFilesBox delete [.fftk_gui.hlf.nb.chargeopt.input.parFilesBox selection] }
    ttk::button $copt.input.parClear -text "Clear" -command { .fftk_gui.hlf.nb.chargeopt.input.parFilesBox delete [.fftk_gui.hlf.nb.chargeopt.input.parFilesBox children {}] }

    ttk::separator $copt.input.sep3 -orient horizontal

    ttk::label $copt.input.logLbl -text "Output LOG:" -anchor w
    ttk::entry $copt.input.log -textvariable ::ForceFieldToolKit::ChargeOpt::outFileName
    ttk::button $copt.input.logSaveAs -text "SaveAs" \
        -command {
            set tempfile [tk_getSaveFile -title "Save Charge Optimization Output LOG As..." -initialfile "$::ForceFieldToolKit::ChargeOpt::outFileName" -filetypes $::ForceFieldToolKit::gui::logType -defaultextension {.log}]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::ChargeOpt::outFileName $tempfile }
        }

    # grid input elements
    grid $copt.input -column 0 -row 2 -sticky nsew -padx $labelFramePadX -pady $labelFramePadY
    grid columnconfigure $copt.input 1 -weight 1 ; # allows graceful width resize
    grid rowconfigure $copt.input {0 1 2 5 6 7 10} -uniform rt1 ; # keeps similar rows all the same height
    grid rowconfigure $copt.input 8 -weight 1 ; # allows par files box height resize
    grid remove $copt.input
    grid $copt.inputPlaceHolder -column 0 -row 2 -sticky nsew -padx $placeHolderPadX -pady $placeHolderPadY

    grid $copt.input.psfLbl -column 0 -row 0
    grid $copt.input.psfPath -column 1 -row 0 -columnspan 2 -sticky nsew -padx $entryPadX -pady $entryPadY
    grid $copt.input.psfBrowse -column 3 -row 0 -padx $vbuttonPadX -pady $vbuttonPadY
    grid $copt.input.pdbLbl -column 0 -row 1
    grid $copt.input.pdbPath -column 1 -row 1 -columnspan 2 -sticky nsew -padx $entryPadX -pady $entryPadY
    grid $copt.input.pdbBrowse -column 3 -row 1  -padx $vbuttonPadX -pady $vbuttonPadY
    grid $copt.input.resLbl -column 0 -row 2
    grid $copt.input.resName -column 1 -row 2 -sticky nsew  -padx $entryPadX -pady $entryPadY
    grid $copt.input.resTakeFromTop -column 2 -row 2 -padx $hbuttonPadX -pady $hbuttonPadY

    grid $copt.input.sep1 -column 4 -row 0 -rowspan 3 -sticky nswe -padx $vsepPadX -pady $vsepPadY

    grid $copt.input.load -column 5 -row 0 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $copt.input.labelSelectLbl -column 5 -row 1 -sticky swe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $copt.input.labelSelect -column 5 -row 2 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY

    grid $copt.input.sep2 -column 0 -row 3 -columnspan 6 -sticky we -padx $hsepPadX -pady $hsepPadY

    grid $copt.input.parFilesBoxLbl -column 0 -row 4 -columnspan 3 -sticky nswe
    grid $copt.input.parFilesBox -column 0 -row 5 -columnspan 4 -rowspan 4 -sticky nsew
    grid $copt.input.parScroll -column 4 -row 5 -rowspan 4 -sticky nsw
    grid $copt.input.parAdd -column 5 -row 5 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $copt.input.parDelete -column 5 -row 6 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $copt.input.parClear -column 5 -row 7 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY

    grid $copt.input.sep3 -column 0 -row 9 -columnspan 6 -sticky we -padx $hsepPadX -pady $hsepPadY

    grid $copt.input.logLbl -column 0 -row 10
    grid $copt.input.log -column 1 -row 10 -columnspan 2 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $copt.input.logSaveAs -column 3 -row 10 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY



    # Charge Constraints Section (cconstr)
    #-------------------------------------
    # build label frame
    ttk::labelframe $copt.cconstr -labelanchor nw -padding $labelFrameInternalPadding
    ttk::label $copt.cconstr.lblWidget -text "$downPoint Charge Constraints" -font TkDefaultFont
    $copt.cconstr configure -labelwidget $copt.cconstr.lblWidget

    # build placeholder lable (when compacted)
    ttk::label $copt.cconstrPlaceHolder -text "$rightPoint Charge Constraints" -anchor w -font TkDefaultFont

    # set mouse click bindings to expand/contract charge constraint settings
    bind $copt.cconstr.lblWidget <Button-1> {
        grid remove .fftk_gui.hlf.nb.chargeopt.cconstr
        grid .fftk_gui.hlf.nb.chargeopt.cconstrPlaceHolder
        grid rowconfigure .fftk_gui.hlf.nb.chargeopt 3 -weight 0
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }
    bind $copt.cconstrPlaceHolder <Button-1> {
        grid remove .fftk_gui.hlf.nb.chargeopt.cconstrPlaceHolder
        grid .fftk_gui.hlf.nb.chargeopt.cconstr
        grid rowconfigure .fftk_gui.hlf.nb.chargeopt 3 -weight 1
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }

    # build elements
    ttk::label $copt.cconstr.groupLbl -text "Charge Group" -anchor w
    ttk::label $copt.cconstr.initLbl -text "Initial Charge" -anchor center
    ttk::label $copt.cconstr.lowBoundLbl -text "Low Bound" -anchor center
    ttk::label $copt.cconstr.upBoundLbl -text "High Bound" -anchor center
    ttk::treeview $copt.cconstr.chargeData -selectmode browse -yscrollcommand "$copt.cconstr.chargeScroll set"
        $copt.cconstr.chargeData configure -columns {group init lowerBound upperBound} -show {} -height 4
        $copt.cconstr.chargeData heading group -text "group"
        $copt.cconstr.chargeData heading init -text "init"
        $copt.cconstr.chargeData heading lowerBound -text "lowerBound"
        $copt.cconstr.chargeData heading upperBound -text "upperBound"
        $copt.cconstr.chargeData column group -width 100 -stretch 1 -anchor w
        $copt.cconstr.chargeData column init -width 100 -stretch 0 -anchor center
        $copt.cconstr.chargeData column upperBound -width 100 -stretch 0 -anchor center
        $copt.cconstr.chargeData column lowerBound -width 100 -stretch 0 -anchor center
    ttk::scrollbar $copt.cconstr.chargeScroll -orient vertical -command "$copt.cconstr.chargeData yview"
    ttk::label $copt.cconstr.editLbl -text "Edit Entry" -anchor w
    ttk::entry $copt.cconstr.editGroup -textvariable ::ForceFieldToolKit::gui::coptEditGroup
    ttk::entry $copt.cconstr.editInit -textvariable ::ForceFieldToolKit::gui::coptEditInit -width 1 -justify center
    ttk::entry $copt.cconstr.editLowBound -textvariable ::ForceFieldToolKit::gui::coptEditLowBound -width 1 -justify center
    ttk::entry $copt.cconstr.editUpBound -textvariable ::ForceFieldToolKit::gui::coptEditUpBound -width 1 -justify center
    ttk::frame $copt.cconstr.buttonFrame
    ttk::button $copt.cconstr.buttonFrame.editUpdate -text "$accept" -width 1 \
        -command {
            .fftk_gui.hlf.nb.chargeopt.cconstr.chargeData item [.fftk_gui.hlf.nb.chargeopt.cconstr.chargeData selection] \
            -values [list $::ForceFieldToolKit::gui::coptEditGroup $::ForceFieldToolKit::gui::coptEditInit $::ForceFieldToolKit::gui::coptEditLowBound $::ForceFieldToolKit::gui::coptEditUpBound]
        }
    ttk::button $copt.cconstr.buttonFrame.editCancel -text "$cancel" -width 1 -command {::ForceFieldToolKit::gui::coptSetEditData "cconstr"}

    # set a binding to copy information into the Edit Box when the seletion changes
    bind $copt.cconstr.chargeData <<TreeviewSelect>> { ::ForceFieldToolKit::gui::coptSetEditData "cconstr" }
    bind $copt.cconstr.chargeData <KeyPress-Delete> {
        .fftk_gui.hlf.nb.chargeopt.cconstr.chargeData delete [.fftk_gui.hlf.nb.chargeopt.cconstr.chargeData selection]
        ::ForceFieldToolKit::gui::coptClearEditData "cconstr"
        }


    ttk::button $copt.cconstr.add -text "Add" \
        -command {
            .fftk_gui.hlf.nb.chargeopt.cconstr.chargeData insert {} end -values [list "AtomName1 AtomName2 ... AtomNameN" "0.0" "0.0" "0.0"]
        }
    ttk::button $copt.cconstr.delete -text "Delete" \
        -command {
            .fftk_gui.hlf.nb.chargeopt.cconstr.chargeData delete [.fftk_gui.hlf.nb.chargeopt.cconstr.chargeData selection]
            ::ForceFieldToolKit::gui::coptClearEditData "cconstr"
        }
    ttk::button $copt.cconstr.clear -text "Clear" \
        -command {
            .fftk_gui.hlf.nb.chargeopt.cconstr.chargeData delete [.fftk_gui.hlf.nb.chargeopt.cconstr.chargeData children {}]
            ::ForceFieldToolKit::gui::coptClearEditData "cconstr"
        }
    ttk::button $copt.cconstr.guess -text "Guess" \
        -command {
            # make sure that the input exists
            if { $::ForceFieldToolKit::ChargeOpt::psfPath eq ""        || ![file exists $::ForceFieldToolKit::ChargeOpt::psfPath] || \
                 $::ForceFieldToolKit::Configuration::geomOptPDB eq "" || ![file exists $::ForceFieldToolKit::Configuration::geomOptPDB] } {
                    tk_messageBox -type ok -icon warning -message "Action halted on error!" -detail "An error was found for the PSF or PDB file specified in the INPUT section."
                    return
                }
            set temp_molid [mol new $::ForceFieldToolKit::ChargeOpt::psfPath waitfor all]
            mol addfile $::ForceFieldToolKit::Configuration::geomOptPDB waitfor all $temp_molid
            ::ForceFieldToolKit::gui::coptGuessChargeGroups $temp_molid
            mol delete $temp_molid
        }
    ttk::button $copt.cconstr.moveUp -text "Move $upArrow" \
        -command {
            # ID of current
            set currentID [.fftk_gui.hlf.nb.chargeopt.cconstr.chargeData selection]
            # ID of previous
            if {[set previousID [.fftk_gui.hlf.nb.chargeopt.cconstr.chargeData prev $currentID ]] ne ""} {
                # Index of previous
                set previousIndex [.fftk_gui.hlf.nb.chargeopt.cconstr.chargeData index $previousID]
                # Move ahead of previous
                .fftk_gui.hlf.nb.chargeopt.cconstr.chargeData move $currentID {} $previousIndex
                unset previousIndex
            }
            unset currentID previousID
        }
    ttk::button $copt.cconstr.moveDown -text "Move $downArrow" \
        -command {
            # ID of current
            set currentID [.fftk_gui.hlf.nb.chargeopt.cconstr.chargeData selection]
            # ID of Next
            if {[set previousID [.fftk_gui.hlf.nb.chargeopt.cconstr.chargeData next $currentID ]] ne ""} {
                # Index of Next
                set previousIndex [.fftk_gui.hlf.nb.chargeopt.cconstr.chargeData index $previousID]
                # Move below next
                .fftk_gui.hlf.nb.chargeopt.cconstr.chargeData move $currentID {} $previousIndex
                unset previousIndex
            }
            unset currentID previousID
        }

    ttk::separator $copt.cconstr.sep1 -orient horizontal

    ttk::frame $copt.cconstr.chargeSumFrame
    ttk::label $copt.cconstr.chargeSumFrame.netChargeLbl -text "Net Charge:" -anchor w
    ttk::entry $copt.cconstr.chargeSumFrame.netChargeEntry -textvariable ::ForceFieldToolKit::gui::coptNetCharge -justify center -width 3
    ttk::label $copt.cconstr.chargeSumFrame.chargeSumLbl -text " =  Optimized Sum:" -anchor w
    ttk::label $copt.cconstr.chargeSumFrame.chargeSum -textvariable ::ForceFieldToolKit::ChargeOpt::chargeSum -anchor center -width 5
    ttk::label $copt.cconstr.chargeSumFrame.ovrChargeLbl -text " +  Override (Adv. Set.) Sum:" -anchor w
    ttk::label $copt.cconstr.chargeSumFrame.ovrCharge -textvariable ::ForceFieldToolKit::gui::coptOvrCharge -anchor center -width 5
    ttk::label $copt.cconstr.chargeSumFrame.psfChargeLbl -text " +  PSF Sum:" -anchor w
    ttk::label $copt.cconstr.chargeSumFrame.psfCharge -textvariable ::ForceFieldToolKit::gui::coptPsfCharge -anchor center -width 5
    #ttk::entry $copt.cconstr.chargeSumFrame.entry -textvariable ::ForceFieldToolKit::ChargeOpt::chargeSum -justify center -width 10

    ttk::button $copt.cconstr.calcFromTOP -text "Calculate from PSF" \
        -command {
            if { $::ForceFieldToolKit::ChargeOpt::psfPath eq "" || ![file exists $::ForceFieldToolKit::ChargeOpt::psfPath] } {
                tk_messageBox -type ok -icon warning -message "Action halted on error!" -detail "PSF file was not specified or cannot be found."
                return
            }
            if { ![string is integer $::ForceFieldToolKit::gui::coptNetCharge] } {
                tk_messageBox -type ok -icon warning -message "Action halted on error!" -detail "Net Integer charge MUST be a valid integer."
                return
            }

            set molID [mol new $::ForceFieldToolKit::ChargeOpt::psfPath]
            # reTypeFromPSF/reChargeFromPSF has been depreciated
            # ::ForceFieldToolKit::SharedFcns::reChargeFromPSF $::ForceFieldToolKit::ChargeOpt::psfPath $molID

            set data [::ForceFieldToolKit::gui::coptCalcChargeSumNEW $molID]
            set ::ForceFieldToolKit::ChargeOpt::chargeSum [lindex $data 0]
            set ::ForceFieldToolKit::gui::coptOvrCharge [lindex $data 1]
            set ::ForceFieldToolKit::gui::coptPsfCharge [lindex $data 2]

            mol delete $molID
            unset data molID
        }

    # grid elements
    grid $copt.cconstr -column 0 -row 3 -sticky nswe -padx $labelFramePadX -pady $labelFramePadY
    grid columnconfigure $copt.cconstr 0 -weight 1; # graceful width resize
    grid columnconfigure $copt.cconstr 1 -weight 0 -minsize 100; # fix column to match tv column
    grid columnconfigure $copt.cconstr 2 -weight 0 -minsize 100
    grid columnconfigure $copt.cconstr 3 -weight 0 -minsize 100
    grid rowconfigure $copt.cconstr 4 -weight 1; # graceful height resize
    grid rowconfigure $copt.cconstr {1 2 3 6 8} -uniform rt1; # define similar rows

    grid remove $copt.cconstr
    grid $copt.cconstrPlaceHolder -column 0 -row 3 -sticky nswe -padx $placeHolderPadX -pady $placeHolderPadY

    grid $copt.cconstr.groupLbl -column 0 -row 0 -sticky nswe
    grid $copt.cconstr.initLbl -column 1 -row 0 -sticky nswe
    grid $copt.cconstr.lowBoundLbl -column 2 -row 0 -sticky nswe
    grid $copt.cconstr.upBoundLbl -column 3 -row 0 -sticky nswe
    grid $copt.cconstr.chargeData -column 0 -row 1 -columnspan 4 -rowspan 4 -sticky nswe
    grid $copt.cconstr.chargeScroll -column 4 -row 1 -rowspan 4 -sticky nswe
    grid $copt.cconstr.add -column 5 -row 1 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $copt.cconstr.delete -column 5 -row 2 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $copt.cconstr.clear -column 5 -row 3 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $copt.cconstr.guess -column 6 -row 1 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $copt.cconstr.moveUp -column 6 -row 2 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $copt.cconstr.moveDown -column 6 -row 3 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY

    grid $copt.cconstr.editLbl -column 0 -row 5 -sticky nswe
    grid $copt.cconstr.editGroup -column 0 -row 6 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $copt.cconstr.editInit -column 1 -row 6 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $copt.cconstr.editLowBound -column 2 -row 6 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $copt.cconstr.editUpBound -column 3 -row 6 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $copt.cconstr.buttonFrame -column 5 -row 6 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid columnconfigure $copt.cconstr.buttonFrame 0 -weight 1
    grid columnconfigure $copt.cconstr.buttonFrame 1 -weight 1
    grid $copt.cconstr.buttonFrame.editUpdate -column 0 -row 0 -sticky nswe
    grid $copt.cconstr.buttonFrame.editCancel -column 1 -row 0 -sticky nswe

    grid $copt.cconstr.sep1 -column 0 -row 7 -columnspan 7 -sticky we -padx $hsepPadX -pady $hsepPadY
    grid $copt.cconstr.chargeSumFrame -column 0 -row 8 -columnspan 4 -sticky nswe
    #grid columnconfigure $copt.cconstr.chargeSumFrame 1 -weight 1
    grid rowconfigure $copt.cconstr.chargeSumFrame 0 -weight 1
    grid $copt.cconstr.chargeSumFrame.netChargeLbl -column 0 -row 0 -sticky nswe
    grid $copt.cconstr.chargeSumFrame.netChargeEntry -column 1 -row 0 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $copt.cconstr.chargeSumFrame.chargeSumLbl -column 2 -row 0 -sticky nswe
    grid $copt.cconstr.chargeSumFrame.chargeSum -column 3 -row 0 -sticky nswe
    grid $copt.cconstr.chargeSumFrame.ovrChargeLbl -column 6 -row 0 -sticky nswe
    grid $copt.cconstr.chargeSumFrame.ovrCharge -column 7 -row 0 -sticky nswe
    grid $copt.cconstr.chargeSumFrame.psfChargeLbl -column 4 -row 0 -sticky nswe
    grid $copt.cconstr.chargeSumFrame.psfCharge -column 5 -row 0 -sticky nswe

    grid $copt.cconstr.calcFromTOP -column 5 -row 8 -columnspan 2 -sticky nswe -padx $hbuttonPadX -pady $hbuttonPadY


    # QM Target Data
    #---------------------

    # build elements
    ttk::labelframe $copt.qmt -labelanchor nw -padding $labelFrameInternalPadding
    ttk::label $copt.qmt.lblWidget -text "$downPoint QM Target Data" -anchor w -font TkDefaultFont
    $copt.qmt configure -labelwidget $copt.qmt.lblWidget
    # build placeholder
    ttk::label $copt.qmtPlaceHolder -text "$rightPoint QM Target Data" -anchor w -font TkDefaultFont
    # set mouse click bindings to expand/contract qmt settings
    bind $copt.qmt.lblWidget <Button-1> {
        grid remove .fftk_gui.hlf.nb.chargeopt.qmt
        grid .fftk_gui.hlf.nb.chargeopt.qmtPlaceHolder
        grid rowconfigure .fftk_gui.hlf.nb.chargeopt 4 -weight 0
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }
    bind $copt.qmtPlaceHolder <Button-1> {
        grid remove .fftk_gui.hlf.nb.chargeopt.qmtPlaceHolder
        grid .fftk_gui.hlf.nb.chargeopt.qmt
        grid rowconfigure .fftk_gui.hlf.nb.chargeopt 4 -weight 1
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }
    # add QM selector
    ttk::menubutton $copt.qmt.selector -direction below -menu $w.menuQMSelector -textvariable ::ForceFieldToolKit::qmSoft -width 15

    ttk::frame $copt.qmt.spe
    ttk::label $copt.qmt.spe.lbl -text "Single Point Energy Data"
    ttk::label $copt.qmt.spe.cmpdHFLogLbl -text "Cmpd Output (HF):" -anchor w
    ttk::entry $copt.qmt.spe.cmpdHFLog -textvariable ::ForceFieldToolKit::ChargeOpt::baseHFLog
    ttk::button $copt.qmt.spe.cmpdHFLogBrowse -text "Browse" \
        -command {
            set tempfile [tk_getOpenFile -title "Select Output File From Single Point Energy Calculation for Compound" -filetypes $::ForceFieldToolKit::gui::AllLogType]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::ChargeOpt::baseHFLog $tempfile }
        }
    ttk::label $copt.qmt.spe.cmpdMP2LogLbl -text "Cmpd Output (MP2):" -anchor w
    ttk::entry $copt.qmt.spe.cmpdMP2Log -textvariable ::ForceFieldToolKit::ChargeOpt::baseMP2Log
    ttk::button $copt.qmt.spe.cmpdMP2LogBrowse -text "Browse" \
        -command {
            set tempfile [tk_getOpenFile -title "Select Output File From Single Point Energy Calculation (MP2) for Compound" -filetypes $::ForceFieldToolKit::gui::AllLogType]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::ChargeOpt::baseMP2Log $tempfile }
        }
    ttk::label $copt.qmt.spe.watLogLbl -text "Water Output:" -anchor w
    ttk::entry $copt.qmt.spe.watLog -textvariable ::ForceFieldToolKit::ChargeOpt::watLog
    ttk::button $copt.qmt.spe.watLogBrowse -text "Browse" \
        -command {
            set tempfile [tk_getOpenFile -title "Select Output File From Single Point Energy Calculation for Water" -filetypes $::ForceFieldToolKit::gui::AllLogType]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::ChargeOpt::watLog $tempfile }
        }

    ttk::separator $copt.qmt.sep1

    ttk::frame $copt.qmt.wie
    ttk::label $copt.qmt.wie.wieLbl -text "Water Interaction Energy Data" -anchor w
    ttk::label $copt.qmt.wie.logFileLbl -text "Output File" -anchor w
    ttk::label $copt.qmt.wie.atomNameLbl -text "Atom Name" -anchor center
    ttk::label $copt.qmt.wie.weightLbl -text "Weight" -anchor center
    ttk::treeview $copt.qmt.wie.logData -selectmode browse -yscrollcommand "$copt.qmt.wie.logScroll set"
        $copt.qmt.wie.logData configure -columns {logFile atomName weight} -show {} -height 7
        $copt.qmt.wie.logData heading logFile -text "Output File" -anchor w
        $copt.qmt.wie.logData heading atomName -text "Atom Name" -anchor w
        $copt.qmt.wie.logData heading weight -text "Weight" -anchor w
        $copt.qmt.wie.logData column logFile -width 400
        $copt.qmt.wie.logData column atomName -width 90 -stretch 0 -anchor center
        $copt.qmt.wie.logData column weight -width 60 -stretch 0 -anchor center
    ttk::scrollbar $copt.qmt.wie.logScroll -orient vertical -command "$copt.qmt.wie.logData yview"

    ttk::button $copt.qmt.wie.import -text "Add" \
        -command {
            # read in files, multiple allowed
            set fileList [tk_getOpenFile -title "Select Output File(s) from Water Interaction Calculations" -multiple 1 -filetypes $::ForceFieldToolKit::gui::AllLogType]
            foreach logFile $fileList {
                if {![string eq $logFile ""]} {
                    # attempt to parse atom name by genZmatrix naming scheme, or set atom name as ???
                    # and add to the treeview box
                    if {[regexp {.*-(?:ACC|DON)-(.*)} [file rootname [file tail $logFile]] tmpvar currAtomName]} {
                    	# check for exception (e.g., carbonyl), refine currAtomName on match
                    	regexp {(.*)-(120[ab]|ppn)} $currAtomName tmpvar currAtomName
                        .fftk_gui.hlf.nb.chargeopt.qmt.wie.logData insert {} end -values [list $logFile $currAtomName 1.0]
                        unset currAtomName; unset tmpvar
                    } else {
                        .fftk_gui.hlf.nb.chargeopt.qmt.wie.logData insert {} end -values [list $logFile "???" 1.0]
                    }
                }
            }
            unset fileList
        }
    ttk::button $copt.qmt.wie.delete -text "Delete" \
        -command {
            .fftk_gui.hlf.nb.chargeopt.qmt.wie.logData delete [.fftk_gui.hlf.nb.chargeopt.qmt.wie.logData selection]
            ::ForceFieldToolKit::gui::coptClearEditData "wie"
        }
    ttk::button $copt.qmt.wie.clear -text "Clear" \
        -command {
            .fftk_gui.hlf.nb.chargeopt.qmt.wie.logData delete [.fftk_gui.hlf.nb.chargeopt.qmt.wie.logData children {}]
            ::ForceFieldToolKit::gui::coptClearEditData "wie"
        }

    ttk::label $copt.qmt.wie.editLbl -text "Edit Entry" -anchor w
    ttk::frame $copt.qmt.wie.editFrame
    ttk::entry $copt.qmt.wie.editFrame.editLog -textvariable ::ForceFieldToolKit::gui::coptEditLog
    ttk::button $copt.qmt.wie.editFrame.editBrowse -text "Browse" \
        -command {
            set tempfile [tk_getOpenFile -title "Select Output File From Water Interaction Calculation" -filetypes $::ForceFieldToolKit::gui::AllLogType]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::gui::coptEditLog $tempfile }
        }
    ttk::entry $copt.qmt.wie.editAtomName -textvariable ::ForceFieldToolKit::gui::coptEditAtomName -width 1 -justify center
    ttk::entry $copt.qmt.wie.editWeight -textvariable ::ForceFieldToolKit::gui::coptEditWeight -width 1 -justify center
    ttk::frame $copt.qmt.wie.buttonFrame
    ttk::button $copt.qmt.wie.buttonFrame.editUpdate -text "$accept" -width 1 -command {
        .fftk_gui.hlf.nb.chargeopt.qmt.wie.logData item [.fftk_gui.hlf.nb.chargeopt.qmt.wie.logData selection] \
            -values [list $::ForceFieldToolKit::gui::coptEditLog $::ForceFieldToolKit::gui::coptEditAtomName $::ForceFieldToolKit::gui::coptEditWeight]
    }
    ttk::button $copt.qmt.wie.buttonFrame.editCancel -text "$cancel" -width 1 -command { ::ForceFieldToolKit::gui::coptSetEditData "wie" }

    # set a binding to copy information into the Edit Box when the seletion changes
    bind $copt.qmt.wie.logData <<TreeviewSelect>> { ::ForceFieldToolKit::gui::coptSetEditData "wie"}


    # grid elements
    grid $copt.qmt -column 0 -row 4 -sticky nsew -padx $labelFramePadX -pady $labelFramePadY
    grid columnconfigure $copt.qmt 0 -weight 1
    grid rowconfigure $copt.qmt 2 -weight 1
    grid remove $copt.qmt
    grid $copt.qmtPlaceHolder -column 0 -row 4 -sticky nswe -padx $placeHolderPadX -pady $placeHolderPadY

    grid $copt.qmt.selector   -column 0 -row 0 -columnspan 1 -sticky w

    grid $copt.qmt.spe -column 0 -row 1 -sticky nsew
    grid columnconfigure $copt.qmt.spe 1 -weight 1
    grid rowconfigure $copt.qmt.spe {0 1} -uniform rt1

    grid $copt.qmt.spe.lbl -column 0 -row 0 -columnspan 3 -sticky nsew
    grid $copt.qmt.spe.cmpdHFLogLbl -column 0 -row 1 -sticky nswe
    grid $copt.qmt.spe.cmpdHFLog -column 1 -row 1 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $copt.qmt.spe.cmpdHFLogBrowse -column 2 -row 1 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $copt.qmt.spe.cmpdMP2LogLbl -column 0 -row 2 -sticky nswe
    grid $copt.qmt.spe.cmpdMP2Log -column 1 -row 2 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $copt.qmt.spe.cmpdMP2LogBrowse -column 2 -row 2 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $copt.qmt.spe.watLogLbl -column 0 -row 3 -sticky nswe
    grid $copt.qmt.spe.watLog -column 1 -row 3 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $copt.qmt.spe.watLogBrowse -column 2 -row 3 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY

    grid $copt.qmt.sep1 -column 0 -row 2 -sticky nswe -padx $hsepPadX -pady $hsepPadY

    grid $copt.qmt.wie -column 0 -row 3 -sticky nsew
    grid columnconfigure $copt.qmt.wie 0 -weight 1
    grid columnconfigure $copt.qmt.wie 1 -minsize 90 -weight 0
    grid columnconfigure $copt.qmt.wie 2 -minsize 60 -weight 0
    grid rowconfigure $copt.qmt.wie 5 -weight 1
    grid rowconfigure $copt.qmt.wie {2 3 4 6} -uniform rt1

    grid $copt.qmt.wie.wieLbl -column 0 -row 0 -sticky nswe
    grid $copt.qmt.wie.logFileLbl -column 0 -row 1 -sticky nswe
    grid $copt.qmt.wie.atomNameLbl -column 1 -row 1 -sticky nswe
    grid $copt.qmt.wie.weightLbl -column 2 -row 1 -sticky nswe
    grid $copt.qmt.wie.logData -column 0 -row 2 -columnspan 3 -rowspan 4 -sticky nsew
    grid $copt.qmt.wie.logScroll -column 3 -row 2 -rowspan 4 -sticky nsew
    grid $copt.qmt.wie.import -column 4 -row 2 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $copt.qmt.wie.delete -column 4 -row 3 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $copt.qmt.wie.clear -column 4 -row 4 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY

    grid $copt.qmt.wie.editLbl -column 0 -row 6 -sticky nswe
    grid $copt.qmt.wie.editFrame -column 0 -row 7 -sticky nswe
    grid columnconfigure $copt.qmt.wie.editFrame 0 -weight 1

    grid $copt.qmt.wie.editFrame.editLog -column 0 -row 0 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $copt.qmt.wie.editFrame.editBrowse -column 1 -row 0 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $copt.qmt.wie.editAtomName -column 1 -row 7 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $copt.qmt.wie.editWeight -column 2 -row 7 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $copt.qmt.wie.buttonFrame -column 4 -row 7 -sticky nswe
    grid columnconfigure $copt.qmt.wie.buttonFrame 0 -weight 1
    grid columnconfigure $copt.qmt.wie.buttonFrame 1 -weight 1
    grid $copt.qmt.wie.buttonFrame.editUpdate -column 0 -row 0 -sticky we
    grid $copt.qmt.wie.buttonFrame.editCancel -column 1 -row 0 -sticky we


    # Advanced Settings
    #---------------------
    # build elements
    ttk::labelframe $copt.advset -labelanchor nw -padding $labelFrameInternalPadding
    ttk::label $copt.advset.lblWidget -text "$downPoint Advanced Settings" -anchor w -font TkDefaultFont
    $copt.advset configure -labelwidget $copt.advset.lblWidget
    # build placeholder
    ttk::label $copt.advsetPlaceHolder -text "$rightPoint Advanced Settings" -anchor w -font TkDefaultFont
    # set mouse click bindings to expand/contract qmt settings
    bind $copt.advset.lblWidget <Button-1> {
        grid remove .fftk_gui.hlf.nb.chargeopt.advset
        grid .fftk_gui.hlf.nb.chargeopt.advsetPlaceHolder
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }
    bind $copt.advsetPlaceHolder <Button-1> {
        grid remove .fftk_gui.hlf.nb.chargeopt.advsetPlaceHolder
        grid .fftk_gui.hlf.nb.chargeopt.advset
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }

    # watShift proc settings
    ttk::frame $copt.advset.watShift
    ttk::label $copt.advset.watShift.lbl -text "Water Shift Settings" -anchor w
    ttk::label $copt.advset.watShift.startLbl -text "Start:" -anchor w
    ttk::entry $copt.advset.watShift.start -textvariable ::ForceFieldToolKit::ChargeOpt::start -width 5 -justify center
    ttk::label $copt.advset.watShift.endLbl -text "End:" -anchor w
    ttk::entry $copt.advset.watShift.end -textvariable ::ForceFieldToolKit::ChargeOpt::end -width 5 -justify center
    ttk::label $copt.advset.watShift.deltaLbl -text "Delta:" -anchor w
    ttk::entry $copt.advset.watShift.delta -textvariable ::ForceFieldToolKit::ChargeOpt::delta -width 5 -justify center
    ttk::label $copt.advset.watShift.offsetLbl -text "Offset:" -anchor w
    ttk::entry $copt.advset.watShift.offset -textvariable ::ForceFieldToolKit::ChargeOpt::offset -width 5 -justify center
    ttk::label $copt.advset.watShift.scaleLbl -text "Scale:" -anchor w
    ttk::entry $copt.advset.watShift.scale -textvariable ::ForceFieldToolKit::ChargeOpt::scale -width 5 -justify center

    ttk::separator $copt.advset.sep1

    # optimize proc settings
    ttk::frame $copt.advset.optimize
    ttk::label $copt.advset.optimize.lbl -text "Optimize Settings" -anchor w
    ttk::label $copt.advset.optimize.tolLbl -text "Tolerance:" -anchor w
    ttk::entry $copt.advset.optimize.tol -textvariable ::ForceFieldToolKit::ChargeOpt::tol -width 8 -justify center
    ttk::label $copt.advset.optimize.dWeightLbl -text "Distance Weight:" -anchor w
    ttk::entry $copt.advset.optimize.dWeight -textvariable ::ForceFieldToolKit::ChargeOpt::dWeight -width 5 -justify center
    ttk::label $copt.advset.optimize.dipWeightLbl -text "Dipole Weight:" -anchor w
    ttk::entry $copt.advset.optimize.dipWeight -textvariable ::ForceFieldToolKit::ChargeOpt::dipoleWeight -width 5 -justify center

    ttk::label $copt.advset.optimize.modeLbl -text "Mode:" -anchor w
    ttk::menubutton $copt.advset.optimize.modeMenuButton -direction below -menu $copt.advset.optimize.modeMenuButton.menu -textvariable ::ForceFieldToolKit::ChargeOpt::mode -width 16
    menu $copt.advset.optimize.modeMenuButton.menu -tearoff no
    $copt.advset.optimize.modeMenuButton.menu add command -label "downhill" \
        -command {
        set ::ForceFieldToolKit::ChargeOpt::mode downhill
        grid remove .fftk_gui.hlf.nb.chargeopt.advset.optimize.saSettings
    }
    $copt.advset.optimize.modeMenuButton.menu add command -label "simulated annealing" \
        -command {
            set ::ForceFieldToolKit::ChargeOpt::mode {simulated annealing}
            grid .fftk_gui.hlf.nb.chargeopt.advset.optimize.saSettings
        }
    ttk::frame $copt.advset.optimize.saSettings
    ttk::label $copt.advset.optimize.saSettings.tempLbl -text "T:" -anchor w
    ttk::entry $copt.advset.optimize.saSettings.temp -textvariable ::ForceFieldToolKit::ChargeOpt::saT -width 8 -justify center
    ttk::label $copt.advset.optimize.saSettings.tStepsLbl -text "Tsteps:" -anchor w
    ttk::entry $copt.advset.optimize.saSettings.tSteps -textvariable ::ForceFieldToolKit::ChargeOpt::saTSteps -width 8 -justify center
    ttk::label $copt.advset.optimize.saSettings.iterLbl -text "Iter:" -anchor w
    ttk::entry $copt.advset.optimize.saSettings.iter -textvariable ::ForceFieldToolKit::ChargeOpt::saIter -width 8 -justify center

    ttk::separator $copt.advset.sep2

    # extra charge settings
    ttk::frame $copt.advset.charge
    ttk::label $copt.advset.charge.lbl -text "Additional Charge Settings" -anchor w
    ttk::label $copt.advset.charge.warningLbl -foreground red -text "Recalculate charge sums (Charge Constraints) when activating/modifying charge override!" -anchor center
    ttk::checkbutton $copt.advset.charge.reChargeOverrideButton -offvalue 0 -onvalue 1 -variable ::ForceFieldToolKit::ChargeOpt::reChargeOverride
    ttk::label $copt.advset.charge.reChargeOverrideLbl -text "Override ReChargeFromPSF:" -anchor w
    ttk::entry $copt.advset.charge.reChargeOverrideSet -textvariable ::ForceFieldToolKit::ChargeOpt::reChargeOverrideCharges -width 20
    ttk::label $copt.advset.charge.reChargeOverrideLbl2 -text "e.g. {AtomName1 Charge1} {AtomName2 Charge2} ..." -anchor center
    # change entry box to treeview here?  make appearance conditional on checkbutton?

    ttk::separator $copt.advset.sep3

#    # run settings
#    ttk::frame $copt.advset.run
#    ttk::label $copt.advset.run.lbl -text "Run Settings" -anchor w
#    ttk::label $copt.advset.run.debugLbl -text "Write debugging log" -anchor w
#    ttk::checkbutton $copt.advset.run.debugButton -offvalue 0 -onvalue 1 -variable ::ForceFieldToolKit::ChargeOpt::debug
#    ttk::label $copt.advset.run.buildScriptLbl -text "Build Run Script" -anchor w
#    ttk::checkbutton $copt.advset.run.buildScriptButton -offvalue 0 -onvalue 1 -variable ::ForceFieldToolKit::gui::coptBuildScript

    # run settings
    set ::ForceFieldToolKit::ChargeOpt::runIter  1
    ttk::frame $copt.advset.run
    ttk::label $copt.advset.run.lbl -text "Run Settings" -anchor w
    ttk::label $copt.advset.run.debugLbl -text "Write debugging log" -anchor w
    ttk::label $copt.advset.run.iterLbl -text "Number of iterations:" -anchor w
    ttk::entry $copt.advset.run.iter -textvariable ::ForceFieldToolKit::ChargeOpt::runIter -width 5 -justify center
    ttk::checkbutton $copt.advset.run.debugButton -offvalue 0 -onvalue 1 -variable ::ForceFieldToolKit::ChargeOpt::debug
    ttk::label $copt.advset.run.buildScriptLbl -text "Build Run Script" -anchor w
    ttk::checkbutton $copt.advset.run.buildScriptButton -offvalue 0 -onvalue 1 -variable ::ForceFieldToolKit::gui::coptBuildScript


    # grid elements
    grid $copt.advset -column 0 -row 5 -sticky nsew -padx $labelFramePadX -pady $labelFramePadY
    grid columnconfigure $copt.advset 0 -weight 1
    grid remove $copt.advset
    grid $copt.advsetPlaceHolder -column 0 -row 5 -sticky nswe -padx $placeHolderPadX -pady $placeHolderPadY

    grid $copt.advset.watShift -column 0 -row 0 -sticky nsew
    grid $copt.advset.watShift.lbl -column 0 -row 0 -sticky nswe -columnspan 10
    grid $copt.advset.watShift.startLbl -column 0 -row 1 -sticky nswe
    grid $copt.advset.watShift.start -column 1 -row 1 -sticky w -padx $entryPadX -pady $entryPadY
    grid $copt.advset.watShift.endLbl -column 2 -row 1 -sticky nswe
    grid $copt.advset.watShift.end -column 3 -row 1 -sticky w -padx $entryPadX -pady $entryPadY
    grid $copt.advset.watShift.deltaLbl -column 4 -row 1 -sticky nswe
    grid $copt.advset.watShift.delta -column 5 -row 1 -sticky w -padx $entryPadX -pady $entryPadY
    grid $copt.advset.watShift.offsetLbl -column 6 -row 1 -sticky nswe
    grid $copt.advset.watShift.offset -column 7 -row 1 -sticky w -padx $entryPadX -pady $entryPadY
    grid $copt.advset.watShift.scaleLbl -column 8 -row 1 -sticky nswe
    grid $copt.advset.watShift.scale -column 9 -row 1 -sticky w -padx $entryPadX -pady $entryPadY

    grid $copt.advset.sep1 -column 0 -row 1 -sticky we -padx $hsepPadX -pady $hsepPadY

    grid $copt.advset.optimize -column 0 -row 2 -sticky nswe
    grid columnconfigure $copt.advset.optimize {4 5} -weight 0
    grid columnconfigure $copt.advset.optimize {6} -weight 1
    grid $copt.advset.optimize.lbl -column 0 -row 0 -sticky nswe -columnspan 4
    grid $copt.advset.optimize.tolLbl -column 0 -row 1 -sticky nswe
    grid $copt.advset.optimize.tol -column 1 -row 1 -sticky we -padx $entryPadX -pady $entryPadY
    grid $copt.advset.optimize.dWeightLbl -column 2 -row 1 -sticky nswe
    grid $copt.advset.optimize.dWeight -column 3 -row 1 -sticky we -padx $entryPadX -pady $entryPadY
    grid $copt.advset.optimize.dipWeightLbl -column 4 -row 1 -sticky nswe
    grid $copt.advset.optimize.dipWeight -column 5 -row 1 -sticky we -padx $entryPadX -pady $entryPadY

    grid $copt.advset.optimize.modeLbl -column 0 -row 2 -sticky nswe -padx $hbuttonPadX -pady $hbuttonPadY
    grid $copt.advset.optimize.modeMenuButton -column 1 -row 2 -sticky nswe -columnspan 3
    grid $copt.advset.optimize.saSettings -column 4 -row 2 -columnspan 3 -sticky we
    grid $copt.advset.optimize.saSettings.tempLbl -column 0 -row 0 -sticky nswe
    grid $copt.advset.optimize.saSettings.temp -column 1 -row 0 -sticky we -padx $entryPadX -pady $entryPadY
    grid $copt.advset.optimize.saSettings.tStepsLbl -column 2 -row 0 -sticky nswe
    grid $copt.advset.optimize.saSettings.tSteps -column 3 -row 0 -sticky we -padx $entryPadX -pady $entryPadY
    grid $copt.advset.optimize.saSettings.iterLbl -column 4 -row 0 -sticky nswe
    grid $copt.advset.optimize.saSettings.iter -column 5 -row 0 -sticky we -padx $entryPadX -pady $entryPadY
    grid remove $copt.advset.optimize.saSettings

    grid $copt.advset.sep2 -column 0 -row 3 -sticky we -padx $hsepPadX -pady $hsepPadY

    grid $copt.advset.charge -column 0 -row 4 -sticky nsew
    grid columnconfigure $copt.advset.charge 2 -weight 1
    grid $copt.advset.charge.lbl -column 0 -row 0 -sticky nswe -columnspan 2
    grid $copt.advset.charge.warningLbl -column 2 -row 0 -sticky nswe
    grid $copt.advset.charge.reChargeOverrideButton -column 0 -row 1
    grid $copt.advset.charge.reChargeOverrideLbl -column 1 -row 1 -sticky nswe
    grid $copt.advset.charge.reChargeOverrideSet -column 2 -row 1 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $copt.advset.charge.reChargeOverrideLbl2 -column 2 -row 2 -sticky nswe

    grid $copt.advset.sep3 -column 0 -row 5 -sticky we -padx $hsepPadX -pady $hsepPadY

#    grid $copt.advset.run -column 0 -row 6 -sticky nswe
#    grid $copt.advset.run.lbl -column 0 -row 0 -sticky nswe -columnspan 4
#    grid $copt.advset.run.debugButton -column 0 -row 1
#    grid $copt.advset.run.debugLbl -column 1 -row 1 -sticky nswe -padx "0 5"
#    grid $copt.advset.run.buildScriptButton -column 2 -row 1 -padx "5 0"
#    grid $copt.advset.run.buildScriptLbl -column 3 -row 1 -sticky nswe

    grid $copt.advset.run -column 0 -row 6 -sticky nswe
    grid $copt.advset.run.lbl -column 0 -row 0 -sticky nswe -columnspan 4
    grid $copt.advset.run.iterLbl -column 0 -row 1 -sticky nswe -columnspan 4
    grid $copt.advset.run.iter -column 2 -row 1 -sticky w -columnspan 2
    grid $copt.advset.run.debugButton -column 0 -row 2
    grid $copt.advset.run.debugLbl -column 1 -row 2 -sticky nswe -padx "0 5"
    grid $copt.advset.run.buildScriptButton -column 2 -row 2 -padx "5 0"
    grid $copt.advset.run.buildScriptLbl -column 3 -row 2 -sticky nswe


    # Results Section
    #----------------

    # build the frame
    ttk::labelframe $copt.results -labelanchor nw -padding $labelFrameInternalPadding
    ttk::label $copt.results.lblWidget -text "$downPoint Results" -anchor w -font TkDefaultFont
    $copt.results configure -labelwidget $copt.results.lblWidget
    # build the placeholder
    ttk::label $copt.resultsPlaceHolder -text "$rightPoint Results" -anchor w -font TkDefaultFont
    # set mouse click bindings to expand/contract qmt settings
    bind $copt.results.lblWidget <Button-1> {
        grid remove .fftk_gui.hlf.nb.chargeopt.results
        grid .fftk_gui.hlf.nb.chargeopt.resultsPlaceHolder
        grid rowconfigure .fftk_gui.hlf.nb.chargeopt 6 -weight 0
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }
    bind $copt.resultsPlaceHolder <Button-1> {
        grid remove .fftk_gui.hlf.nb.chargeopt.resultsPlaceHolder
        grid .fftk_gui.hlf.nb.chargeopt.results
        grid rowconfigure .fftk_gui.hlf.nb.chargeopt 6 -weight 1
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }

    # build elements
    ttk::frame $copt.results.container1
    ttk::label $copt.results.container1.cgroupLbl -text "Charge Group" -anchor w
    ttk::label $copt.results.container1.prevChargeLbl -text "Prev. Charge" -anchor center
    ttk::label $copt.results.container1.finalChargeLbl -text "Final Charge" -anchor center
    ttk::treeview $copt.results.container1.cgroups -selectmode browse -yscrollcommand "$copt.results.container1.scroll set"
        $copt.results.container1.cgroups configure -columns {group prevCharge finalCharge} -show {} -height 5
        $copt.results.container1.cgroups heading group -text "Charge Groups" -anchor w
        $copt.results.container1.cgroups heading prevCharge -text "Prev. Charge" -anchor w
        $copt.results.container1.cgroups heading finalCharge -text "Final Charge" -anchor w
        $copt.results.container1.cgroups column group -width 90 -stretch 1 -anchor w
        $copt.results.container1.cgroups column prevCharge -width 90 -stretch 0 -anchor center
        $copt.results.container1.cgroups column finalCharge -width 90 -stretch 0 -anchor center
    ttk::scrollbar $copt.results.container1.scroll -orient vertical -command "$copt.results.container1.cgroups yview"
    ttk::label $copt.results.container1.modifyLbl -text "Adjust Charge" -anchor center
    ttk::entry $copt.results.container1.editCharge -textvariable ::ForceFieldToolKit::gui::coptEditFinalCharge -justify center -width 10
    ttk::frame $copt.results.container1.editAcceptCancel
    ttk::button $copt.results.container1.editAcceptCancel.accept -text "$accept" -width 1 -command {
        .fftk_gui.hlf.nb.chargeopt.results.container1.cgroups set [.fftk_gui.hlf.nb.chargeopt.results.container1.cgroups selection] finalCharge $::ForceFieldToolKit::gui::coptEditFinalCharge
        ::ForceFieldToolKit::gui::coptCalcFinalChargeTotal
    }
    ttk::button $copt.results.container1.editAcceptCancel.cancel -text "$cancel" -width 1 -command { ::ForceFieldToolKit::gui::coptSetEditData "results" }
    ttk::button $copt.results.container1.clear -text "clear" -width 1 \
        -command {
            .fftk_gui.hlf.nb.chargeopt.results.container1.cgroups delete [.fftk_gui.hlf.nb.chargeopt.results.container1.cgroups children {}]
            ::ForceFieldToolKit::gui::coptClearEditData "results"
            set ::ForceFieldToolKit::gui::coptFinalChargeTotal ""
        }

    ttk::separator $copt.results.container1.sep1 -orient horizontal
    ttk::button $copt.results.container1.setAsInit -text "Set As Initial" -command {
        # validation
        if { [llength [.fftk_gui.hlf.nb.chargeopt.cconstr.chargeData children {}]] != [llength [.fftk_gui.hlf.nb.chargeopt.results.container1.cgroups children {}]] } {
            tk_messageBox -type ok -icon warning -message "Action halted on error!" -detail "Number of Charge Groups is different between Charge Constraints and Results sections"
            return
        }
        # build an array of final charges keyed by charge group
        array set chargeList {}

        foreach ele [.fftk_gui.hlf.nb.chargeopt.results.container1.cgroups children {}] {
            set chargeGroup [.fftk_gui.hlf.nb.chargeopt.results.container1.cgroups set $ele group]
            set finalCharge [.fftk_gui.hlf.nb.chargeopt.results.container1.cgroups set $ele finalCharge]
            set chargeList($chargeGroup) $finalCharge
        }

        # reset the initial charges based on the results
        foreach ele [.fftk_gui.hlf.nb.chargeopt.cconstr.chargeData children {}] {
            set chargeGroup [.fftk_gui.hlf.nb.chargeopt.cconstr.chargeData set $ele group]
            if { ![info exists chargeList($chargeGroup)] } {
                tk_messageBox -type ok -icon warning -message "Action halted on error!" -detail "Charge Group ($chargeGroup) was not found in results."
                .fftk_gui.hlf.nb.chargeopt.cconstr.chargeData set $ele init "ERROR"
            } else {
                .fftk_gui.hlf.nb.chargeopt.cconstr.chargeData set $ele init $chargeList($chargeGroup)
            }
        }

        array unset chargeList
    }
    ttk::button $copt.results.container1.openCOLP -text "Open COLP" -command { ::ForceFieldToolKit::ChargeOpt::colp::gui }

    # set a binding to copy information into the Edit Box when the seletion changes
    bind $copt.results.container1.cgroups <<TreeviewSelect>> { ::ForceFieldToolKit::gui::coptSetEditData "results" }

    ttk::label $copt.results.container1.chargeTotalLbl -text "Charge Total: " -anchor e
    ttk::label $copt.results.container1.chargeTotal -textvariable ::ForceFieldToolKit::gui::coptFinalChargeTotal -anchor center

    ttk::separator $copt.results.sep1 -orient horizontal
    ttk::frame $copt.results.container2
    ttk::label $copt.results.container2.psfUpdateLbl -text "Update PSF with new charges (Requires PSF/PDB from Input)" -anchor w
    ttk::entry $copt.results.container2.psfNewPathDir -textvariable ::ForceFieldToolKit::gui::coptPSFNewPath
    ttk::button $copt.results.container2.psfNewPathBrowse -text "SaveAs" \
        -command {
            set temppath [tk_getSaveFile -title "Save Updated PSF File As..." -filetypes $::ForceFieldToolKit::gui::psfType -defaultextension {.psf}]
            if {![string eq $temppath ""]} { set ::ForceFieldToolKit::gui::coptPSFNewPath $temppath }
        }
    ttk::button $copt.results.container2.psfNewWrite -text "Write" \
        -command {
            ::ForceFieldToolKit::gui::coptWriteNewPSF
            ::ForceFieldToolKit::gui::consoleMessage "New PSF file written (Opt. Charges)"
        }
    ttk::separator $copt.results.container2.sep -orient horizontal
    ttk::label $copt.results.container2.logLoadLbl -text "Load output file from a previous optimization" -anchor w
    ttk::entry $copt.results.container2.logLoadPath -textvariable ::ForceFieldToolKit::gui::coptPrevLogFile
    ttk::button $copt.results.container2.logLoadBrowse -text "Browse" \
        -command {
            set tempfile [tk_getOpenFile -title "Select Charge Optimization LOG File" -filetypes $::ForceFieldToolKit::gui::logType]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::gui::coptPrevLogFile $tempfile }
        }
    ttk::button $copt.results.container2.logLoad -text "Load" \
        -command {
            ::ForceFieldToolKit::gui::coptParseLog $::ForceFieldToolKit::gui::coptPrevLogFile
            ::ForceFieldToolKit::gui::consoleMessage "Charge optimization data loaded from file"
        }

    # grid results
    grid $copt.results -column 0 -row 6 -sticky nsew -padx $labelFramePadX -pady $labelFramePadY
    grid columnconfigure $copt.results 0 -weight 1
    grid rowconfigure $copt.results 0 -weight 1
    grid remove $copt.results
    grid $copt.resultsPlaceHolder -column 0 -row 6 -sticky nswe -padx $placeHolderPadX -pady $placeHolderPadY

    grid $copt.results.container1 -column 0 -row 0 -sticky nsew
    grid columnconfigure $copt.results.container1 0 -weight 1
    grid columnconfigure $copt.results.container1 1 -minsize 90
    grid columnconfigure $copt.results.container1 2 -minsize 90
    grid rowconfigure $copt.results.container1 8 -weight 1
    grid $copt.results.container1.cgroupLbl -column 0 -row 0 -sticky nswe
    grid $copt.results.container1.prevChargeLbl -column 1 -row 0 -sticky nswe
    grid $copt.results.container1.finalChargeLbl -column 2 -row 0 -sticky nsew
    grid $copt.results.container1.cgroups -column 0 -row 1 -columnspan 3 -rowspan 8 -sticky nsew
    grid $copt.results.container1.scroll -column 3 -row 1 -rowspan 8 -sticky nswe -padx "0 5"
    grid $copt.results.container1.modifyLbl -column 4 -row 1 -sticky nwe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $copt.results.container1.editCharge -column 4 -row 2 -sticky nwe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $copt.results.container1.editAcceptCancel -column 4 -row 3 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid columnconfigure $copt.results.container1.editAcceptCancel {0 1} -weight 1
    grid $copt.results.container1.editAcceptCancel.accept -column 0 -row 0 -sticky nswe
    grid $copt.results.container1.editAcceptCancel.cancel -column 1 -row 0 -sticky nswe
    grid $copt.results.container1.clear -column 4 -row 4 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY

    grid $copt.results.container1.sep1 -column 4 -row 5 -sticky nswe -padx $hsepPadX -pady $hsepPadY
    grid $copt.results.container1.setAsInit -column 4 -row 6 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $copt.results.container1.openCOLP -column 4 -row 7 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY

    grid $copt.results.container1.chargeTotalLbl -column 1 -row 9 -sticky nwse
    grid $copt.results.container1.chargeTotal -column 2 -row 9 -sticky nswe

    grid $copt.results.sep1 -column 0 -row 1 -sticky nswe -padx $hsepPadX -pady $hsepPadY

    grid $copt.results.container2 -column 0 -row 2 -sticky nswe
    grid columnconfigure $copt.results.container2 1 -weight 1
    grid rowconfigure $copt.results.container2 {2 6} -uniform rt1

    grid $copt.results.container2.psfUpdateLbl -column 0 -row 0 -columnspan 4 -sticky nswe
    grid $copt.results.container2.psfNewPathDir -column 0 -row 2 -columnspan 2 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $copt.results.container2.psfNewPathBrowse -column 2 -row 2 -sticky nswe -padx $hbuttonPadX -pady $hbuttonPadY
    grid $copt.results.container2.psfNewWrite -column 3 -row 2 -sticky nswe -padx $hbuttonPadX -pady $hbuttonPadY

    grid $copt.results.container2.sep -column 0 -row 4 -columnspan 4 -sticky nswe -padx $hsepPadX -pady $hsepPadY

    grid $copt.results.container2.logLoadLbl -column 0 -row 5 -columnspan 4 -sticky nswe
    grid $copt.results.container2.logLoadPath -column 0 -row 6 -columnspan 2 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $copt.results.container2.logLoadBrowse -column 2 -row 6 -sticky nswe -padx $hbuttonPadX -pady $hbuttonPadY
    grid $copt.results.container2.logLoad -column 3 -row 6 -sticky nswe -padx $hbuttonPadX -pady $hbuttonPadY


    # Run Section
    #------------
    ttk::separator $copt.sep1 -orient horizontal
    ttk::frame $copt.status
    ttk::label $copt.status.lbl -text "Status:" -anchor w
    ttk::label $copt.status.txt -textvariable ::ForceFieldToolKit::gui::coptStatus -anchor w
    ttk::button $copt.runOpt -text "Run Optimization" \
        -command {
               # For the moment, stop the procedure if ORCA was selected
#                if {$::ForceFieldToolKit::qmSoft eq "ORCA"} {
#                ::ForceFieldToolKit::ORCA::tempORCAmessage
#                return
#                }
	        ::ForceFieldToolKit::gui::coptRunOpt }

    grid $copt.sep1 -column 0 -row 7 -sticky we -padx $hsepPadX -pady $hsepPadY
    grid $copt.status -column 0 -row 8 -sticky nswe -padx $buttonRunPadX -pady $buttonRunPadY
    grid $copt.status.lbl -column 0 -row 0 -sticky nswe
    grid $copt.status.txt -column 1 -row 0 -sticky nswe
    grid rowconfigure $copt 9 -weight 0 -minsize 50
    grid $copt.runOpt -column 0 -row 9 -sticky nswe -padx $buttonRunPadX -pady $buttonRunPadY


    #---------------------------------------------------#
    #  RESP Calc. tab                                   #
    #---------------------------------------------------#


    # build the ESP frame, add it to the notebook as a tab
    ttk::frame $w.hlf.nb.calcESP
    $w.hlf.nb add $w.hlf.nb.calcESP -text "Calc. ESP"
    # allow the frame to expand width with the window
    grid columnconfigure $w.hlf.nb.calcESP 0 -weight 1

    # for shorter naming notation
    set cesp $w.hlf.nb.calcESP

    # Build the ChargeOpt method selector
    ttk::frame      $cesp.selectorFrame
    ttk::label      $cesp.selectorFrame.lbl -text "Charge Optimization Method: " -anchor w -font TkDefaultFont
    ttk::menubutton $cesp.selectorFrame.selector -direction below -menu $w.chargeMethodSelectorMenu -textvariable ::ForceFieldToolKit::gui::coptMethod -width 15
    ttk::separator  $cesp.selectorSep -orient horizontal

    grid $cesp.selectorFrame     -column 0 -row 0 -sticky nswe -padx $hsepPadX -pady $labelFramePadY
    grid $cesp.selectorFrame.lbl      -column 0 -row 0 -sticky nwe
    grid $cesp.selectorFrame.selector -column 1 -row 0 -sticky nsw
    grid $cesp.selectorSep       -column 0 -row 1 -sticky nwe -padx $hsepPadX -pady $hsepPadY

    grid columnconfigure $cesp.selectorFrame 1 -minsize 15 -weight 1

    # add QM Selector
    ttk::menubutton $cesp.qmselector -direction below -menu $w.menuQMSelector -textvariable ::ForceFieldToolKit::qmSoft -width 15

    grid $cesp.qmselector   -column 0 -row 2 -columnspan 5 -sticky nsw

    # IO
    # Build the IO
    ttk::labelframe $cesp.io -labelanchor nw -padding $labelFrameInternalPadding -text "Input/Output"
    ttk::label $cesp.io.chkLbl -text "Opt. Geom. CHK/OUT/PDB File:" -anchor nw
    ttk::entry $cesp.io.chk -textvariable ::ForceFieldToolKit::ChargeOpt::ESP::chk -width 44
    ttk::button $cesp.io.chkBrowse -text "Browse" \
        -command {
            set tempfile [tk_getOpenFile -title "Select a Checkpoint, Output or PDB File" -filetypes $::ForceFieldToolKit::gui::ESPChkType]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::ChargeOpt::ESP::chk $tempfile }
        }
    ttk::label $cesp.io.gauLbl -text "Output QM File:" -anchor w
    ttk::entry $cesp.io.gau -textvariable ::ForceFieldToolKit::ChargeOpt::ESP::gau -width 44
    ttk::button $cesp.io.gauSaveAs -text "SaveAs" \
        -command {
            set tempfile [tk_getSaveFile -title "Save the QM Input File As..." -filetypes $::ForceFieldToolKit::gui::AllInpType -defaultextension {.gau}]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::ChargeOpt::ESP::gau $tempfile }
        }

    # Grid the IO
    grid $cesp.io -column 0 -row 3 -sticky nswe -padx $labelFramePadX -pady $labelFramePadY
    grid columnconfigure $cesp.io {1}   -weight 1 ; # entry boxes
    grid columnconfigure $cesp.io {0 2} -weight 0
    grid rowconfigure $cesp.io    {0 1} -uniform rt1

    grid $cesp.io.chkLbl    -column 0 -row 0
    grid $cesp.io.chk       -column 1 -row 0 -sticky nswe -padx $entryPadX   -pady $entryPadY
    grid $cesp.io.chkBrowse -column 2 -row 0              -padx $vbuttonPadX -pady $vbuttonPadY
    grid $cesp.io.gauLbl    -column 0 -row 1
    grid $cesp.io.gau       -column 1 -row 1 -sticky nswe -padx $entryPadX   -pady $entryPadY
    grid $cesp.io.gauSaveAs -column 2 -row 1              -padx $vbuttonPadX -pady $vbuttonPadY

    # QM Settings
    # build QM settings
    ttk::labelframe $cesp.qm -labelanchor nw -padding $labelFrameInternalPadding -text "QM Settings"
    ttk::label      $cesp.qm.procLbl -text "Processors:" -anchor w
    ttk::entry      $cesp.qm.proc -textvariable ::ForceFieldToolKit::Configuration::qmProc -width 2 -justify center
    ttk::label      $cesp.qm.memLbl -text "Memory(GB):" -anchor w
    ttk::entry      $cesp.qm.mem -textvariable ::ForceFieldToolKit::Configuration::qmMem -width 2 -justify center
    ttk::label      $cesp.qm.chargeLbl -text "Charge:" -anchor w
    ttk::entry      $cesp.qm.charge -textvariable ::ForceFieldToolKit::ChargeOpt::ESP::qmCharge -width 2 -justify center
    ttk::label      $cesp.qm.multLbl -text "Multiplicity:" -anchor w
    ttk::entry      $cesp.qm.mult -textvariable ::ForceFieldToolKit::ChargeOpt::ESP::qmMult -width 2 -justify center
    ttk::label      $cesp.qm.routeLbl -text "Route:" -anchor center
    ttk::entry      $cesp.qm.route -textvariable ::ForceFieldToolKit::ChargeOpt::ESP::qmRoute
    ttk::button     $cesp.qm.resetDefaults -text "Reset to Defaults" -command { ::ForceFieldToolKit::${::ForceFieldToolKit::qmSoft}::resetDefaultsESP }

    # grid QM settings
    grid $cesp.qm -column 0 -row 4 -sticky nswe -padx $labelFramePadX -pady $labelFramePadY
    grid rowconfigure $cesp.qm {0 1} -uniform rt1

    grid $cesp.qm.procLbl        -column 0 -row 0 -sticky w
    grid $cesp.qm.proc           -column 1 -row 0 -sticky w -padx $entryPadX -pady $entryPadY
    grid $cesp.qm.memLbl         -column 2 -row 0 -sticky w
    grid $cesp.qm.mem            -column 3 -row 0 -sticky w -padx $entryPadX -pady $entryPadY
    grid $cesp.qm.chargeLbl      -column 4 -row 0 -sticky w
    grid $cesp.qm.charge         -column 5 -row 0 -sticky w -padx $entryPadX -pady $entryPadY
    grid $cesp.qm.multLbl        -column 6 -row 0 -sticky w
    grid $cesp.qm.mult           -column 7 -row 0 -sticky w -padx $entryPadX -pady $entryPadY
    grid $cesp.qm.resetDefaults  -column 8 -row 0 -sticky new -padx $hbuttonPadX -pady $hbuttonPadY
    grid $cesp.qm.routeLbl       -column 0 -row 1 -padx $entryPadX -pady $entryPadY
    grid $cesp.qm.route          -column 1 -row 1 -columnspan 8 -sticky nswe

    # Run Buttons
    ttk::separator $cesp.runSep -orient horizontal
    ttk::button $cesp.writeGau -text "Write QM Input File" \
        -command {
        # For the moment, stop the procedure if ORCA was selected
#        if {$::ForceFieldToolKit::qmSoft eq "ORCA"} {
#            ::ForceFieldToolKit::ORCA::tempORCAmessage
#            return
#        }
            ::ForceFieldToolKit::ChargeOpt::ESP::writeGauFile
            ::ForceFieldToolKit::gui::consoleMessage "QM input file written for ESP calculation"
        }
    grid $cesp.runSep   -column 0 -row 5 -sticky nwe -padx $hsepPadX -pady $hsepPadY
    grid $cesp.writeGau -column 0 -row 6 -sticky nswe -padx $buttonRunPadX -pady $buttonRunPadY
    grid rowconfigure $cesp 5 -minsize 50

    #---------------------------------------------------#
    #  RESP Opt. tab                                   #
    #---------------------------------------------------#

    # build the ESP frame, add it to the notebook as a tab
    ttk::frame $w.hlf.nb.optESP
    $w.hlf.nb add $w.hlf.nb.optESP -text "Opt. ESP"
    # allow the frame to expand width with the window
    grid columnconfigure $w.hlf.nb.optESP 0 -weight 1

    # for shorter naming notation
    set oesp $w.hlf.nb.optESP

    # Build the ChargeOpt method selector
    ttk::frame $oesp.selectorFrame
    ttk::label $oesp.selectorFrame.lbl -text "Charge Optimization Method: " -anchor w -font TkDefaultFont
    ttk::menubutton $oesp.selectorFrame.selector -direction below -menu $w.chargeMethodSelectorMenu -textvariable ::ForceFieldToolKit::gui::coptMethod -width 15
    ttk::separator $oesp.selectorSep -orient horizontal

    grid $oesp.selectorFrame     -column 0 -row 0 -sticky nswe -padx $hsepPadX -pady $labelFramePadY
    grid $oesp.selectorFrame.lbl      -column 0 -row 0 -sticky nwe
    grid $oesp.selectorFrame.selector -column 1 -row 0 -sticky nsw
    grid $oesp.selectorSep       -column 0 -row 1 -sticky nwe -padx $hsepPadX -pady $hsepPadY

    grid columnconfigure $cesp.selectorFrame 1 -minsize 15 -weight 1

    # IO
    ttk::labelframe $oesp.input -labelanchor nw -text "Input" -padding $labelFrameInternalPadding
    ttk::label $oesp.input.lblWidget -text "$downPoint Input" -anchor w -font TkDefaultFont
    $oesp.input configure -labelwidget $oesp.input.lblWidget

    # build placeholder label (when compacted)
    ttk::label $oesp.inputPlaceHolder -text "$rightPoint Input" -anchor w -font TkDefaultFont

    # set mouse click bindings to expand/contract input settings
    bind $oesp.input.lblWidget <Button-1> {
        grid remove .fftk_gui.hlf.nb.optESP.input
        grid .fftk_gui.hlf.nb.optESP.inputPlaceHolder
        grid rowconfigure .fftk_gui.hlf.nb.optESP 2 -weight 0
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }
    bind $oesp.inputPlaceHolder <Button-1> {
        grid remove .fftk_gui.hlf.nb.optESP.inputPlaceHolder
        grid .fftk_gui.hlf.nb.optESP.input
        grid rowconfigure .fftk_gui.hlf.nb.optESP 2 -weight 0
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }

    grid $oesp.input -column 0 -row 2 -sticky nsew -padx $labelFramePadX -pady $labelFramePadY
    grid columnconfigure $oesp.input 5 -weight 1
    grid remove $oesp.input
    grid $oesp.inputPlaceHolder -column 0 -row 2 -sticky nsew -padx $placeHolderPadX -pady $placeHolderPadY

    # build contents
    ttk::label  $oesp.input.psfFileLbl -text "PSF File:" -anchor center
    ttk::entry  $oesp.input.psfFile -textvariable ::ForceFieldToolKit::ChargeOpt::ESP::psfFile
    ttk::button $oesp.input.psfFileBrowse -text "Browse"   \
        -command {
            set tempfile [tk_getOpenFile -title "Select a PSF File" -filetypes $::ForceFieldToolKit::gui::psfType]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::ChargeOpt::ESP::psfFile $tempfile }
        }
    ttk::label  $oesp.input.pdbFileLbl -text "PDB File:" -anchor center
    ttk::entry  $oesp.input.pdbFile -textvariable ::ForceFieldToolKit::Configuration::geomOptPDB
    ttk::button $oesp.input.pdbFileBrowse -text "Browse"   \
            -command {
                set tempfile [tk_getOpenFile -title "Select a PDB File" -filetypes $::ForceFieldToolKit::gui::pdbType]
                if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::Configuration::geomOptPDB $tempfile }
            }
    ttk::label  $oesp.input.netChargeLbl -text "Net Charge:" -anchor center
    ttk::entry  $oesp.input.netCharge -textvariable ::ForceFieldToolKit::ChargeOpt::ESP::netCharge -width 3 -justify center
    ttk::label  $oesp.input.resNameLbl -text "Resname:" -anchor center
    ttk::entry  $oesp.input.resName -textvariable ::ForceFieldToolKit::ChargeOpt::ESP::resName -justify center
    ttk::button $oesp.input.resTakeFromTop -text "Resname From TOP" \
        -command {
            if { [llength [molinfo list]] == 0 } { tk_messageBox -type ok -icon warning -message "Action halted on error!" -detail "No PSF/PDB loaded in VMD."; return }
            set sel [atomselect top all]
            set ::ForceFieldToolKit::ChargeOpt::ESP::resName [lindex [$sel get resname] 0]
            $sel delete
            set ::ForceFieldToolKit::ChargeOpt::ESP::inputName $::ForceFieldToolKit::ChargeOpt::ESP::resName
            set ::ForceFieldToolKit::ChargeOpt::ESP::newPsfName [format %s-opt.psf [file rootname $::ForceFieldToolKit::ChargeOpt::ESP::psfFile]]
        }
    ttk::button $oesp.input.load -text "Load PSF/PDB" \
        -command {
            if { $::ForceFieldToolKit::ChargeOpt::ESP::psfFile eq "" || ![file exists $::ForceFieldToolKit::ChargeOpt::ESP::psfFile] } {
                tk_messageBox -type ok -icon warning -message "Action halted on error!" -detail "Cannot find PSF file."
                return
            }
            if { $::ForceFieldToolKit::Configuration::geomOptPDB eq "" || ![file exists $::ForceFieldToolKit::Configuration::geomOptPDB] } {
                tk_messageBox -type ok -icon warning -message "Action halted on error!" -detail "Cannot find PDB file."
                return
            }
            mol new     $::ForceFieldToolKit::ChargeOpt::ESP::psfFile   waitfor all
            mol addfile $::ForceFieldToolKit::Configuration::geomOptPDB waitfor all
            ::ForceFieldToolKit::gui::consoleMessage "PSF/PDB files loaded (Opt. ESP)"
        }

    # grid contents
    grid $oesp.input.psfFileLbl     -column 0 -row 0 -sticky nswe
    grid $oesp.input.psfFile        -column 1 -row 0 -columnspan 5 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $oesp.input.psfFileBrowse  -column 6 -row 0 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $oesp.input.pdbFileLbl     -column 0 -row 1 -sticky nswe
    grid $oesp.input.pdbFile        -column 1 -row 1 -columnspan 5 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $oesp.input.pdbFileBrowse  -column 6 -row 1 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $oesp.input.netChargeLbl   -column 0 -row 2 -sticky nswe
    grid $oesp.input.netCharge      -column 1 -row 2 -sticky nswe
    grid $oesp.input.resNameLbl     -column 2 -row 2 -sticky nswe
    grid $oesp.input.resName        -column 3 -row 2 -sticky nsew -padx $entryPadX   -pady $entryPadY
    grid $oesp.input.resTakeFromTop -column 4 -row 2 -sticky nsew -padx $hbuttonPadX -pady $hbuttonPadY
    grid $oesp.input.load           -column 6 -row 2 -sticky nsew -padx $vbuttonPadX -pady $vbuttonPadY


    # Charge Constraints
    ttk::labelframe $oesp.cconstr -labelanchor nw -padding $labelFrameInternalPadding -text "Charge Constraints"
    ttk::label $oesp.cconstr.lblWidget -text "$downPoint Charge Constraints" -anchor w -font TkDefaultFont
    $oesp.cconstr configure -labelwidget $oesp.cconstr.lblWidget

    # build placeholder label (when compacted)
    ttk::label $oesp.cconstrPlaceHolder -text "$rightPoint Charge Constraints" -anchor w -font TkDefaultFont

    # set mouse click bindings to expand/contract charge constraint settings
    bind $oesp.cconstr.lblWidget <Button-1> {
        grid remove .fftk_gui.hlf.nb.optESP.cconstr
        grid .fftk_gui.hlf.nb.optESP.cconstrPlaceHolder
        grid rowconfigure .fftk_gui.hlf.nb.optESP 3 -weight 0
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }
    bind $oesp.cconstrPlaceHolder <Button-1> {
        grid remove .fftk_gui.hlf.nb.optESP.cconstrPlaceHolder
        grid .fftk_gui.hlf.nb.optESP.cconstr
        grid rowconfigure .fftk_gui.hlf.nb.optESP 3 -weight 0
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }

    grid $oesp.cconstr -column 0 -row 3 -sticky nswe -padx $labelFramePadX -pady $labelFramePadY
    grid columnconfigure $oesp.cconstr {0    } -weight 1             ; # graceful width resize
    grid columnconfigure $oesp.cconstr {1 2 3} -weight 0 -minsize 100; # fix column to match tv column
    grid rowconfigure    $oesp.cconstr {4    } -weight 1             ; # graceful height resize
    grid remove $oesp.cconstr
    grid $oesp.cconstrPlaceHolder -column 0 -row 3 -sticky nsew -padx $placeHolderPadX -pady $placeHolderPadY

    # build contents
    ttk::label $oesp.cconstr.groupLbl    -text "Charge Group" -anchor w
    ttk::label $oesp.cconstr.initLbl     -text "Initial Charge" -anchor center
    ttk::label $oesp.cconstr.restrainLbl -text "Restraint Type" -anchor center
    ttk::label $oesp.cconstr.restNumLbl  -text "Restraint Atom" -anchor center
    ttk::treeview $oesp.cconstr.chargeData -selectmode extended -yscrollcommand "$oesp.cconstr.chargeScroll set"
        $oesp.cconstr.chargeData configure -columns {group init restrain restNum} -show {} -height 4
        $oesp.cconstr.chargeData heading group    -text "group"
        $oesp.cconstr.chargeData heading init     -text "init"
        $oesp.cconstr.chargeData heading restrain -text "restrain"
        $oesp.cconstr.chargeData heading restNum  -text "restNum"
        $oesp.cconstr.chargeData column group     -width 100 -stretch 1 -anchor w
        $oesp.cconstr.chargeData column init      -width 100 -stretch 0 -anchor center
        $oesp.cconstr.chargeData column restrain  -width 100 -stretch 0 -anchor center
        $oesp.cconstr.chargeData column restNum   -width 100 -stretch 0 -anchor center
    ttk::scrollbar $oesp.cconstr.chargeScroll -orient vertical -command "$oesp.cconstr.chargeData yview"
    ttk::label $oesp.cconstr.editLbl   -text "Edit Entry" -anchor w
    ttk::entry $oesp.cconstr.editGroup -textvariable ::ForceFieldToolKit::gui::espEditGroup
    ttk::entry $oesp.cconstr.editInit  -textvariable ::ForceFieldToolKit::gui::espEditInit -width 1 -justify center
    ttk::menubutton $oesp.cconstr.editRestraint -direction below -menu $oesp.cconstr.editRestraint.menu -textvariable ::ForceFieldToolKit::gui::espEditRestraint -width 10
    menu $oesp.cconstr.editRestraint.menu -tearoff no
        $oesp.cconstr.editRestraint.menu add command -label "Static"  -command { set ::ForceFieldToolKit::gui::espEditRestraint "Static" }
        $oesp.cconstr.editRestraint.menu add command -label "Dynamic" \
	    -command {
		set ::ForceFieldToolKit::gui::espEditRestraint "Dynamic"
##		set ::ForceFieldToolKit::gui::espEditRestNum [lindex $::ForceFieldToolKit::gui::espEditGroup 0]
	    }
        $oesp.cconstr.editRestraint.menu add command -label "None"    -command { set ::ForceFieldToolKit::gui::espEditRestraint "None" }
    #ttk::combobox $oesp.cconstr.editRestrain -textvariable ::ForceFieldToolKit::gui::espEditRestrain -values "Static Dynamic None" -state readonly -width 1 -justify center
    #ttk::entry $oesp.cconstr.editRestNum -textvariable ::ForceFieldToolKit::gui::espEditRestNum -width 1 -justify center
    ttk::label $oesp.cconstr.editRestNum -textvariable ::ForceFieldToolKit::gui::espEditRestNum -anchor center
					## -textvariable ::ForceFieldToolKit::gui::espEditRestNum -width 1 -justify center
##    ttk::menubutton $oesp.cconstr.editRestNum -direction below -menu $oesp.cconstr.editRestNum.menu -textvariable ::ForceFieldToolKit::gui::espEditRestNum -width 5
##    menu $oesp.cconstr.editRestNum.menu -tearoff no

    ttk::frame $oesp.cconstr.buttonFrame
    ttk::button $oesp.cconstr.buttonFrame.editUpdate -text "$accept" -width 1 \
        -command {
            if { [llength $::ForceFieldToolKit::gui::espEditGroup] == 1 && $::ForceFieldToolKit::gui::espEditRestraint eq "Dynamic" } {
                set ::ForceFieldToolKit::gui::espEditRestraint "None"
            }
            if { $::ForceFieldToolKit::gui::espEditRestraint ne "Dynamic" } {
                set ::ForceFieldToolKit::gui::espEditRestNum "N/A"
            } elseif { $::ForceFieldToolKit::gui::espEditRestNum eq "N/A" } {
                set ::ForceFieldToolKit::gui::espEditRestNum [lindex $::ForceFieldToolKit::gui::espEditGroup 0]
            }
            .fftk_gui.hlf.nb.optESP.cconstr.chargeData item [.fftk_gui.hlf.nb.optESP.cconstr.chargeData selection] \
            -values [list $::ForceFieldToolKit::gui::espEditGroup $::ForceFieldToolKit::gui::espEditInit $::ForceFieldToolKit::gui::espEditRestraint $::ForceFieldToolKit::gui::espEditRestNum]
        }
    ttk::button $oesp.cconstr.buttonFrame.editCancel -text "$cancel" -width 1 -command {::ForceFieldToolKit::gui::espSetEditData "cconstr"}

    # set a binding to copy information into the Edit Box when the seletion changes
    bind $oesp.cconstr.chargeData <<TreeviewSelect>> { ::ForceFieldToolKit::gui::espSetEditData "cconstr" }
    bind $oesp.cconstr.chargeData <KeyPress-Delete> {
        foreach id [.fftk_gui.hlf.nb.optESP.cconstr.chargeData selection] {
            .fftk_gui.hlf.nb.optESP.cconstr.chargeData delete $id
        }
        # ::ForceFieldToolKit::gui::espClearEditData "cconstr"
        ::ForceFieldToolKit::gui::espDisableEditData
    }
    bind $oesp.cconstr.chargeData <KeyPress-Escape> { .fftk_gui.hlf.nb.optESP.cconstr.chargeData selection set {} }

    ttk::button $oesp.cconstr.guess -text "Guess" \
        -command {
            if { [llength [molinfo list]] == 0 } {
                tk_messageBox -type ok -icon warning -message "Action halted on error!" -detail "No molecule found as TOP in VMD.  Load PSF/PDB pair from INPUT section."
                return
            }
            lassign [::ForceFieldToolKit::gui::espGuessChargeGroups] cgNames cgInit
            # clear the treeview box
            .fftk_gui.hlf.nb.optESP.cconstr.chargeData delete [.fftk_gui.hlf.nb.optESP.cconstr.chargeData children {}]
            # insert data into treeview box
            for {set i 0} {$i < [llength $cgNames]} {incr i} {
                .fftk_gui.hlf.nb.optESP.cconstr.chargeData insert {} end -values [list "[lindex $cgNames $i]" "[lindex $cgInit $i]" "None" "N/A"]
            }
            unset cgNames; unset cgInit
        }
    ttk::button $oesp.cconstr.add -text "Add" -command { .fftk_gui.hlf.nb.optESP.cconstr.chargeData insert {} end -values [list "AtomName1 AtomName2 ... AtomNameN" "0.0" "None"] }
    ttk::button $oesp.cconstr.delete -text "Delete" \
        -command {
             .fftk_gui.hlf.nb.optESP.cconstr.chargeData delete [.fftk_gui.hlf.nb.optESP.cconstr.chargeData selection]
            ::ForceFieldToolKit::gui::espClearEditData "cconstr"
        }
    ttk::button $oesp.cconstr.clear -text "Clear" \
        -command {
            .fftk_gui.hlf.nb.optESP.cconstr.chargeData delete [.fftk_gui.hlf.nb.optESP.cconstr.chargeData children {}]
            ::ForceFieldToolKit::gui::espClearEditData "cconstr"
        }

    ttk::button $oesp.cconstr.group -text "Group" \
        -command {
            # look up some ids for convenience
            set tv .fftk_gui.hlf.nb.optESP.cconstr.chargeData
            set selectedEntryIds [$tv selection]

            # keep the first selected entry
            set defaultEntryId [lindex $selectedEntryIds 0]
            set groupAtoms [$tv set $defaultEntryId group]
            set defaultRestraintAtom $groupAtoms

            # add all other selected entries to the group
            for {set i 1} {$i < [llength $selectedEntryIds]} {incr i} {
                lappend groupAtoms [$tv set [lindex $selectedEntryIds $i] group]
            }

            # update the TV
            $tv set $defaultEntryId group $groupAtoms
##            $tv set $defaultEntryId restNum $defaultRestraintAtom
            $tv delete [lrange $selectedEntryIds 1 end]
            $tv selection set $defaultEntryId ; # is this required? does this trigger the edit data copy?
        }
    ttk::button $oesp.cconstr.split -text "Split" \
        -command {
            # look up some ids for convenience
            set tv .fftk_gui.hlf.nb.optESP.cconstr.chargeData
            set selectedEntryIds [$tv selection]

            # use an outer loop in the even that multiple groups are being split
            foreach id $selectedEntryIds {
                lassign [$tv item $id -values] groupAtoms initCharge restraintType restraintAtom

                # set the existing entry to the first value and add additional entries for all other
                $tv set $id group [lindex $groupAtoms 0]
                $tv set $id restNum N/A
                set insertionIndex [expr { int([$tv index $id]) }]
                incr insertionIndex
                for {set i 1} {$i < [llength $groupAtoms]} {incr i} {
                    set groupAtom [lindex $groupAtoms $i]
                    #if { $restraintAtom eq "N/A" } { set rA "N/A" } else { set rA $groupAtom }
                    #set values [list $groupAtom $initCharge $restraintType 'N/A']
                    set values [list $groupAtom $initCharge None N/A]
                    $tv insert {} $insertionIndex -values $values
                    incr insertionIndex
                }
            }

            # for simplicity, return with a clear selection
            $tv selection set {}
        }
    ttk::button $oesp.cconstr.moveUp -text "Move $upArrow" \
        -command {
            # ID of current
            set currentID [.fftk_gui.hlf.nb.optESP.cconstr.chargeData selection]
            # ID of previous
            if {[set previousID [.fftk_gui.hlf.nb.optESP.cconstr.chargeData prev $currentID ]] ne ""} {
                # Index of previous
                set previousIndex [.fftk_gui.hlf.nb.optESP.cconstr.chargeData index $previousID]
                # Move ahead of previous
                .fftk_gui.hlf.nb.optESP.cconstr.chargeData move $currentID {} $previousIndex
                unset previousIndex
            }
            unset currentID previousID
        }
    ttk::button $oesp.cconstr.moveDown -text "Move $downArrow" \
        -command {
            # ID of current
            set currentID [.fftk_gui.hlf.nb.optESP.cconstr.chargeData selection]
            # ID of Next
            if {[set previousID [.fftk_gui.hlf.nb.optESP.cconstr.chargeData next $currentID ]] ne ""} {
                # Index of Next
                set previousIndex [.fftk_gui.hlf.nb.optESP.cconstr.chargeData index $previousID]
                # Move below next
                .fftk_gui.hlf.nb.optESP.cconstr.chargeData move $currentID {} $previousIndex
                unset previousIndex
            }
            unset currentID previousID
        }

    # grid elements
    grid $oesp.cconstr.groupLbl      -column 0 -row 0 -sticky nswe
    grid $oesp.cconstr.initLbl       -column 1 -row 0 -sticky nswe
    grid $oesp.cconstr.restrainLbl   -column 2 -row 0 -sticky nswe
    grid $oesp.cconstr.restNumLbl    -column 3 -row 0 -sticky nswe
    grid $oesp.cconstr.chargeData    -column 0 -row 1 -columnspan 4 -rowspan 5 -sticky nswe
    grid $oesp.cconstr.chargeScroll  -column 4 -row 1               -rowspan 5 -sticky nswe

    grid $oesp.cconstr.guess         -column 5 -row 1 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $oesp.cconstr.add           -column 5 -row 2 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $oesp.cconstr.delete        -column 5 -row 3 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $oesp.cconstr.clear         -column 5 -row 4 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $oesp.cconstr.group         -column 6 -row 1 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $oesp.cconstr.split         -column 6 -row 2 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $oesp.cconstr.moveUp        -column 6 -row 3 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $oesp.cconstr.moveDown      -column 6 -row 4 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY

    grid $oesp.cconstr.editLbl       -column 0 -row 6 -sticky nswe
    grid $oesp.cconstr.editGroup     -column 0 -row 7 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $oesp.cconstr.editInit      -column 1 -row 7 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $oesp.cconstr.editRestraint -column 2 -row 7 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $oesp.cconstr.editRestNum   -column 3 -row 7 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $oesp.cconstr.buttonFrame   -column 5 -row 7 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $oesp.cconstr.buttonFrame.editUpdate -column 0 -row 0 -sticky nswe
    grid $oesp.cconstr.buttonFrame.editCancel -column 1 -row 0 -sticky nswe

    grid columnconfigure $oesp.cconstr.buttonFrame 0 -weight 1
    grid columnconfigure $oesp.cconstr.buttonFrame 1 -weight 1


    # Prepare Resp Program Input Files
    ttk::labelframe $oesp.inSettings -labelanchor nw -padding $labelFrameInternalPadding -text "Input File Settings"
    ttk::label      $oesp.inSettings.lblWidget -text "$downPoint Input File Settings" -anchor w -font TkDefaultFont
    $oesp.inSettings configure -labelwidget $oesp.inSettings.lblWidget

    # build placeholder label (when compacted)
    ttk::label $oesp.inSettingsPlaceHolder -text "$rightPoint Input File Settings" -anchor w -font TkDefaultFont

    # set mouse click bindings to expand/contract input file settings
    bind $oesp.inSettings.lblWidget <Button-1> {
        grid remove .fftk_gui.hlf.nb.optESP.inSettings
        grid .fftk_gui.hlf.nb.optESP.inSettingsPlaceHolder
        grid rowconfigure .fftk_gui.hlf.nb.optESP 4 -weight 0
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }
    bind $oesp.inSettingsPlaceHolder <Button-1> {
        grid remove .fftk_gui.hlf.nb.optESP.inSettingsPlaceHolder
        grid .fftk_gui.hlf.nb.optESP.inSettings
        grid rowconfigure .fftk_gui.hlf.nb.optESP 4 -weight 0
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }

    grid $oesp.inSettings -column 0 -row 4 -sticky nswe -padx $labelFramePadX -pady $labelFramePadY
    grid columnconfigure $oesp.inSettings 7 -weight 1
    grid rowconfigure    $oesp.inSettings 4 -minsize 50 -weight 0
    grid remove $oesp.inSettings
    grid $oesp.inSettingsPlaceHolder -column 0 -row 4 -sticky nsew -padx $placeHolderPadX -pady $placeHolderPadY

    # add QM Selector
    ttk::menubutton $oesp.inSettings.selector -direction below -menu $w.menuQMSelector -textvariable ::ForceFieldToolKit::qmSoft -width 15

    grid $oesp.inSettings.selector   -column 0 -row 0 -columnspan 3 -sticky w

    ttk::label $oesp.inSettings.gauLogLbl -text "QM ESP LOG/OUT" -anchor center
    ttk::entry $oesp.inSettings.gauLog -textvariable ::ForceFieldToolKit::ChargeOpt::ESP::gauLog
    ttk::button $oesp.inSettings.gauLogBrowse -text "Browse"   \
        -command {
            set tempfile [tk_getOpenFile -title "Select a QM Output File" -filetypes $::ForceFieldToolKit::gui::AllLogType]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::ChargeOpt::ESP::gauLog $tempfile }
        }
    ttk::label  $oesp.inSettings.fileNameLbl -text "Input Files Basename:" -anchor center
    ttk::entry  $oesp.inSettings.fileName    -textvariable ::ForceFieldToolKit::ChargeOpt::ESP::inputName
    ttk::button $oesp.inSettings.saveAs      -text "Save As" \
        -command {
           set tempfile [tk_getSaveFile -title "Save the RESP Input Files As..." ]
           if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::ChargeOpt::ESP::inputName $tempfile }
        }
    ttk::label  $oesp.inSettings.ihfreeLbl     -text "ihfree:" -anchor e
    ttk::entry  $oesp.inSettings.ihfree        -textvariable ::ForceFieldToolKit::ChargeOpt::ESP::ihfree -justify center -width 5
    ttk::label  $oesp.inSettings.qwtLbl        -text "qwt:"    -anchor center
    ttk::entry  $oesp.inSettings.qwt           -textvariable ::ForceFieldToolKit::ChargeOpt::ESP::qwt    -justify center -width 10
    ttk::label  $oesp.inSettings.iqoptLbl      -text "iqopt:"  -anchor center
    ttk::entry  $oesp.inSettings.iqopt         -textvariable ::ForceFieldToolKit::ChargeOpt::ESP::iqopt  -justify center -width 5
    ttk::button $oesp.inSettings.resetDefaults -text "Reset to Defaults" -command { ::ForceFieldToolKit::SharedFcns::resetInputDefaultsESP }

    ttk::separator $oesp.inSettings.sep1 -orient horizontal
    ttk::button    $oesp.inSettings.writeInput -text "Write Input Files" \
        -command {
        	# For the moment, stop the procedure if ORCA was selected
#        	if {$::ForceFieldToolKit::qmSoft eq "ORCA"} {
#           	::ForceFieldToolKit::ORCA::tempORCAmessage
#           	return
#        	}
                ::ForceFieldToolKit::ChargeOpt::ESP::writeDatFile

                # gather the TV data
                set chargeGroups {}; set chargeInit {}; set restrainData {}; set restrainNum {}
                foreach tvItem [.fftk_gui.hlf.nb.optESP.cconstr.chargeData children {}] {
                    set treeData [.fftk_gui.hlf.nb.optESP.cconstr.chargeData item $tvItem -values]
                    lappend chargeGroups [lindex $treeData 0]
                    lappend chargeInit   [lindex $treeData 1]
                    lappend restrainData [lindex $treeData 2]
                    lappend restrainNum  [lindex $treeData 3]
                }
                # hand if off to procs
###                ::ForceFieldToolKit::ChargeOpt::ESP::writeQinFile $chargeGroups $chargeInit $restrainData $restrainNum
                ::ForceFieldToolKit::ChargeOpt::ESP::writeInFiles $chargeGroups $chargeInit $restrainData $restrainNum
        }

    # grid elements
    grid $oesp.inSettings.gauLogLbl     -column 0 -row 1 -sticky nswe
    grid $oesp.inSettings.gauLog        -column 1 -row 1 -columnspan 7 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $oesp.inSettings.gauLogBrowse  -column 8 -row 1 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $oesp.inSettings.fileNameLbl   -column 0 -row 2 -sticky nswe
    grid $oesp.inSettings.fileName      -column 1 -row 2 -columnspan 7 -sticky nswe
    grid $oesp.inSettings.saveAs        -column 8 -row 2 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $oesp.inSettings.ihfreeLbl     -column 0 -row 3 -sticky nswe
    grid $oesp.inSettings.ihfree        -column 1 -row 3 -sticky we
    grid $oesp.inSettings.qwtLbl        -column 2 -row 3 -sticky nswe
    grid $oesp.inSettings.qwt           -column 3 -row 3 -sticky we
    grid $oesp.inSettings.iqoptLbl      -column 4 -row 3 -sticky nswe
    grid $oesp.inSettings.iqopt         -column 5 -row 3 -sticky we
    grid $oesp.inSettings.resetDefaults -column 6 -row 3 -sticky nswe -padx $hbuttonPadX -pady $hbuttonPadY

    grid $oesp.inSettings.sep1          -column 0 -row 4 -columnspan 9 -sticky we   -padx $hsepPadX -pady $hsepPadY
    grid $oesp.inSettings.writeInput    -column 0 -row 5 -columnspan 9 -sticky nswe -padx $buttonRunPadX -pady $buttonRunPadY


    # Calc. ESP section
    ttk::labelframe $oesp.runESP -labelanchor nw -padding $labelFrameInternalPadding -text "Calculate RESP Charges"
    ttk::label $oesp.runESP.lblWidget -text "$downPoint Calculate RESP Charges" -anchor w -font TkDefaultFont
    $oesp.runESP configure -labelwidget $oesp.runESP.lblWidget

    # build placeholder label (when compacted)
    ttk::label $oesp.runESPPlaceHolder -text "$rightPoint Calculate RESP Charges" -anchor w -font TkDefaultFont

    # set mouse click bindings to expand/contract input file settings
    bind $oesp.runESP.lblWidget <Button-1> {
        grid remove .fftk_gui.hlf.nb.optESP.runESP
        grid .fftk_gui.hlf.nb.optESP.runESPPlaceHolder
        grid rowconfigure .fftk_gui.hlf.nb.optESP 5 -weight 0
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }
    bind $oesp.runESPPlaceHolder <Button-1> {
        grid remove .fftk_gui.hlf.nb.optESP.runESPPlaceHolder
        grid .fftk_gui.hlf.nb.optESP.runESP
        grid rowconfigure .fftk_gui.hlf.nb.optESP 5 -weight 0
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }
    grid $oesp.runESP -column 0 -row 5 -sticky nswe -padx $labelFramePadX -pady $labelFramePadY
    grid columnconfigure $oesp.runESP {1  } -weight 1
    grid columnconfigure $oesp.runESP {0 2} -weight 0
    grid remove $oesp.runESP
    grid $oesp.runESPPlaceHolder -column 0 -row 5 -sticky nsew -padx $placeHolderPadX -pady $placeHolderPadY

    # build elements
    ttk::label  $oesp.runESP.newPsfNameLbl -text "Updated PSF Name:" -anchor center
    # should this be editable?  if not, make a label.  if yes, include a Save As button
    ttk::entry  $oesp.runESP.newPsfName    -textvariable ::ForceFieldToolKit::ChargeOpt::ESP::newPsfName
    ttk::button $oesp.runESP.saveAs      -text "Save As" \
        -command {
           set tempfile [tk_getSaveFile -title "Save the updated PSF file as..." ]
           if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::ChargeOpt::ESP::newPsfName $tempfile }
        }
##    ttk::label  $oesp.runESP.newPsfName    -textvariable ::ForceFieldToolKit::ChargeOpt::ESP::newPsfName
    ttk::label  $oesp.runESP.respPathLbl   -text "RESP Path:" -anchor center
# TEMPORARY PATH FOR RESP, TO BE DELETED
set ::ForceFieldToolKit::ChargeOpt::ESP::respPath "/Projects/kinlam2/anaconda3/bin/resp"
    ttk::entry  $oesp.runESP.respPath      -textvariable ::ForceFieldToolKit::ChargeOpt::ESP::respPath
    ttk::button $oesp.runESP.respBrowse    -text "Browse"   \
        -command {
            set tempfile [tk_getOpenFile -title "RESP Path"]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::ChargeOpt::ESP::respPath $tempfile }
        }
    # bash path is only put into the grid for windows?
    ttk::label  $oesp.runESP.bashPathLbl -text "Bash Path:" -anchor center
    ttk::entry  $oesp.runESP.bashPath    -textvariable ::ForceFieldToolKit::ChargeOpt::ESP::bashPath
    ttk::button $oesp.runESP.bashBrowse  -text "Browse"   \
        -command {
            set tempfile [tk_getOpenFile -title "Bash Path"]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::ChargeOpt::ESP::bashPath $tempfile }
        }
    ttk::separator $oesp.runESP.runSep -orient horizontal
    ttk::button $oesp.runESP.runESP -text "Calc. RESP Charges" \
        -command {
            # For the moment, stop the procedure if ORCA was selected
#            if {$::ForceFieldToolKit::qmSoft eq "ORCA"} {
#              ::ForceFieldToolKit::ORCA::tempORCAmessage
#              return
#            }
            ::ForceFieldToolKit::ChargeOpt::ESP::runESP
            ::ForceFieldToolKit::ChargeOpt::ESP::updatePSF
        }

    ttk::separator $oesp.sep1 -orient horizontal
    ttk::frame     $oesp.status
    ttk::label     $oesp.status.lbl -text "Status:" -anchor w
    ttk::label     $oesp.status.txt -textvariable ::ForceFieldToolKit::ChargeOpt::ESP::espStatus -anchor nw

    # grid elements
    grid $oesp.runESP.newPsfNameLbl -column 0 -row 0 -sticky nswe
    grid $oesp.runESP.newPsfName    -column 1 -row 0 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $oesp.runESP.respPathLbl   -column 0 -row 1 -sticky nswe
    grid $oesp.runESP.respPath      -column 1 -row 1 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $oesp.runESP.respBrowse    -column 2 -row 1 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY

    grid $oesp.runESP.runSep        -column 0 -row 2 -columnspan 3 -sticky nwe -padx $hsepPadX -pady $hsepPadY
    # shouldn't the separator and the run button be outside of the collapsable element?
    grid $oesp.sep1                 -column 0 -row 6 -sticky nwe  -padx $hsepPadX -pady $hsepPadY
    grid $oesp.status               -column 0 -row 7 -sticky nswe -padx $buttonRunPadX -pady $buttonRunPadY
    grid $oesp.status.lbl           -column 0 -row 0 -sticky nswe
    grid $oesp.status.txt           -column 1 -row 0 -sticky nswe

    if { $::tcl_platform(platform) == "windows" } {
        grid $oesp.runESP.bashPathLbl -column 0 -row 3 -sticky nswe
        grid $oesp.runESP.bashPath    -column 1 -row 3 -sticky nswe -padx $entryPadX -pady $entryPadY
        grid $oesp.runESP.bashBrowse  -column 2 -row 3 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
        grid $oesp.runESP.runESP      -column 0 -row 4 -columnspan 3 -sticky nswe
        grid rowconfigure $oesp.runESP 4 -minsize 50
    } else {
        grid $oesp.runESP.runESP      -column 0 -row 3 -columnspan 3 -sticky nswe
        grid rowconfigure $oesp.runESP 3 -minsize 50
    }

    # By default, hide the RESP tabs on startup
    $w.hlf.nb hide $w.hlf.nb.calcESP
    $w.hlf.nb hide $w.hlf.nb.optESP
    set ::ForceFieldToolKit::gui::coptMethod "Water Interaction"


    #---------------------------------------------------#
    #  Bonded   tab                                     #
    #---------------------------------------------------#
    # build the frame, add it to the notebook
    ttk::frame $w.hlf.nb.genbonded -width 500 -height 500
    $w.hlf.nb add $w.hlf.nb.genbonded -text "Calc. Bonded"
    # allow frame to change width with window
    grid columnconfigure $w.hlf.nb.genbonded 0 -weight 1

    # for shorter naming convention
    set genbonded $w.hlf.nb.genbonded

    # add QM Selector
    ttk::menubutton $genbonded.qmselector -direction below -menu $w.menuQMSelector -textvariable ::ForceFieldToolKit::qmSoft -width 15

    # GENERATE HESSIAN
    # -----------------
    # build hess elements
    ttk::labelframe $genbonded.hess -labelanchor nw -text "Generate Hessian" -padding $labelFrameInternalPadding

    ttk::label $genbonded.hess.ioLbl -text "Input/Output Settings:" -anchor w
    ttk::label $genbonded.hess.psfLbl -text "PSF File:" -anchor center
    ttk::entry $genbonded.hess.psf -textvariable ::ForceFieldToolKit::Configuration::chargeOptPSF
    ttk::button $genbonded.hess.psfBrowse -text "Browse" \
        -command {
            set tempfile [tk_getOpenFile -title "Select a PSF File" -filetypes $::ForceFieldToolKit::gui::psfType]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::Configuration::chargeOptPSF $tempfile }
        }
    ttk::label $genbonded.hess.pdbLbl -text "PDB File:" -anchor center
    ttk::entry $genbonded.hess.pdb -textvariable ::ForceFieldToolKit::Configuration::geomOptPDB
    ttk::button $genbonded.hess.pdbBrowse -text "Browse" \
        -command {
            set tempfile [tk_getOpenFile -title "Select a PDB File" -filetypes $::ForceFieldToolKit::gui::pdbType]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::Configuration::geomOptPDB $tempfile }
        }
    ttk::label $genbonded.hess.geomCHKLbl -text "Opt. Geom. CHK/OUT File:" -anchor center
    ttk::entry $genbonded.hess.geomCHK -textvariable ::ForceFieldToolKit::GenBonded::geomCHK
    ttk::button $genbonded.hess.geomCHKBrowse -text "Browse" \
        -command {
            set tempfile [tk_getOpenFile -title "Select the Geometry Optimization Checkpoint/Output File" -filetypes $::ForceFieldToolKit::gui::AllChkType]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::GenBonded::geomCHK $tempfile }
        }
    ttk::label $genbonded.hess.comLbl -text "Output QM File:" -anchor center
    ttk::entry $genbonded.hess.com -textvariable ::ForceFieldToolKit::GenBonded::com
    ttk::button $genbonded.hess.comSaveAs -text "SaveAs" \
        -command {
            set tempfile [tk_getSaveFile -title "Save QM Input File As..." -initialfile "$::ForceFieldToolKit::GenBonded::com" -filetypes $::ForceFieldToolKit::gui::AllInpType -defaultextension {.gau}]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::GenBonded::com $tempfile }
        }

    ttk::separator $genbonded.hess.sep1 -orient horizontal

    ttk::frame $genbonded.hess.gaussian
    ttk::label $genbonded.hess.gaussian.lbl -text "QM Settings:"
    ttk::label $genbonded.hess.gaussian.qmProcLbl -text "Processors:" -anchor w
    ttk::entry $genbonded.hess.gaussian.qmProc -textvariable ::ForceFieldToolKit::Configuration::qmProc -width 2 -justify center
    ttk::label $genbonded.hess.gaussian.qmMemLbl -text "Memory (GB):" -anchor w
    ttk::entry $genbonded.hess.gaussian.qmMem -textvariable ::ForceFieldToolKit::Configuration::qmMem -width 2 -justify center
    ttk::label $genbonded.hess.gaussian.chargeLbl -text "Charge:" -anchor w
    ttk::entry $genbonded.hess.gaussian.charge    -textvariable ::ForceFieldToolKit::GenBonded::qmCharge -width 2 -justify center
    ttk::label $genbonded.hess.gaussian.multLbl   -text "Multiplicity:" -anchor w
    ttk::entry $genbonded.hess.gaussian.mult      -textvariable ::ForceFieldToolKit::GenBonded::qmMult -width 2 -justify center
    ttk::label $genbonded.hess.gaussian.qmRouteLbl -text "Route:" -anchor center
    ttk::entry $genbonded.hess.gaussian.qmRoute -textvariable ::ForceFieldToolKit::GenBonded::qmRoute

    ttk::button $genbonded.hess.gaussian.reset2defaults -text "Reset to Defaults" -command { ::ForceFieldToolKit::${::ForceFieldToolKit::qmSoft}::resetDefaultsGenBonded }

    ttk::separator $genbonded.hess.sep2 -orient horizontal

    ttk::button $genbonded.hess.writeHessCom -text "Write QM Input File" \
        -command {
            # For the moment, stop the procedure if ORCA was selected
#            if {$::ForceFieldToolKit::qmSoft eq "ORCA"} {
#              ::ForceFieldToolKit::ORCA::tempORCAmessage
#              return
#            }
            ::ForceFieldToolKit::GenBonded::writeComFile
            ::ForceFieldToolKit::gui::consoleMessage "QM file written for hessian calculation"
        }

    # grid hess elements
    grid $genbonded.qmselector -column 0 -row 0 -columnspan 5 -sticky sw

    grid $genbonded.hess       -column 0 -row 1 -sticky nswe -padx $labelFramePadX -pady $labelFramePadY
    grid columnconfigure $genbonded.hess 1 -weight 1
    grid rowconfigure $genbonded.hess {1 2 3 4} -uniform rt1
    grid rowconfigure $genbonded.hess 8 -minsize 50

    grid $genbonded.hess.ioLbl -column 0 -row 0 -columnspan 3 -sticky nswe
    grid $genbonded.hess.psfLbl -column 0 -row 1 -sticky nswe
    grid $genbonded.hess.psf -column 1 -row 1 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $genbonded.hess.psfBrowse -column 2 -row 1 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $genbonded.hess.pdbLbl -column 0 -row 2 -sticky nswe
    grid $genbonded.hess.pdb -column 1 -row 2 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $genbonded.hess.pdbBrowse -column 2 -row 2 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $genbonded.hess.geomCHKLbl -column 0 -row 3 -sticky nswe
    grid $genbonded.hess.geomCHK -column 1 -row 3 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $genbonded.hess.geomCHKBrowse -column 2 -row 3 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $genbonded.hess.comLbl -column 0 -row 4 -sticky nswe
    grid $genbonded.hess.com -column 1 -row 4 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $genbonded.hess.comSaveAs -column 2 -row 4 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY

    grid $genbonded.hess.sep1 -column 0 -row 5 -columnspan 3 -sticky nswe -padx $hsepPadX -pady $hsepPadY

    grid $genbonded.hess.gaussian -column 0 -row 6 -columnspan 3 -sticky nswe
    grid columnconfigure $genbonded.hess.gaussian 9 -weight 1

    grid $genbonded.hess.gaussian.lbl -column 0 -row 0 -columnspan 9 -sticky nswe
    grid $genbonded.hess.gaussian.qmProcLbl      -column 0 -row 1 -sticky w
    grid $genbonded.hess.gaussian.qmProc         -column 1 -row 1 -sticky w
    grid $genbonded.hess.gaussian.qmMemLbl       -column 2 -row 1 -sticky w
    grid $genbonded.hess.gaussian.qmMem          -column 3 -row 1 -sticky w
    grid $genbonded.hess.gaussian.chargeLbl      -column 4 -row 1 -sticky w
    grid $genbonded.hess.gaussian.charge         -column 5 -row 1 -sticky w
    grid $genbonded.hess.gaussian.multLbl        -column 6 -row 1 -sticky w
    grid $genbonded.hess.gaussian.mult           -column 7 -row 1 -sticky w
    grid $genbonded.hess.gaussian.reset2defaults -column 8 -row 1 -sticky nswe -padx $hbuttonPadX -pady $hbuttonPadY
    grid $genbonded.hess.gaussian.qmRouteLbl -column 0 -row 2 -sticky nswe
    grid $genbonded.hess.gaussian.qmRoute -column 1 -row 2 -columnspan 9 -sticky nswe

    grid $genbonded.hess.sep2 -column 0 -row 7 -columnspan 3 -sticky nswe -padx $hsepPadX -pady $hsepPadY
    grid $genbonded.hess.writeHessCom -column 0 -row 8 -columnspan 3 -sticky nswe -padx $buttonRunPadX -pady $buttonRunPadY

    # CALCULATE BONDED PARAMETERS
    # ---------------------------
    # build calc elements
    ttk::labelframe $genbonded.calcBonded -labelanchor nw -text "Extract Bonded Parameters From Hessian" -padding $labelFrameInternalPadding
    ttk::label $genbonded.calcBonded.psfLbl -text "PSF File:" -anchor center
    ttk::entry $genbonded.calcBonded.psf -textvariable ::ForceFieldToolKit::GenBonded::psf
    ttk::button $genbonded.calcBonded.psfBrowse -text "Browse" \
        -command {
            set tempfile [tk_getOpenFile -title "Select a PSF File" -filetypes $::ForceFieldToolKit::gui::psfType]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::GenBonded::psf $tempfile }
        }
    ttk::label $genbonded.calcBonded.pdbLbl -text "PDB File:" -anchor center
    ttk::entry $genbonded.calcBonded.pdb -textvariable ::ForceFieldToolKit::GenBonded::pdb
    ttk::button $genbonded.calcBonded.pdbBrowse -text "Browse" \
        -command {
            set tempfile [tk_getOpenFile -title "Select a PDB File" -filetypes $::ForceFieldToolKit::gui::pdbType]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::GenBonded::pdb $tempfile }
        }
    ttk::label $genbonded.calcBonded.tempParLbl -text "Template PAR File:" -anchor center
    ttk::entry $genbonded.calcBonded.tempPar -textvariable ::ForceFieldToolKit::GenBonded::templateParFile
    ttk::button $genbonded.calcBonded.tempParBrowse -text "Browse" \
        -command {
            set tempfile [tk_getOpenFile -title "Select a Template Parameter File" -filetypes $::ForceFieldToolKit::gui::parType]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::GenBonded::templateParFile $tempfile }
        }
    ttk::label $genbonded.calcBonded.glogLbl -text "QM Output File:" -anchor center
    ttk::entry $genbonded.calcBonded.glog -textvariable ::ForceFieldToolKit::GenBonded::glog
    ttk::button $genbonded.calcBonded.glogBrowse -text "Browse" \
        -command {
            set tempfile [tk_getOpenFile -title "Select Hessian Calculation Output File" -filetypes $::ForceFieldToolKit::gui::AllLogType]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::GenBonded::glog $tempfile }
        }
    ttk::label $genbonded.calcBonded.blogLbl -text "Output File:" -anchor center
    ttk::entry $genbonded.calcBonded.blog -textvariable ::ForceFieldToolKit::GenBonded::blog
    ttk::button $genbonded.calcBonded.blogSaveAs -text "SaveAs" \
        -command {
            set tempfile [tk_getSaveFile -title "Save Bonded Parameters As..." -initialfile "$::ForceFieldToolKit::GenBonded::blog" -filetypes $::ForceFieldToolKit::gui::logType -defaultextension {.log}]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::GenBonded::blog $tempfile }
        }

    ttk::separator $genbonded.calcBonded.sep1 -orient horizontal
    ttk::button $genbonded.calcBonded.calcBondedPars -text "Extract Bonded Parameters" -command { ::ForceFieldToolKit::GenBonded::extractBonded }

    # build calc elements
    grid $genbonded.calcBonded -column 0 -row 1 -sticky nswe -padx $labelFramePadX -pady $labelFramePadY
    grid columnconfigure $genbonded.calcBonded 1 -weight 1
    grid rowconfigure $genbonded.calcBonded {0 1 2 3} -uniform rt1
    grid rowconfigure $genbonded.calcBonded 6 -minsize 50

    grid $genbonded.calcBonded.psfLbl -column 0 -row 0 -sticky nswe
    grid $genbonded.calcBonded.psf -column 1 -row 0 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $genbonded.calcBonded.psfBrowse -column 2 -row 0 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $genbonded.calcBonded.pdbLbl -column 0 -row 1 -sticky nswe
    grid $genbonded.calcBonded.pdb -column 1 -row 1 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $genbonded.calcBonded.pdbBrowse -column 2 -row 1 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $genbonded.calcBonded.tempParLbl -column 0 -row 2 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $genbonded.calcBonded.tempPar -column 1 -row 2 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $genbonded.calcBonded.tempParBrowse -column 2 -row 2 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $genbonded.calcBonded.glogLbl -column 0 -row 3 -sticky nswe
    grid $genbonded.calcBonded.glog -column 1 -row 3 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $genbonded.calcBonded.glogBrowse -column 2 -row 3 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $genbonded.calcBonded.blogLbl -column 0 -row 4 -sticky nswe
    grid $genbonded.calcBonded.blog -column 1 -row 4 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $genbonded.calcBonded.blogSaveAs -column 2 -row 4 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY

    grid $genbonded.calcBonded.sep1 -column 0 -row 5 -columnspan 3 -sticky nswe -padx $hsepPadX -pady $hsepPadY
    grid $genbonded.calcBonded.calcBondedPars -column 0 -row 6 -columnspan 3 -sticky nswe -padx $buttonRunPadX -pady $buttonRunPadY



    # with the development of "let fftk guess" in the baopt routine, there is no longer a *good* reason
    # to extract parameters directly from the hessian.

    # based on the status of baopt leave parameter extraction or remove
    grid remove $genbonded.calcBonded

    #---------------------------------------------------#
    #  BondAngleOpt tab                                 #
    #---------------------------------------------------#
    # build the frame, add it to the notebook
    ttk::frame $w.hlf.nb.bondangleopt -width 500 -height 500
    $w.hlf.nb add $w.hlf.nb.bondangleopt -text "Opt. Bonded"
    # tab hidden until development is complete 09/19/2012
    # development is ~complete 10/23/2012 (CGM); reveal tab by default
    #$w.hlf.nb hide $w.hlf.nb.bondangleopt
    # allow frame to change width with content
    grid columnconfigure $w.hlf.nb.bondangleopt 0 -weight 1

    # for shorter naming convention
    set baopt $w.hlf.nb.bondangleopt


    # INPUT section
    # ---------------------#

    # build input frame
    ttk::labelframe $baopt.input -labelanchor nw -padding $labelFrameInternalPadding
    ttk::label $baopt.input.lblWidget -text "$downPoint Input" -anchor w -font TkDefaultFont
    $baopt.input configure -labelwidget $baopt.input.lblWidget

    # build placeholder
    ttk::label $baopt.inputPlaceHolder -text "$rightPoint Input" -anchor w -font TkDefaultFont

    # set mouse click bindings to expand/contract
    bind $baopt.input.lblWidget <Button-1> {
        grid remove .fftk_gui.hlf.nb.bondangleopt.input
        grid .fftk_gui.hlf.nb.bondangleopt.inputPlaceHolder
        grid rowconfigure .fftk_gui.hlf.nb.bondangleopt 0 -weight 0
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }
    bind $baopt.inputPlaceHolder <Button-1> {
        grid remove .fftk_gui.hlf.nb.bondangleopt.inputPlaceHolder
        grid .fftk_gui.hlf.nb.bondangleopt.input
        grid rowconfigure .fftk_gui.hlf.nb.bondangleopt 0 -weight 1
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }

    # build input elements
    # add QM Selector
    ttk::menubutton $baopt.input.qmselector -direction below -menu $w.menuQMSelector -textvariable ::ForceFieldToolKit::qmSoft -width 15

    ttk::label $baopt.input.psfPathLbl -anchor center -text "PSF File:"
    ttk::entry $baopt.input.psfPath -textvariable ::ForceFieldToolKit::Configuration::chargeOptPSF
    ttk::button $baopt.input.psfPathBrowse -text "Browse" \
        -command {
            set tempfile [tk_getOpenFile -title "Select a PSF File" -filetypes $::ForceFieldToolKit::gui::psfType]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::Configuration::chargeOptPSF $tempfile }
        }
    ttk::label $baopt.input.pdbPathLbl -anchor center -text "PDB File:"
    ttk::entry $baopt.input.pdbPath -textvariable ::ForceFieldToolKit::Configuration::geomOptPDB
    ttk::button $baopt.input.pdbPathBrowse -text "Browse" \
        -command {
            set tempfile [tk_getOpenFile -title "Select a PDB File" -filetypes $::ForceFieldToolKit::gui::pdbType]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::Configuration::geomOptPDB $tempfile }
        }
    ttk::label $baopt.input.hessPathLbl -anchor center -text "Hess Output File:"
    ttk::entry $baopt.input.hessPath -textvariable ::ForceFieldToolKit::BondAngleOpt::hessLog
    ttk::button $baopt.input.hessPathBrowse -text "Browse" \
        -command {
            set tempfile [tk_getOpenFile -title "Select the Hessian Output File" -filetypes $::ForceFieldToolKit::gui::AllLogType]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::BondAngleOpt::hessLog $tempfile }
        }

    ttk::separator $baopt.input.sep1 -orient horizontal

    ttk::label $baopt.input.parInProgLbl -text "In-Progress PAR File:" -anchor w
    ttk::entry $baopt.input.parInProg -textvariable ::ForceFieldToolKit::BondAngleOpt::parInProg
    ttk::button $baopt.input.parInProgBrowse -text "Browse" \
        -command {
            set tempfile [tk_getOpenFile -title "Select the In-Progress PAR File" -filetypes $::ForceFieldToolKit::gui::parType]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::BondAngleOpt::parInProg $tempfile }
        }

    ttk::label $baopt.input.parLbl -text "Additional Associated Parameter Files" -anchor w
    ttk::treeview $baopt.input.parFiles -selectmode browse -yscrollcommand "$baopt.input.parScroll set"
        $baopt.input.parFiles configure -columns {filename} -show {} -height 3
        $baopt.input.parFiles column filename -stretch 1
    ttk::scrollbar $baopt.input.parScroll -orient vertical -command "$baopt.input.parFiles yview"
    ttk::button $baopt.input.parFilesAdd -text "Add" \
        -command {
            set tempfiles [tk_getOpenFile -title "Select Parameter File(s)" -multiple 1 -filetypes $::ForceFieldToolKit::gui::parType]
            foreach tempfile $tempfiles {
                if {![string eq $tempfile ""]} { .fftk_gui.hlf.nb.bondangleopt.input.parFiles insert {} end -values [list $tempfile] }
            }
        }
    ttk::button $baopt.input.parFilesDelete -text "Delete" -command { .fftk_gui.hlf.nb.bondangleopt.input.parFiles delete [.fftk_gui.hlf.nb.bondangleopt.input.parFiles selection] }
    ttk::button $baopt.input.parFilesClear -text "Clear" -command { .fftk_gui.hlf.nb.bondangleopt.input.parFiles delete [.fftk_gui.hlf.nb.bondangleopt.input.parFiles children {}] }

    ttk::separator $baopt.input.sep2 -orient horizontal

    ttk::label $baopt.input.namdbinLbl -text "NAMD Bin:" -anchor center
    ttk::entry $baopt.input.namdbin -textvariable ::ForceFieldToolKit::Configuration::namdBin
    ttk::button $baopt.input.namdBrowse -text "Browse" \
        -command {
            set tempfile [tk_getOpenFile -title "Select a NAMD Bin File" -filetypes $::ForceFieldToolKit::gui::allType]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::Configuration::namdBin $tempfile }
        }
    ttk::label $baopt.input.logLbl -text "Output LOG:" -anchor center
    ttk::entry $baopt.input.log -textvariable ::ForceFieldToolKit::BondAngleOpt::outFileName
    ttk::button $baopt.input.logSaveAs -text "SaveAs" \
        -command {
            set tempfile [tk_getSaveFile -title "Save Bond/Angle Optimization Output LOG As..." -initialfile "$::ForceFieldToolKit::BondAngleOpt::outFileName" -filetypes $::ForceFieldToolKit::gui::logType -defaultextension {.log}]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::BondAngleOpt::outFileName $tempfile }
        }


    # grid the input frame
    grid $baopt.input -column 0 -row 0 -sticky nswe -padx $labelFramePadX -pady $labelFramePadY
    grid columnconfigure $baopt.input 1 -weight 1
    grid rowconfigure $baopt.input {0 1 2 6 7 8} -uniform rt1
    grid rowconfigure $baopt.input 9 -weight 1
    grid remove $baopt.input
    grid $baopt.inputPlaceHolder -column 0 -row 0 -sticky nswe -padx $placeHolderPadX -pady $placeHolderPadY

    # grid input elements
    grid $baopt.input.qmselector -column 0 -row 0 -columnspan 5 -sticky nsw

    grid $baopt.input.psfPathLbl -column 0 -row 1 -sticky nswe
    grid $baopt.input.psfPath -column 1 -row 1 -columnspan 2 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $baopt.input.psfPathBrowse -column 3 -row 1 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $baopt.input.pdbPathLbl -column 0 -row 2 -sticky nswe
    grid $baopt.input.pdbPath -column 1 -row 2 -columnspan 2 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $baopt.input.pdbPathBrowse -column 3 -row 2 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $baopt.input.hessPathLbl -column 0 -row 3 -sticky nswe
    grid $baopt.input.hessPath -column 1 -row 3 -columnspan 2 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $baopt.input.hessPathBrowse -column 3 -row 3 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $baopt.input.parInProgLbl -column 0 -row 4 -sticky nswe
    grid $baopt.input.parInProg -column 1 -row 4 -columnspan 2 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $baopt.input.parInProgBrowse -column 3 -row 4 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY

    grid $baopt.input.sep1 -column 0 -row 5 -columnspan 4 -sticky nswe -padx $hsepPadX -pady $hsepPadY


    grid $baopt.input.parLbl -column 0 -row 6 -columnspan 2 -sticky nswe
    grid $baopt.input.parFiles -column 0 -row 7 -columnspan 2 -rowspan 4 -sticky nswe
    grid $baopt.input.parScroll -column 2 -row 7 -rowspan 4 -sticky nswe
    grid $baopt.input.parFilesAdd -column 3 -row 7 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $baopt.input.parFilesDelete -column 3 -row 8 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $baopt.input.parFilesClear -column 3 -row 9 -sticky nwe -padx $vbuttonPadX -pady $vbuttonPadY

    grid $baopt.input.sep2 -column 0 -row 11 -columnspan 4 -sticky nswe -padx $hsepPadX -pady $hsepPadY

    grid $baopt.input.namdbinLbl -column 0 -row 12 -sticky nswe
    grid $baopt.input.namdbin -column 1 -row 12 -columnspan 2 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $baopt.input.namdBrowse -column 3 -row 12 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $baopt.input.logLbl -column 0 -row 13 -sticky nswe
    grid $baopt.input.log -column 1 -row 13 -columnspan 2 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $baopt.input.logSaveAs -column 3 -row 13 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY


    # PARAMETERS TO OPTIMIZE
    # ----------------------
    # build the pars frame
    ttk::labelframe $baopt.pconstr -labelanchor nw -padding $labelFrameInternalPadding -text "Parameters to Optimize"
    ttk::label $baopt.pconstr.lblWidget -text "$downPoint Parameters to Optimize" -anchor w -font TkDefaultFont
    $baopt.pconstr configure -labelwidget $baopt.pconstr.lblWidget
    # build the placeholder
    ttk::label $baopt.pconstrPlaceHolder -text "$rightPoint Parameters to Optimize" -anchor w -font TkDefaultFont
    # set mouse click bindings to expand/contract
    bind $baopt.pconstr.lblWidget <Button-1> {
        grid remove .fftk_gui.hlf.nb.bondangleopt.pconstr
        grid .fftk_gui.hlf.nb.bondangleopt.pconstrPlaceHolder
        grid rowconfigure .fftk_gui.hlf.nb.bondangleopt 1 -weight 0
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }
    bind $baopt.pconstrPlaceHolder <Button-1> {
        grid remove .fftk_gui.hlf.nb.bondangleopt.pconstrPlaceHolder
        grid .fftk_gui.hlf.nb.bondangleopt.pconstr
        grid rowconfigure .fftk_gui.hlf.nb.bondangleopt 1 -weight 1
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }

    # grid the pars frame
    grid $baopt.pconstr -column 0 -row 1 -sticky nswe -padx $labelFramePadX -pady $labelFramePadY
    grid columnconfigure $baopt.pconstr 0 -weight 0 -minsize 80
    grid columnconfigure $baopt.pconstr 1 -weight 1 -minsize 150
    grid columnconfigure $baopt.pconstr 2 -weight 0 -minsize 80
    grid columnconfigure $baopt.pconstr 3 -weight 0 -minsize 80
    grid rowconfigure $baopt.pconstr 5 -weight 1
    grid rowconfigure $baopt.pconstr {1 2 3 4} -uniform rt1
    grid remove $baopt.pconstr
    grid $baopt.pconstrPlaceHolder -column 0 -row 1 -sticky nswe -padx $placeHolderPadX -pady $placeHolderPadY


    # build pars to optimize elements
    ttk::label $baopt.pconstr.baLbl -text "Bond/Angle" -anchor center
    ttk::label $baopt.pconstr.defLbl -text "Atom Type Def." -anchor center
    ttk::label $baopt.pconstr.fcLbl -text "Force Constant" -anchor center
    ttk::label $baopt.pconstr.eqLbl -text "b${sub0}/${theta}" -anchor center
    ttk::treeview $baopt.pconstr.pars2opt -selectmode browse -yscrollcommand "$baopt.pconstr.scroll set"
        $baopt.pconstr.pars2opt configure -column {type def fc eq} -show {} -height 5
        $baopt.pconstr.pars2opt heading type -text "Bond/Angle" -anchor center
        $baopt.pconstr.pars2opt heading def -text "Atom Type Definition" -anchor center
        $baopt.pconstr.pars2opt heading fc -text "Force Const." -anchor center
        $baopt.pconstr.pars2opt heading eq -text "Eq pt." -anchor center
        $baopt.pconstr.pars2opt column type -width 80 -stretch 0 -anchor center
        $baopt.pconstr.pars2opt column def -width 150 -stretch 1 -anchor center
        $baopt.pconstr.pars2opt column fc -width 80 -stretch 0 -anchor center
        $baopt.pconstr.pars2opt column eq -width 80 -stretch 0 -anchor center
    ttk::scrollbar $baopt.pconstr.scroll -orient vertical -command "$baopt.pconstr.pars2opt yview"

    # set a binding to copy information into the Edit Box when the seletion changes
    bind $baopt.pconstr.pars2opt <<TreeviewSelect>> {
        set editData [.fftk_gui.hlf.nb.bondangleopt.pconstr.pars2opt item [.fftk_gui.hlf.nb.bondangleopt.pconstr.pars2opt selection] -values]
        set ::ForceFieldToolKit::gui::baoptEditBA [lindex $editData 0]
        set ::ForceFieldToolKit::gui::baoptEditDef [lindex $editData 1]
        set ::ForceFieldToolKit::gui::baoptEditFC [lindex $editData 2]
        set ::ForceFieldToolKit::gui::baoptEditEq [lindex $editData 3]
        unset editData
    }
    # set a binding to unselect entry when pressing escape button
    bind $baopt.pconstr.pars2opt <KeyPress-Escape> { .fftk_gui.hlf.nb.bondangleopt.pconstr.pars2opt selection set {} }

    ttk::button $baopt.pconstr.fftkGuessPars -text "Guess" -command { 
        ::ForceFieldToolKit::gui::baoptGuessPars 
    }
    ttk::button $baopt.pconstr.import -text "Import" \
        -command {
            if {[file readable $::ForceFieldToolKit::BondAngleOpt::parInProg]} {
                # read in the charmm parameter file
                set paramsIn [::ForceFieldToolKit::SharedFcns::readParFile $::ForceFieldToolKit::BondAngleOpt::parInProg]
                # parse out bond definitions, force constant, and eq position
                for {set i 0} {$i < [llength [lindex $paramsIn 0]]} {incr i} {
                    .fftk_gui.hlf.nb.bondangleopt.pconstr.pars2opt insert {} end -values [list "bond" [lindex $paramsIn 0 $i 0] [lindex $paramsIn 0 $i 1 0] [lindex $paramsIn 0 $i 1 1]]
                }
                # parse out angle definitions, force constant, and eq position
                for {set i 0} {$i < [llength [lindex $paramsIn 1]]} {incr i} {
                    .fftk_gui.hlf.nb.bondangleopt.pconstr.pars2opt insert {} end -values [list "angle" [lindex $paramsIn 1 $i 0] [lindex $paramsIn 1 $i 1 0] [lindex $paramsIn 1 $i 1 1]]
                }
                # clean up
                unset paramsIn
            } else {
                tk_messageBox -type ok -icon warning -message "Application halting due to error" -detail "Unable to read \"In-Progress PAR File\" from \"Input\" section."
                return
            }
        }

    ttk::button $baopt.pconstr.add -text "Add" -command { .fftk_gui.hlf.nb.bondangleopt.pconstr.pars2opt insert {} end -values [list "" "AT1 AT2 (AT3)" "FC" "Eq Value"] }
    ttk::button $baopt.pconstr.delete -text "Delete" \
        -command {
            .fftk_gui.hlf.nb.bondangleopt.pconstr.pars2opt delete [.fftk_gui.hlf.nb.bondangleopt.pconstr.pars2opt selection]
            set ::ForceFieldToolKit::gui::baoptEditBA {}
            set ::ForceFieldToolKit::gui::baoptEditDef {}
            set ::ForceFieldToolKit::gui::baoptEditFC {}
            set ::ForceFieldToolKit::gui::baoptEditEq {}
        }
    ttk::button $baopt.pconstr.clear -text "Clear" \
        -command {
            .fftk_gui.hlf.nb.bondangleopt.pconstr.pars2opt delete [.fftk_gui.hlf.nb.bondangleopt.pconstr.pars2opt children {}]
            set ::ForceFieldToolKit::gui::baoptEditBA {}
            set ::ForceFieldToolKit::gui::baoptEditDef {}
            set ::ForceFieldToolKit::gui::baoptEditFC {}
            set ::ForceFieldToolKit::gui::baoptEditEq {}
        }

    ttk::label $baopt.pconstr.edit -text "Edit Entry" -anchor w
    ttk::menubutton $baopt.pconstr.editBA -direction below -menu $baopt.pconstr.editBA.menu -textvariable ::ForceFieldToolKit::gui::baoptEditBA -width 4
    menu $baopt.pconstr.editBA.menu -tearoff no
        $baopt.pconstr.editBA.menu add command -label "" -command { set ::ForceFieldToolKit::gui::baoptEditBA "" }
        $baopt.pconstr.editBA.menu add command -label "bond" -command { set ::ForceFieldToolKit::gui::baoptEditBA "bond" }
        $baopt.pconstr.editBA.menu add command -label "angle" -command { set ::ForceFieldToolKit::gui::baoptEditBA "angle" }
    ttk::entry $baopt.pconstr.editDef -textvariable ::ForceFieldToolKit::gui::baoptEditDef -width 1 -justify center
    ttk::entry $baopt.pconstr.editFC -textvariable ::ForceFieldToolKit::gui::baoptEditFC -width 1 -justify center
    ttk::entry $baopt.pconstr.editEq -textvariable ::ForceFieldToolKit::gui::baoptEditEq -width 1 -justify center
    ttk::frame $baopt.pconstr.editButtons
    ttk::button $baopt.pconstr.editButtons.accept -text "$accept" -width 1 \
        -command {
            .fftk_gui.hlf.nb.bondangleopt.pconstr.pars2opt item [.fftk_gui.hlf.nb.bondangleopt.pconstr.pars2opt selection] \
            -values [list $::ForceFieldToolKit::gui::baoptEditBA $::ForceFieldToolKit::gui::baoptEditDef $::ForceFieldToolKit::gui::baoptEditFC $::ForceFieldToolKit::gui::baoptEditEq]
        }
    ttk::button $baopt.pconstr.editButtons.cancel -text "$cancel" -width 1 \
        -command {
            set editData [.fftk_gui.hlf.nb.bondangleopt.pconstr.pars2opt item [.fftk_gui.hlf.nb.bondangleopt.pconstr.pars2opt selection] -values]
            set ::ForceFieldToolKit::gui::baoptEditBA [lindex $editData 0]
            set ::ForceFieldToolKit::gui::baoptEditDef [lindex $editData 1]
            set ::ForceFieldToolKit::gui::baoptEditFC [lindex $editData 2]
            set ::ForceFieldToolKit::gui::baoptEditEq [lindex $editData 3]
            unset editData
        }


    # grid pars to optimize
    grid $baopt.pconstr.baLbl -column 0 -row 0 -sticky nswe
    grid $baopt.pconstr.defLbl -column 1 -row 0 -sticky nswe
    grid $baopt.pconstr.fcLbl -column 2 -row 0 -sticky nswe
    grid $baopt.pconstr.eqLbl -column 3 -row 0 -sticky nswe
    grid $baopt.pconstr.pars2opt -column 0 -row 1 -columnspan 4 -rowspan 5 -sticky nswe
    grid $baopt.pconstr.scroll -column 4 -row 1 -rowspan 5 -sticky nswe

    grid $baopt.pconstr.fftkGuessPars -column 5 -row 1 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $baopt.pconstr.import -column 5 -row 2 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $baopt.pconstr.add -column 5 -row 3 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $baopt.pconstr.delete -column 5 -row 4 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $baopt.pconstr.clear -column 5 -row 5 -sticky nwe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $baopt.pconstr.edit -column 0 -row 7 -sticky nswe
    grid $baopt.pconstr.editBA -column 0 -row 8 -sticky nswe
    grid $baopt.pconstr.editDef -column 1 -row 8 -sticky nswe
    grid $baopt.pconstr.editFC -column 2 -row 8 -sticky nswe
    grid $baopt.pconstr.editEq -column 3 -row 8 -sticky nswe
    grid $baopt.pconstr.editButtons -column 5 -row 8 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid columnconfigure $baopt.pconstr.editButtons {0 1} -weight 1
    grid $baopt.pconstr.editButtons.accept -column 0 -row 0 -sticky nswe
    grid $baopt.pconstr.editButtons.cancel -column 1 -row 0 -sticky nswe


    # ADVANCED SETTINGS
    # -----------------
    # build the labelframe
    ttk::labelframe $baopt.adv -labelanchor nw -padding $labelFrameInternalPadding
    ttk::label $baopt.adv.lblWidget -text "$downPoint Advanced Settings" -anchor w -font TkDefaultFont
    $baopt.adv configure -labelwidget $baopt.adv.lblWidget
    # build the placeholder
    ttk::label $baopt.advPlaceHolder -text "$rightPoint Advanced Settings" -anchor w -font TkDefaultFont
    # set mouse click bindings to expand/contract adv settings
    bind $baopt.adv.lblWidget <Button-1> {
        grid remove .fftk_gui.hlf.nb.bondangleopt.adv
        grid .fftk_gui.hlf.nb.bondangleopt.advPlaceHolder
        grid rowconfigure .fftk_gui.hlf.nb.bondangleopt 2 -weight 0
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }
    bind $baopt.advPlaceHolder <Button-1> {
        grid remove .fftk_gui.hlf.nb.bondangleopt.advPlaceHolder
        grid .fftk_gui.hlf.nb.bondangleopt.adv
        grid rowconfigure .fftk_gui.hlf.nb.bondangleopt 2 -weight 1
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }

    # optimization settings
    ttk::frame $baopt.adv.opt
    ttk::label $baopt.adv.opt.lbl -text "Optimize Settings" -anchor w
    ttk::label $baopt.adv.opt.tolLbl -text "Tolerance:"
    ttk::entry $baopt.adv.opt.tol -textvariable ::ForceFieldToolKit::BondAngleOpt::tol -justify center -width 6
    ttk::label $baopt.adv.opt.geomWeightLbl -text "Geom. Weight:" -anchor w
    ttk::entry $baopt.adv.opt.geomWeight -textvariable ::ForceFieldToolKit::BondAngleOpt::geomWeight -width 6 -justify center
    ttk::label $baopt.adv.opt.enWeightLbl -text "Energy Weight:" -anchor w
    ttk::entry $baopt.adv.opt.enWeight -textvariable ::ForceFieldToolKit::BondAngleOpt::enWeight -width 6 -justify center

    ttk::label $baopt.adv.opt.modeLbl -text "Mode:"
    ttk::menubutton $baopt.adv.opt.mode -direction below -menu $baopt.adv.opt.mode.menu -textvariable ::ForceFieldToolKit::BondAngleOpt::mode -width 16
    menu $baopt.adv.opt.mode.menu -tearoff no
    $baopt.adv.opt.mode.menu add command -label "downhill" \
        -command {
            set ::ForceFieldToolKit::BondAngleOpt::mode downhill
            grid remove .fftk_gui.hlf.nb.bondangleopt.adv.opt.saSettings
            grid .fftk_gui.hlf.nb.bondangleopt.adv.opt.dhSettings
        }
    $baopt.adv.opt.mode.menu add command -label "simulated annealing" \
        -command {
            set ::ForceFieldToolKit::BondAngleOpt::mode {simulated annealing}
            grid remove .fftk_gui.hlf.nb.bondangleopt.adv.opt.dhSettings
            grid .fftk_gui.hlf.nb.bondangleopt.adv.opt.saSettings
        }
    ttk::frame $baopt.adv.opt.dhSettings
    ttk::label $baopt.adv.opt.dhSettings.iterLbl -text "Iter:" -anchor w
    ttk::entry $baopt.adv.opt.dhSettings.iter -textvariable ::ForceFieldToolKit::BondAngleOpt::dhIter -width 8 -justify center
    ttk::frame $baopt.adv.opt.saSettings
    ttk::label $baopt.adv.opt.saSettings.tempLbl -text "T:" -anchor w
    ttk::entry $baopt.adv.opt.saSettings.temp -textvariable ::ForceFieldToolKit::BondAngleOpt::saT -width 8 -justify center
    ttk::label $baopt.adv.opt.saSettings.tStepsLbl -text "Tsteps:" -anchor w
    ttk::entry $baopt.adv.opt.saSettings.tSteps -textvariable ::ForceFieldToolKit::BondAngleOpt::saTSteps -width 8 -justify center
    ttk::label $baopt.adv.opt.saSettings.iterLbl -text "Iter:" -anchor w
    ttk::entry $baopt.adv.opt.saSettings.iter -textvariable ::ForceFieldToolKit::BondAngleOpt::saIter -width 8 -justify center

    ttk::separator $baopt.adv.sep1 -orient horizontal

    # parameter settings
    ttk::frame $baopt.adv.parSettings
    ttk::label $baopt.adv.parSettings.lbl -text "Adv. Parameter Settings" -anchor w
    ttk::label $baopt.adv.parSettings.bonds -text "Bonds --" -anchor w
    ttk::label $baopt.adv.parSettings.bondDevLbl -text "Eq. Deviation:" -anchor w
    ttk::entry $baopt.adv.parSettings.bondDev -textvariable ::ForceFieldToolKit::BondAngleOpt::bondDev -width 6 -justify center
    ttk::label $baopt.adv.parSettings.bondKlbLbl -text "K Lower Bound:" -anchor w
    ttk::entry $baopt.adv.parSettings.bondKlb -textvariable ::ForceFieldToolKit::BondAngleOpt::bondLB -width 6 -justify center
    ttk::label $baopt.adv.parSettings.bondKubLbl -text "K Upper Bound:" -anchor w
    ttk::entry $baopt.adv.parSettings.bondKub -textvariable ::ForceFieldToolKit::BondAngleOpt::bondUB -width 6 -justify center
    ttk::label $baopt.adv.parSettings.angles -text "Angles --" -anchor w
    ttk::label $baopt.adv.parSettings.angleDevLbl -text "Eq. Deviation:" -anchor w
    ttk::entry $baopt.adv.parSettings.angleDev -textvariable ::ForceFieldToolKit::BondAngleOpt::angDev -width 6 -justify center
    ttk::label $baopt.adv.parSettings.angleKlbLbl -text "K Lower Bound:" -anchor w
    ttk::entry $baopt.adv.parSettings.angleKlb -textvariable ::ForceFieldToolKit::BondAngleOpt::angLB -width 6 -justify center
    ttk::label $baopt.adv.parSettings.angleKubLbl -text "K Upper Bound:" -anchor w
    ttk::entry $baopt.adv.parSettings.angleKub -textvariable ::ForceFieldToolKit::BondAngleOpt::angUB -width 6 -justify center



    ttk::separator $baopt.adv.sep2 -orient horizontal

    # run settings
    ttk::frame $baopt.adv.run
    ttk::label $baopt.adv.run.lbl -text "Run Settings" -anchor w
    ttk::checkbutton $baopt.adv.run.debugButton -offvalue 0 -onvalue 1 -variable ::ForceFieldToolKit::BondAngleOpt::debug
    ttk::label $baopt.adv.run.debugLbl -text "Write debugging log"
    ttk::checkbutton $baopt.adv.run.buildScriptButton -offvalue 0 -onvalue 1 -variable ::ForceFieldToolKit::gui::baoptBuildScript
    ttk::label $baopt.adv.run.buildScriptLbl -text "Build run script"


    # grid advanced settings
    grid $baopt.adv -column 0 -row 2 -sticky nswe -padx $labelFramePadX -pady $labelFramePadY
    grid columnconfigure $baopt.adv 0 -weight 1
    grid remove $baopt.adv
    grid $baopt.advPlaceHolder -column 0 -row 2 -sticky nswe -padx $placeHolderPadX -pady $placeHolderPadY

    grid $baopt.adv.opt -column 0 -row 0 -sticky nswe
    grid $baopt.adv.opt.lbl -column 0 -row 0 -columnspan 2 -sticky nswe
    grid $baopt.adv.opt.tolLbl -column 0 -row 0 -sticky nswe
    grid $baopt.adv.opt.tol -column 1 -row 0 -sticky nswe
    grid $baopt.adv.opt.geomWeightLbl -column 2 -row 0 -sticky nswe
    grid $baopt.adv.opt.geomWeight -column 3 -row 0 -sticky nswe
    grid $baopt.adv.opt.enWeightLbl -column 4 -row 0 -sticky nswe
    grid $baopt.adv.opt.enWeight -column 5 -row 0 -sticky nswe

    grid $baopt.adv.opt.modeLbl -column 0 -row 2 -sticky nswe
    grid $baopt.adv.opt.mode -column 1 -row 2 -sticky nswe -columnspan 3
    grid $baopt.adv.opt.dhSettings -column 4 -row 2 -sticky we -columnspan 3
    grid $baopt.adv.opt.dhSettings.iterLbl -column 0 -row 0 -sticky nswe -padx "5 0"
    grid $baopt.adv.opt.dhSettings.iter -column 1 -row 0 -sticky nswe
    grid $baopt.adv.opt.saSettings -column 4 -row 2 -sticky we -columnspan 3
    grid $baopt.adv.opt.saSettings.tempLbl -column 0 -row 0 -sticky nswe -padx "5 0"
    grid $baopt.adv.opt.saSettings.temp -column 1 -row 0 -sticky nswe
    grid $baopt.adv.opt.saSettings.tStepsLbl -column 2 -row 0 -sticky nswe
    grid $baopt.adv.opt.saSettings.tSteps -column 3 -row 0 -sticky nswe
    grid $baopt.adv.opt.saSettings.iterLbl -column 4 -row 0 -sticky nswe
    grid $baopt.adv.opt.saSettings.iter -column 5 -row 0 -sticky nswe
    grid remove $baopt.adv.opt.saSettings

    grid columnconfigure $baopt.adv.opt 6 -weight 1

    grid $baopt.adv.sep1 -column 0 -row 1 -sticky we -padx $hsepPadX -pady $hsepPadY

    grid $baopt.adv.parSettings -column 0 -row 2 -sticky nswe
    grid $baopt.adv.parSettings.lbl -column 0 -row 0 -sticky nswe -columnspan 4
    grid $baopt.adv.parSettings.bonds -column 0 -row 1 -sticky nswe
    grid $baopt.adv.parSettings.bondDevLbl -column 1 -row 1 -sticky nswe
    grid $baopt.adv.parSettings.bondDev -column 2 -row 1 -sticky nswe
    grid $baopt.adv.parSettings.bondKlbLbl -column 3 -row 1 -sticky nswe
    grid $baopt.adv.parSettings.bondKlb -column 4 -row 1 -sticky nswe
    grid $baopt.adv.parSettings.bondKubLbl -column 5 -row 1 -sticky nswe
    grid $baopt.adv.parSettings.bondKub -column 6 -row 1 -sticky nswe
    grid $baopt.adv.parSettings.angles -column 0 -row 2 -sticky nswe
    grid $baopt.adv.parSettings.angleDevLbl -column 1 -row 2 -sticky nswe
    grid $baopt.adv.parSettings.angleDev -column 2 -row 2 -sticky nswe
    grid $baopt.adv.parSettings.angleKlbLbl -column 3 -row 2 -sticky nswe
    grid $baopt.adv.parSettings.angleKlb -column 4 -row 2 -sticky nswe
    grid $baopt.adv.parSettings.angleKubLbl -column 5 -row 2 -sticky nswe
    grid $baopt.adv.parSettings.angleKub -column 6 -row 2 -sticky nswe

    grid $baopt.adv.sep2 -column 0 -row 3 -sticky nswe -padx $hsepPadX -pady $hsepPadY

    grid $baopt.adv.run -column 0 -row 4 -sticky nswe
    grid $baopt.adv.run.lbl -column 0 -row 0 -sticky nsw -columnspan 2
    grid $baopt.adv.run.debugButton -column 0 -row 1 -sticky nswe
    grid $baopt.adv.run.debugLbl -column 1 -row 1 -sticky nswe
    grid $baopt.adv.run.buildScriptButton -column 2 -row 1 -sticky nswe -padx "10 0"
    grid $baopt.adv.run.buildScriptLbl -column 3 -row 1 -sticky nswe


    # RESULTS
    # -----------------
    # build the labelframe
    ttk::labelframe $baopt.results -labelanchor nw -padding $labelFrameInternalPadding
    ttk::label $baopt.results.lblWidget -text "$downPoint Results" -anchor w -font TkDefaultFont
    $baopt.results configure -labelwidget $baopt.results.lblWidget
    # build the placeholder
    ttk::label $baopt.resultsPlaceHolder -text "$rightPoint Results" -anchor w -font TkDefaultFont
    # set mouse click bindings to expand/contract results settings
    bind $baopt.results.lblWidget <Button-1> {
        grid remove .fftk_gui.hlf.nb.bondangleopt.results
        grid .fftk_gui.hlf.nb.bondangleopt.resultsPlaceHolder
        grid rowconfigure .fftk_gui.hlf.nb.bondangleopt 3 -weight 0
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }
    bind $baopt.resultsPlaceHolder <Button-1> {
        grid remove .fftk_gui.hlf.nb.bondangleopt.resultsPlaceHolder
        grid .fftk_gui.hlf.nb.bondangleopt.results
        grid rowconfigure .fftk_gui.hlf.nb.bondangleopt 3 -weight 1
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }

    # grid the results frame
    grid $baopt.results -column 0 -row 3 -sticky nswe -padx $labelFramePadX -pady $labelFramePadY
    grid columnconfigure $baopt.results 0 -weight 0 -minsize 80
    grid columnconfigure $baopt.results 1 -weight 1 -minsize 150
    grid columnconfigure $baopt.results 2 -weight 0 -minsize 80
    grid columnconfigure $baopt.results 3 -weight 0 -minsize 80
    grid rowconfigure $baopt.results 4 -weight 1
    grid rowconfigure $baopt.results {1 2 3 5} -uniform rt1
    grid remove $baopt.results
    grid $baopt.resultsPlaceHolder -column 0 -row 3 -sticky nswe -padx $placeHolderPadX -pady $placeHolderPadY

    # build the results components
    ttk::label $baopt.results.baLbl -text "Bond/Angle" -anchor center
    ttk::label $baopt.results.defLbl -text "Atom Type Def." -anchor center
    ttk::label $baopt.results.fcLbl -text "Force Constant" -anchor center
    ttk::label $baopt.results.eqLbl -text "b${sub0}/${theta}" -anchor center
    ttk::treeview $baopt.results.pars2opt -selectmode none -yscrollcommand "$baopt.results.scroll set"
        $baopt.results.pars2opt configure -column {type def fc eq} -show {} -height 5
        $baopt.results.pars2opt heading type -text "Bond/Angle" -anchor center
        $baopt.results.pars2opt heading def -text "Atom Type Definition" -anchor center
        $baopt.results.pars2opt heading fc -text "Force Const." -anchor center
        $baopt.results.pars2opt heading eq -text "Eq pt." -anchor center
        $baopt.results.pars2opt column type -width 80 -stretch 0 -anchor center
        $baopt.results.pars2opt column def -width 150 -stretch 1 -anchor center
        $baopt.results.pars2opt column fc -width 80 -stretch 0 -anchor center
        $baopt.results.pars2opt column eq -width 80 -stretch 0 -anchor center
    ttk::scrollbar $baopt.results.scroll -orient vertical -command "$baopt.results.pars2opt yview"

    ttk::button $baopt.results.clear -text "Clear" -command { .fftk_gui.hlf.nb.bondangleopt.results.pars2opt delete [.fftk_gui.hlf.nb.bondangleopt.results.pars2opt children {}] }
    ttk::button $baopt.results.setAsInit -text "Set As Initial" \
        -command {
            # build a search index for initial pars
            set searchIndex {}
            foreach ele [.fftk_gui.hlf.nb.bondangleopt.pconstr.pars2opt children {}] {
                lappend searchIndex [list [.fftk_gui.hlf.nb.bondangleopt.pconstr.pars2opt set $ele def] $ele]
            }
            # update the initial parameters based on results
            foreach ele [.fftk_gui.hlf.nb.bondangleopt.results.pars2opt children {}] {
                # grab the relevant results data
                lassign [lrange [.fftk_gui.hlf.nb.bondangleopt.results.pars2opt item $ele -values] 1 3] resultTypedef resultFC resultEQ
                # find the matching typedef from the search index
                set listInd [lsearch -index 0 $searchIndex $resultTypedef]
                # if -1 then try the reversed type def
                if { $listInd == -1 } { set listInd [lsearch -index 0 $searchIndex [lreverse $resultTypedef]] }
                # if still -1, its an error
                if { $listInd == -1 } {
                    continue
                } else {
                    # update the input parameter values
                    .fftk_gui.hlf.nb.bondangleopt.pconstr.pars2opt set [lindex $searchIndex $listInd 1] fc $resultFC
                    .fftk_gui.hlf.nb.bondangleopt.pconstr.pars2opt set [lindex $searchIndex $listInd 1] eq $resultEQ
                }
            }
        }
    ttk::button $baopt.results.loadLog -text "Load LOG" \
        -command {
            set tempfile [tk_getOpenFile -title "Select the Bonds/Angles Optimization LOG File" -filetypes $::ForceFieldToolKit::gui::logType]
            if {![string eq $tempfile ""]} { set inFile [open $tempfile r] } else { return }

            set readstate 0
            while { ![eof $inFile] } {
                set inLine [string trim [gets $inFile]]
                switch -exact $inLine {
                    {FINAL PARAMETERS} { set readstate 1 }
                    {END}              { set readstate 0 }
                    default {
                        if { $readstate } {
                            .fftk_gui.hlf.nb.bondangleopt.results.pars2opt insert {} end -values $inLine
                        } else {
                            continue
                        }
                    }
                }; # end switch
            }; # end while
            close $inFile; unset tempfile; unset readstate
        }

    #
    ttk::frame $baopt.results.obj
    ttk::label $baopt.results.obj.currLbl -text "Current Final Obj. Value:" -anchor w
    ttk::label $baopt.results.obj.curr -textvariable ::ForceFieldToolKit::gui::baoptReturnObjCurrent -anchor center
    ttk::label $baopt.results.obj.prevLbl -text "Previous Final Obj. Value:" -anchor w
    ttk::label $baopt.results.obj.prev -textvariable ::ForceFieldToolKit::gui::baoptReturnObjPrevious -anchor center

    # grid the results components
    grid $baopt.results.baLbl -column 0 -row 0 -sticky nswe
    grid $baopt.results.defLbl -column 1 -row 0 -sticky nswe
    grid $baopt.results.fcLbl -column 2 -row 0 -sticky nswe
    grid $baopt.results.eqLbl -column 3 -row 0 -sticky nswe
    grid $baopt.results.pars2opt -column 0 -row 1 -columnspan 4 -rowspan 4 -sticky nswe
    grid $baopt.results.scroll -column 4 -row 1 -rowspan 4 -sticky nswe

    grid $baopt.results.clear -column 5 -row 1 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $baopt.results.setAsInit -column 5 -row 2 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $baopt.results.loadLog -column 5 -row 3 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY

    grid $baopt.results.obj -column 0 -row 5 -columnspan 4 -sticky nswe
    grid $baopt.results.obj.currLbl -column 0 -row 0 -sticky nswe
    grid $baopt.results.obj.curr -column 1 -row 0 -sticky nswe
    grid $baopt.results.obj.prevLbl -column 2 -row 0 -sticky nswe
    grid $baopt.results.obj.prev -column 3 -row 0 -sticky nswe

    grid columnconfigure $baopt.results.obj {0 2} -weight 0 -minsize 100
    grid columnconfigure $baopt.results.obj {1 3} -weight 0 -minsize 75

    # separator
    ttk::separator $baopt.sep4 -orient horizontal
    grid $baopt.sep4 -column 0 -row 5 -sticky we -padx $hsepPadX -pady $hsepPadY

    # RUN
    # ---
    # build run
    ttk::frame $baopt.status
    ttk::label $baopt.status.lbl -text "Status:"
    ttk::label $baopt.status.txt -textvariable ::ForceFieldToolKit::gui::baoptStatus

    ttk::button $baopt.runOpt -text "Run Optimization" -command {
            # For the moment, stop the procedure if ORCA was selected
#            if {$::ForceFieldToolKit::qmSoft eq "ORCA"} {
#              ::ForceFieldToolKit::ORCA::tempORCAmessage
#              return
#            }
            ::ForceFieldToolKit::gui::baoptRunOpt
            }

    # grid run
    grid $baopt.status -column 0 -row 6 -sticky nswe -padx $buttonRunPadX -pady $buttonRunPadY
    grid $baopt.status.lbl -column 0 -row 0 -sticky nswe
    grid $baopt.status.txt -column 1 -row 0 -sticky nswe

    grid $baopt.runOpt -column 0 -row 7 -sticky nswe -padx $buttonRunPadX -pady $buttonRunPadY
    grid rowconfigure $baopt 7 -minsize 50


    # --------------------------------------------------#
    # Dih/Impr Optimization Selector             #
    # --------------------------------------------------#
    # create an entry for the dih/impr optimization selector (menubutton)
    # that will be reused across several tabs

    menu $w.dihImprSelectorMenu -tearoff no
    $w.dihImprSelectorMenu add command -label "Dihedral fitting" -command { ::ForceFieldToolKit::gui::dihImprSelectMethod "dih" }
    $w.dihImprSelectorMenu add command -label "Improper fitting" -command { ::ForceFieldToolKit::gui::dihImprSelectMethod "impr" }


    #---------------------------------------------------#
    #  GenDihScan tab                                   #
    #---------------------------------------------------#

    # Add the dih method selector in before the pre-existing contents

    # build the frame, add it to the notebook
    ttk::frame $w.hlf.nb.genDihScan
    $w.hlf.nb add $w.hlf.nb.genDihScan -text "Scan Torsions"
    # allow frame to change width with content
    grid columnconfigure $w.hlf.nb.genDihScan 0 -weight 1
    # allow certain frames to gracefully change height
    grid rowconfigure $w.hlf.nb.genDihScan {2} -weight 1

    # for shorter naming convention
    set gds $w.hlf.nb.genDihScan


    # Dih/Impr Optimization Selector
    # -----------------------------------
    ttk::frame      $gds.dihImprSelector
    ttk::label      $gds.dihImprSelector.lbl      -text "Dihedrals/Impropers: " -anchor w -font TkDefaultFont
    ttk::menubutton $gds.dihImprSelector.selector -direction below -menu $w.dihImprSelectorMenu -textvariable ::ForceFieldToolKit::gui::dihImprMethod -width 15
##    ttk::separator  $gds.dihImprSelectorSep -orient horizontal

    grid $gds.dihImprSelector    -column 0 -row 0 -sticky nswe -padx $hsepPadX -pady $labelFramePadY
    grid $gds.dihImprSelector.lbl      -column 0 -row 0 -sticky nwe
    grid $gds.dihImprSelector.selector -column 1 -row 0 -sticky nsw
##    grid $gds.dihImprSelectorSep -column 0 -row 1 -sticky nwe -padx $hsepPadX -pady $hsepPadY

    grid columnconfigure $gds.dihImprSelector 1 -minsize 15 -weight 1


    # INPUT/OUTPUT
    # ------------
    # build input/output
    ttk::labelframe $gds.io -labelanchor nw -padding $labelFrameInternalPadding -text "Input/Output"
    ttk::label $gds.io.psfLbl -text "PSF File:" -anchor center
    ttk::entry $gds.io.psf -textvariable ::ForceFieldToolKit::Configuration::chargeOptPSF
    ttk::button $gds.io.psfBrowse -text "Browse" \
        -command {
            set tempfile [tk_getOpenFile -title "Select a PSF File" -filetypes $::ForceFieldToolKit::gui::psfType]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::Configuration::chargeOptPSF $tempfile }
        }
    ttk::label $gds.io.pdbLbl -text "PDB File:" -anchor center
    ttk::entry $gds.io.pdb -textvariable ::ForceFieldToolKit::Configuration::geomOptPDB
    ttk::button $gds.io.pdbBrowse -text "Browse" \
        -command {
            set tempfile [tk_getOpenFile -title "Select a PDB File" -filetypes $::ForceFieldToolKit::gui::pdbType]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::Configuration::geomOptPDB $tempfile }
        }
    ttk::label $gds.io.outPathLbl -text "Output Path:" -anchor center
    ttk::entry $gds.io.outPath -textvariable ::ForceFieldToolKit::GenDihScan::outPath
    ttk::button $gds.io.outPathBrowse -text "Browse" \
        -command {
            set tempfile [tk_chooseDirectory -title "Select the Output Folder"]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::GenDihScan::outPath $tempfile }
        }
    ttk::label $gds.io.basenameLbl -text "Basename:" -anchor center
    ttk::frame $gds.io.bNameSub
    ttk::entry $gds.io.bNameSub.basename -textvariable ::ForceFieldToolKit::GenDihScan::basename -width 10 -justify center
    ttk::button $gds.io.bNameSub.takeFromTop -text "Basename from TOP" \
        -command {
            if { [llength [molinfo list]] == 0 } {
                tk_messageBox -type ok -icon warning -message "Action halted on error!" -detail "No PSF/PDBs loaded in VMD."
                return
            }
            set ::ForceFieldToolKit::GenDihScan::basename [lindex [[atomselect top all] get resname] 0]
        }

    ttk::separator $gds.io.sep1 -orient vertical
    ttk::button $gds.io.loadMolec -text "Load PSF/PDB" \
        -command {
            if { $::ForceFieldToolKit::Configuration::chargeOptPSF eq "" || ![file exists $::ForceFieldToolKit::Configuration::chargeOptPSF] } { tk_messageBox -type ok -icon warning -message "Action halted on error!" -detail "Cannot open PSF file."; return }
            if { $::ForceFieldToolKit::Configuration::geomOptPDB eq "" || ![file exists $::ForceFieldToolKit::Configuration::geomOptPDB] } { tk_messageBox -type ok -icon warning -message "Action halted on error!" -detail "Cannot open PDB file."; return }
            mol new $::ForceFieldToolKit::Configuration::chargeOptPSF
            mol addfile $::ForceFieldToolKit::Configuration::geomOptPDB
            ::ForceFieldToolKit::gui::consoleMessage "PSF/PDB files loaded (Scan Torsions)"
        }
    ttk::button $gds.io.toggleAtomLabels -text "Toggle Atom Labels" -command { ::ForceFieldToolKit::gui::gdsToggleLabels }


    # grid input/output
    grid $gds.io -column 0 -row 1 -sticky nwe -padx $labelFramePadX -pady $labelFramePadY
    grid columnconfigure $gds.io 1 -weight 1
    grid rowconfigure $gds.io {0 1 2 3} -uniform rt1

#    grid $gds.io -column 0 -row 0 -sticky nswe
#    grid columnconfigure $gds.io 1 -weight 1
#    grid rowconfigure $gds.io {0 1 2 3} -uniform rt1

    grid $gds.io.psfLbl -column 0 -row 0 -sticky nswe
    grid $gds.io.psf -column 1 -row 0 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $gds.io.psfBrowse -column 2 -row 0 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $gds.io.pdbLbl -column 0 -row 1 -sticky nswe
    grid $gds.io.pdb -column 1 -row 1 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $gds.io.pdbBrowse -column 2 -row 1 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $gds.io.outPathLbl -column 0 -row 2 -sticky nswe
    grid $gds.io.outPath -column 1 -row 2 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $gds.io.outPathBrowse -column 2 -row 2 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $gds.io.basenameLbl -column 0 -row 3 -sticky nswe

    grid $gds.io.bNameSub -column 1 -row 3 -sticky nswe
    grid columnconfigure $gds.io.bNameSub 0 -weight 1
    grid $gds.io.bNameSub.basename -column 0 -row 0 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $gds.io.bNameSub.takeFromTop -column 1 -row 0 -sticky nswe -padx $hbuttonPadX -pady $hbuttonPadY

    grid $gds.io.sep1 -column 3 -row 0 -rowspan 4 -sticky nswe -padx $vsepPadX -pady $vsepPadY
    grid $gds.io.loadMolec -column 4 -row 0 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $gds.io.toggleAtomLabels -column 4 -row 1 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY


    # build/grid a separator
    ttk::separator $gds.sep1 -orient horizontal
    grid $gds.sep1 -column 0 -row 2 -sticky nswe -padx $hsepPadX -pady $hsepPadY

    # DIHEDRALS TO SCAN
    # -----------------
    # build dihedrals to scan
    ttk::labelframe $gds.dihs2scan -text "Dihdedrals to Scan" -labelanchor nw -padding $labelFrameInternalPadding
    ttk::label $gds.dihs2scan.dihLbl -text "Dihedral Atoms" -anchor center
    ttk::label $gds.dihs2scan.plusMinusLbl -text "Scan +/- (${degree})" -anchor center
    ttk::label $gds.dihs2scan.stepSizeLbl -text "Step Size (${degree})" -anchor center
    ttk::treeview $gds.dihs2scan.tv -selectmode browse -yscrollcommand "$gds.dihs2scan.scroll set"
        $gds.dihs2scan.tv configure -columns {indDef plusMinus stepSize} -show {} -height 4
        $gds.dihs2scan.tv heading indDef -text "Dihedral Atoms"
        $gds.dihs2scan.tv heading plusMinus -text "+/-"
        $gds.dihs2scan.tv heading stepSize -text "Step Size"
        $gds.dihs2scan.tv column indDef -width 150 -stretch 1 -anchor center
        $gds.dihs2scan.tv column plusMinus -width 100 -stretch 1 -anchor center
        $gds.dihs2scan.tv column stepSize -width 100 -stretch 1 -anchor center
    ttk::scrollbar $gds.dihs2scan.scroll -orient vertical -command "$gds.dihs2scan.tv yview"

    # setup the binding to copy the selected TV item data to the edit boxes
    # also show a representation of the selected tv item
    bind $gds.dihs2scan.tv <<TreeviewSelect>> {
        set editData [.fftk_gui.hlf.nb.genDihScan.dihs2scan.tv item [.fftk_gui.hlf.nb.genDihScan.dihs2scan.tv selection] -values]
        set ::ForceFieldToolKit::gui::gdsEditIndDef [lindex $editData 0]
        set ::ForceFieldToolKit::gui::gdsEditPlusMinus [lindex $editData 1]
        set ::ForceFieldToolKit::gui::gdsEditStepSize [lindex $editData 2]

        ::ForceFieldToolKit::gui::gdsShowSelRep
    }

    ttk::button $gds.dihs2scan.add -text "Add" -command { .fftk_gui.hlf.nb.genDihScan.dihs2scan.tv insert {} end -values {{ind1 ind2 ind3 ind4} value value} }
    ttk::button $gds.dihs2scan.import -text "Read from PAR" \
        -command {
            set tempfile [tk_getOpenFile -title "Select A Parameter File" -filetypes $::ForceFieldToolKit::gui::parType]
            if {![string eq $tempfile ""]} {
                set importData [::ForceFieldToolKit::gui::gdsImportDihedrals $::ForceFieldToolKit::Configuration::chargeOptPSF $::ForceFieldToolKit::Configuration::geomOptPDB $tempfile]
                foreach ele $importData {
                    .fftk_gui.hlf.nb.genDihScan.dihs2scan.tv insert {} end -values [list $ele 90 15]
                }
            }
        }
    ttk::frame $gds.dihs2scan.move
    ttk::button $gds.dihs2scan.move.up -text "$upArrow" -width 1 \
        -command {
            # ID of current
            set currentID [.fftk_gui.hlf.nb.genDihScan.dihs2scan.tv selection]
            # ID of previous
            if {[set previousID [.fftk_gui.hlf.nb.genDihScan.dihs2scan.tv prev $currentID ]] ne ""} {
                # Index of previous
                set previousIndex [.fftk_gui.hlf.nb.genDihScan.dihs2scan.tv index $previousID]
                # Move ahead of previous
                .fftk_gui.hlf.nb.genDihScan.dihs2scan.tv move $currentID {} $previousIndex
                unset previousIndex
            }
            unset currentID previousID
        }
    ttk::button $gds.dihs2scan.move.down -text "$downArrow" -width 1 \
        -command {
            # ID of current
            set currentID [.fftk_gui.hlf.nb.genDihScan.dihs2scan.tv selection]
            # ID of Next
            if {[set previousID [.fftk_gui.hlf.nb.genDihScan.dihs2scan.tv next $currentID ]] ne ""} {
                # Index of Next
                set previousIndex [.fftk_gui.hlf.nb.genDihScan.dihs2scan.tv index $previousID]
                # Move below next
                .fftk_gui.hlf.nb.genDihScan.dihs2scan.tv move $currentID {} $previousIndex
                unset previousIndex
            }
            unset currentID previousID
        }
    ttk::separator $gds.dihs2scan.sep1 -orient horizontal
    ttk::button $gds.dihs2scan.delete -text "Delete" \
        -command {
            .fftk_gui.hlf.nb.genDihScan.dihs2scan.tv delete [.fftk_gui.hlf.nb.genDihScan.dihs2scan.tv selection]
            set ::ForceFieldToolKit::gui::gdsEditIndDef {}
            set ::ForceFieldToolKit::gui::gdsEditPlusMinus {}
            set ::ForceFieldToolKit::gui::gdsEditStepSize {}
        }
    ttk::button $gds.dihs2scan.clear -text "Clear" \
        -command {
            .fftk_gui.hlf.nb.genDihScan.dihs2scan.tv delete [.fftk_gui.hlf.nb.genDihScan.dihs2scan.tv children {}]
            set ::ForceFieldToolKit::gui::gdsEditIndDef {}
            set ::ForceFieldToolKit::gui::gdsEditPlusMinus {}
            set ::ForceFieldToolKit::gui::gdsEditStepSize {}
        }
    ttk::label $gds.dihs2scan.editLbl -text "Edit Entry" -anchor w
    ttk::entry $gds.dihs2scan.editIndDef -textvariable ::ForceFieldToolKit::gui::gdsEditIndDef -width 1 -justify center
    ttk::entry $gds.dihs2scan.editPlusMinus -textvariable ::ForceFieldToolKit::gui::gdsEditPlusMinus -width 1 -justify center
    ttk::entry $gds.dihs2scan.editStepSize -textvariable ::ForceFieldToolKit::gui::gdsEditStepSize -width 1 -justify center
    ttk::frame $gds.dihs2scan.editAcceptCancel
    ttk::button $gds.dihs2scan.editAcceptCancel.accept -text "$accept" -width 1 \
        -command {
            .fftk_gui.hlf.nb.genDihScan.dihs2scan.tv item [.fftk_gui.hlf.nb.genDihScan.dihs2scan.tv selection] \
            -values [list $::ForceFieldToolKit::gui::gdsEditIndDef $::ForceFieldToolKit::gui::gdsEditPlusMinus $::ForceFieldToolKit::gui::gdsEditStepSize]
        }
    ttk::button $gds.dihs2scan.editAcceptCancel.cancel -text "$cancel" -width 1 \
        -command {
        set editData [.fftk_gui.hlf.nb.genDihScan.dihs2scan.tv item [.fftk_gui.hlf.nb.genDihScan.dihs2scan.tv selection] -values]
        set ::ForceFieldToolKit::gui::gdsEditIndDef [lindex $editData 0]
        set ::ForceFieldToolKit::gui::gdsEditPlusMinus [lindex $editData 2]
        set ::ForceFieldToolKit::gui::gdsEditStepSize [lindex $editData 3]
        }

    # grid dihedrals to scan
    grid $gds.dihs2scan -column 0 -row 3 -sticky nswe
    grid columnconfigure $gds.dihs2scan 0 -weight 1 -minsize 150
    grid columnconfigure $gds.dihs2scan 1 -weight 1 -minsize 100
    grid columnconfigure $gds.dihs2scan 2 -weight 1 -minsize 100
    grid rowconfigure $gds.dihs2scan 7 -weight 1
    grid rowconfigure $gds.dihs2scan {1 2 3 5 6 9} -uniform rt1

    grid $gds.dihs2scan.dihLbl -column 0 -row 0 -sticky nswe
    grid $gds.dihs2scan.plusMinusLbl -column 1 -row 0 -sticky nswe
    grid $gds.dihs2scan.stepSizeLbl -column 2 -row 0 -sticky nswe
    grid $gds.dihs2scan.tv -column 0 -row 1 -columnspan 4 -rowspan 7 -sticky nswe
    grid $gds.dihs2scan.scroll -column 3 -row 1 -rowspan 7 -sticky nswe

    grid $gds.dihs2scan.add -column 4 -row 2 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $gds.dihs2scan.import -column 4 -row 1 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $gds.dihs2scan.move -column 4 -row 3 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid columnconfigure $gds.dihs2scan.move 0 -weight 1
    grid columnconfigure $gds.dihs2scan.move 1 -weight 1
    grid $gds.dihs2scan.move.up -column 0 -row 0 -sticky nswe
    grid $gds.dihs2scan.move.down -column 1 -row 0 -sticky nswe
    grid $gds.dihs2scan.sep1 -column 4 -row 4 -sticky nswe -padx $hsepPadX -pady $hsepPadY
    grid $gds.dihs2scan.delete -column 4 -row 5 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $gds.dihs2scan.clear -column 4 -row 6 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY

    grid $gds.dihs2scan.editLbl -column 0 -row 8 -sticky nswe
    grid $gds.dihs2scan.editIndDef -column 0 -row 9 -sticky nswe
    grid $gds.dihs2scan.editPlusMinus -column 1 -row 9 -sticky nswe
    grid $gds.dihs2scan.editStepSize -column 2 -row 9 -sticky nswe
    grid $gds.dihs2scan.editAcceptCancel -column 4 -row 9 -sticky nswe  -padx $vbuttonPadX -pady $vbuttonPadY
    grid columnconfigure $gds.dihs2scan.editAcceptCancel 0 -weight 1
    grid columnconfigure $gds.dihs2scan.editAcceptCancel 1 -weight 1
    grid $gds.dihs2scan.editAcceptCancel.accept -column 0 -row 0 -sticky nswe
    grid $gds.dihs2scan.editAcceptCancel.cancel -column 1 -row 0 -sticky nswe

    # build/grid a separator
    ttk::separator $gds.sep2 -orient horizontal
    grid $gds.sep2 -column 0 -row 4 -sticky nswe -padx $hsepPadX -pady $hsepPadY

    # GAUSSIAN SETTINGS
    # -----------------

    # build QM settings
    ttk::labelframe $gds.qm -text "QM Settings" -labelanchor nw -padding $labelFrameInternalPadding

    # add QM Selector
    ttk::menubutton $gds.qm.selector -direction below -menu $w.menuQMSelector -textvariable ::ForceFieldToolKit::qmSoft -width 15

    ttk::label $gds.qm.procLbl -text "Processors:" -anchor w
    ttk::entry $gds.qm.proc -textvariable ::ForceFieldToolKit::Configuration::qmProc -width 2 -justify center
    ttk::label $gds.qm.memLbl -text "Memory (GB):" -anchor w
    ttk::entry $gds.qm.mem -textvariable ::ForceFieldToolKit::Configuration::qmMem -width 2 -justify center
    ttk::label $gds.qm.chargeLbl -text "Charge:" -anchor w
    ttk::entry $gds.qm.charge -textvariable ::ForceFieldToolKit::GenDihScan::qmCharge -width 2 -justify center
    ttk::label $gds.qm.multLbl -text "Multiplicity:" -anchor w
    ttk::entry $gds.qm.mult -textvariable ::ForceFieldToolKit::GenDihScan::qmMult -width 2 -justify center
    ttk::button $gds.qm.defaults -text "Reset to Defaults" -command { ::ForceFieldToolKit::${::ForceFieldToolKit::qmSoft}::resetDefaultsGenDihScan }
    ttk::label $gds.qm.routeLbl -text "Route:" -justify center
    ttk::entry $gds.qm.route -textvariable ::ForceFieldToolKit::GenDihScan::qmRoute


    # grid QM settings
    grid $gds.qm -column 0 -row 5 -sticky nswe
    grid rowconfigure $gds.qm {0 1} -uniform rt1

    grid $gds.qm.selector   -column 0 -row 0 -columnspan 5 -sticky nsw

    grid $gds.qm.procLbl -column 0 -row 1 -sticky w
    grid $gds.qm.proc -column 1 -row 1 -sticky w
    grid $gds.qm.memLbl -column 2 -row 1 -sticky w
    grid $gds.qm.mem -column 3 -row 1 -sticky w
    grid $gds.qm.chargeLbl -column 4 -row 1 -sticky w
    grid $gds.qm.charge -column 5 -row 1 -sticky w
    grid $gds.qm.multLbl -column 6 -row 1 -sticky w
    grid $gds.qm.mult -column 7 -row 1 -sticky w
    grid $gds.qm.defaults -column 8 -row 1 -sticky we -padx $hbuttonPadX -pady $hbuttonPadY
    grid $gds.qm.routeLbl -column 0 -row 2
    grid $gds.qm.route -column 1 -row 2 -columnspan 8 -sticky nswe -padx $entryPadX -pady $entryPadY

    # build/grid a separator
    ttk::separator $gds.sep3 -orient horizontal
    grid $gds.sep3 -column 0 -row 6 -sticky nswe -padx $hsepPadX -pady $hsepPadY


    # GENERATE
    # build generate section
    ttk::frame $gds.generate
    ttk::button $gds.generate.go -text "Generate Dihedral Scan Input" \
        -command {
#            if {$::ForceFieldToolKit::qmSoft eq "ORCA"} {
#              ::ForceFieldToolKit::ORCA::tempORCAmessage
#              return
#            }
            set ::ForceFieldToolKit::GenDihScan::dihData {}
            foreach ele [.fftk_gui.hlf.nb.genDihScan.dihs2scan.tv children {}] {
                lappend ::ForceFieldToolKit::GenDihScan::dihData [.fftk_gui.hlf.nb.genDihScan.dihs2scan.tv item $ele -values]
            }
            ::ForceFieldToolKit::GenDihScan::buildGaussianFiles
            ::ForceFieldToolKit::gui::consoleMessage "QM files written (Scan Torsions)"
        }
    ttk::button $gds.generate.load -text "Load Dihedral Scan Output Files" \
        -command {
#            if {$::ForceFieldToolKit::qmSoft eq "ORCA"} {
#              ::ForceFieldToolKit::ORCA::tempORCAmessage
#              return
#            }
            set glogs [tk_getOpenFile -title "Select Output File(s) to Load" -multiple 1 -filetypes $::ForceFieldToolKit::gui::AllLogType]
            if { [llength $glogs] == 0 } {
                unset glogs
                return
            ### The psf and pdb variable names here were changed. The previous variable names could point to no files.
            } elseif { $::ForceFieldToolKit::Configuration::chargeOptPSF eq "" || ![file exists $::ForceFieldToolKit::Configuration::chargeOptPSF] } {
                tk_messageBox -type ok -icon warning -message "Action halted on error!" -detail "Cannot find PSF file."
                unset glogs
                return
            } elseif { $::ForceFieldToolKit::Configuration::geomOptPDB eq "" || ![file exists $::ForceFieldToolKit::Configuration::geomOptPDB] } {
                tk_messageBox -type ok -icon warning -message "Action halted on error!" -detail "Cannot find PDB file."
                unset glogs
                return
            } else {
                set scanData [::ForceFieldToolKit::DihOpt::parseGlog $glogs]
		            # Continue only if scanData contains some information, namely if there was no error during the parseGlog procedure
                if { $scanData ne "" } {::ForceFieldToolKit::DihOpt::vmdLoadQMData $::ForceFieldToolKit::Configuration::chargeOptPSF $::ForceFieldToolKit::Configuration::geomOptPDB $scanData
                unset scanData
                unset glogs
                ::ForceFieldToolKit::gui::consoleMessage "QM output file(s) loaded (Scan Torsions)"
		              }
            }
        }

    ttk::button $gds.generate.torexplor -text "Open Torsion Explorer" -command {
#            if {$::ForceFieldToolKit::qmSoft eq "ORCA"} {
#              ::ForceFieldToolKit::ORCA::tempORCAmessage
#              return
#            }
	    ::ForceFieldToolKit::GenDihScan::TorExplor::launchGUI
	    }

    # grid generate section
    grid $gds.generate -column 0 -row 7 -sticky nswe
    grid columnconfigure $gds.generate {0 1 2} -uniform ct1 -weight 1
    grid rowconfigure $gds.generate 0 -minsize 50

    grid $gds.generate.go        -column 0 -row 0 -sticky nswe -padx $buttonRunPadX -pady $buttonRunPadY
    grid $gds.generate.load      -column 1 -row 0 -sticky nswe -padx $buttonRunPadX -pady $buttonRunPadY
    grid $gds.generate.torexplor -column 2 -row 0 -sticky nswe -padx $buttonRunPadX -pady $buttonRunPadY



    #---------------------------------------------------#
    #  GenImprScan tab                                  #
    #---------------------------------------------------#

    # Add the dih/impr selector in before the pre-existing contents

    # build the frame, add it to the notebook
    ttk::frame $w.hlf.nb.genImprScan
    $w.hlf.nb add $w.hlf.nb.genImprScan -text "Scan Impropers"
    # allow frame to change width with content
    grid columnconfigure $w.hlf.nb.genImprScan 0 -weight 1
    # allow certain frames to gracefully change height
    grid rowconfigure $w.hlf.nb.genImprScan {2} -weight 1

    # for shorter naming convention
    set ims $w.hlf.nb.genImprScan


    # Dih/Impr Optimization Selector
    # -----------------------------------
    ttk::frame      $ims.dihImprSelector
    ttk::label      $ims.dihImprSelector.lbl      -text "Dihedrals/Impropers: " -anchor w -font TkDefaultFont
    ttk::menubutton $ims.dihImprSelector.selector -direction below -menu $w.dihImprSelectorMenu -textvariable ::ForceFieldToolKit::gui::dihImprMethod -width 15

    grid $ims.dihImprSelector    -column 0 -row 0 -sticky nswe -padx $hsepPadX -pady $labelFramePadY
    grid $ims.dihImprSelector.lbl      -column 0 -row 0 -sticky nwe
    grid $ims.dihImprSelector.selector -column 1 -row 0 -sticky nsw

    grid columnconfigure $ims.dihImprSelector 1 -minsize 15 -weight 1


    # INPUT/OUTPUT
    # ------------
    # build input/output
    ttk::labelframe $ims.io -labelanchor nw -padding $labelFrameInternalPadding -text "Input/Output"
    ttk::label $ims.io.psfLbl -text "PSF File:" -anchor center
    ttk::entry $ims.io.psf -textvariable ::ForceFieldToolKit::Configuration::chargeOptPSF
    ttk::button $ims.io.psfBrowse -text "Browse" \
        -command {
            set tempfile [tk_getOpenFile -title "Select a PSF File" -filetypes $::ForceFieldToolKit::gui::psfType]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::Configuration::chargeOptPSF $tempfile }
        }
    ttk::label $ims.io.pdbLbl -text "PDB File:" -anchor center
    ttk::entry $ims.io.pdb -textvariable ::ForceFieldToolKit::Configuration::geomOptPDB
    ttk::button $ims.io.pdbBrowse -text "Browse" \
        -command {
            set tempfile [tk_getOpenFile -title "Select a PDB File" -filetypes $::ForceFieldToolKit::gui::pdbType]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::Configuration::geomOptPDB $tempfile }
        }
    ttk::label $ims.io.outPathLbl -text "Output Path:" -anchor center
    ttk::entry $ims.io.outPath -textvariable ::ForceFieldToolKit::GenDihScan::outPath
    ttk::button $ims.io.outPathBrowse -text "Browse" \
        -command {
            set tempfile [tk_chooseDirectory -title "Select the Output Folder"]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::GenDihScan::outPath $tempfile }
        }
    ttk::label $ims.io.basenameLbl -text "Basename:" -anchor center
    ttk::frame $ims.io.bNameSub
    ttk::entry $ims.io.bNameSub.basename -textvariable ::ForceFieldToolKit::GenDihScan::basename -width 10 -justify center
    ttk::button $ims.io.bNameSub.takeFromTop -text "Basename from TOP" \
        -command {
            if { [llength [molinfo list]] == 0 } {
                tk_messageBox -type ok -icon warning -message "Action halted on error!" -detail "No PSF/PDBs loaded in VMD."
                return
            }
            set ::ForceFieldToolKit::GenDihScan::basename [lindex [[atomselect top all] get resname] 0]
        }

    ttk::separator $ims.io.sep1 -orient vertical
    ttk::button $ims.io.loadMolec -text "Load PSF/PDB" \
        -command {
            if { $::ForceFieldToolKit::Configuration::chargeOptPSF eq "" || ![file exists $::ForceFieldToolKit::Configuration::chargeOptPSF] } { tk_messageBox -type ok -icon warning -message "Action halted on error!" -detail "Cannot open PSF file."; return }
            if { $::ForceFieldToolKit::Configuration::geomOptPDB eq "" || ![file exists $::ForceFieldToolKit::Configuration::geomOptPDB] } { tk_messageBox -type ok -icon warning -message "Action halted on error!" -detail "Cannot open PDB file."; return }
            mol new $::ForceFieldToolKit::Configuration::chargeOptPSF
            mol addfile $::ForceFieldToolKit::Configuration::geomOptPDB
            ::ForceFieldToolKit::gui::consoleMessage "PSF/PDB files loaded (Scan Torsions)"
        }
    ttk::button $ims.io.toggleAtomLabels -text "Toggle Atom Labels" -command { ::ForceFieldToolKit::gui::imsToggleLabels }


    # grid input/output
    grid $ims.io -column 0 -row 1 -sticky nwe -padx $labelFramePadX -pady $labelFramePadY
    grid columnconfigure $ims.io 1 -weight 1
    grid rowconfigure $ims.io {0 1 2 3} -uniform rt1

    grid $ims.io.psfLbl -column 0 -row 0 -sticky nswe
    grid $ims.io.psf -column 1 -row 0 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $ims.io.psfBrowse -column 2 -row 0 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $ims.io.pdbLbl -column 0 -row 1 -sticky nswe
    grid $ims.io.pdb -column 1 -row 1 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $ims.io.pdbBrowse -column 2 -row 1 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $ims.io.outPathLbl -column 0 -row 2 -sticky nswe
    grid $ims.io.outPath -column 1 -row 2 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $ims.io.outPathBrowse -column 2 -row 2 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $ims.io.basenameLbl -column 0 -row 3 -sticky nswe

    grid $ims.io.bNameSub -column 1 -row 3 -sticky nswe
    grid columnconfigure $ims.io.bNameSub 0 -weight 1
    grid $ims.io.bNameSub.basename -column 0 -row 0 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $ims.io.bNameSub.takeFromTop -column 1 -row 0 -sticky nswe -padx $hbuttonPadX -pady $hbuttonPadY

    grid $ims.io.sep1 -column 3 -row 0 -rowspan 4 -sticky nswe -padx $vsepPadX -pady $vsepPadY
    grid $ims.io.loadMolec -column 4 -row 0 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $ims.io.toggleAtomLabels -column 4 -row 1 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY


    # build/grid a separator
    ttk::separator $ims.sep1 -orient horizontal
    grid $ims.sep1 -column 0 -row 2 -sticky nswe -padx $hsepPadX -pady $hsepPadY

    # IMPROPERS TO SCAN
    # -----------------
    # build impropers to scan
    ttk::labelframe $ims.imprs2scan -text "Impropers to Scan" -labelanchor nw -padding $labelFrameInternalPadding
    ttk::label $ims.imprs2scan.imprLbl -text "Improper Atoms" -anchor center
    ttk::label $ims.imprs2scan.plusMinusLbl -text "Scan +/- (${degree})" -anchor center
    ttk::label $ims.imprs2scan.stepSizeLbl -text "Step Size (${degree})" -anchor center
    ttk::treeview $ims.imprs2scan.tv -selectmode browse -yscrollcommand "$ims.imprs2scan.scroll set"
        $ims.imprs2scan.tv configure -columns {indDef plusMinus stepSize} -show {} -height 4
        $ims.imprs2scan.tv heading indDef -text "Improper Atoms"
        $ims.imprs2scan.tv heading plusMinus -text "+/-"
        $ims.imprs2scan.tv heading stepSize -text "Step Size"
        $ims.imprs2scan.tv column indDef -width 150 -stretch 1 -anchor center
        $ims.imprs2scan.tv column plusMinus -width 100 -stretch 1 -anchor center
        $ims.imprs2scan.tv column stepSize -width 100 -stretch 1 -anchor center
    ttk::scrollbar $ims.imprs2scan.scroll -orient vertical -command "$ims.imprs2scan.tv yview"

    # setup the binding to copy the selected TV item data to the edit boxes
    # also show a representation of the selected tv item
    bind $ims.imprs2scan.tv <<TreeviewSelect>> {
        set editData [.fftk_gui.hlf.nb.genImprScan.imprs2scan.tv item [.fftk_gui.hlf.nb.genImprScan.imprs2scan.tv selection] -values]
        set ::ForceFieldToolKit::gui::imsEditIndDef [lindex $editData 0]
        set ::ForceFieldToolKit::gui::imsEditPlusMinus [lindex $editData 1]
        set ::ForceFieldToolKit::gui::imsEditStepSize [lindex $editData 2]

        ::ForceFieldToolKit::gui::imsShowSelRep
    }

    ttk::button $ims.imprs2scan.add -text "Add" -command { .fftk_gui.hlf.nb.genImprScan.imprs2scan.tv insert {} end -values {{ind1 ind2 ind3 ind4} value value} }
    ttk::button $ims.imprs2scan.import -text "Read from PAR" \
        -command {
            set tempfile [tk_getOpenFile -title "Select A Parameter File" -filetypes $::ForceFieldToolKit::gui::parType]
            if {![string eq $tempfile ""]} {
                set importData [::ForceFieldToolKit::gui::imsImportImpropers $::ForceFieldToolKit::Configuration::chargeOptPSF $::ForceFieldToolKit::Configuration::geomOptPDB $tempfile]
                foreach ele $importData {
                    .fftk_gui.hlf.nb.genImprScan.imprs2scan.tv insert {} end -values [list $ele 30 3]
                }
            }
        }
    ttk::frame $ims.imprs2scan.move
    ttk::button $ims.imprs2scan.move.up -text "$upArrow" -width 1 \
        -command {
            # ID of current
            set currentID [.fftk_gui.hlf.nb.genImprScan.imprs2scan.tv selection]
            # ID of previous
            if {[set previousID [.fftk_gui.hlf.nb.genImprScan.imprs2scan.tv prev $currentID ]] ne ""} {
                # Index of previous
                set previousIndex [.fftk_gui.hlf.nb.genImprScan.imprs2scan.tv index $previousID]
                # Move ahead of previous
                .fftk_gui.hlf.nb.genImprScan.imprs2scan.tv move $currentID {} $previousIndex
                unset previousIndex
            }
            unset currentID previousID
        }
    ttk::button $ims.imprs2scan.move.down -text "$downArrow" -width 1 \
        -command {
            # ID of current
            set currentID [.fftk_gui.hlf.nb.genImprScan.imprs2scan.tv selection]
            # ID of Next
            if {[set previousID [.fftk_gui.hlf.nb.genImprScan.imprs2scan.tv next $currentID ]] ne ""} {
                # Index of Next
                set previousIndex [.fftk_gui.hlf.nb.genImprScan.imprs2scan.tv index $previousID]
                # Move below next
                .fftk_gui.hlf.nb.genImprScan.imprs2scan.tv move $currentID {} $previousIndex
                unset previousIndex
            }
            unset currentID previousID
        }
    ttk::separator $ims.imprs2scan.sep1 -orient horizontal
    ttk::button $ims.imprs2scan.delete -text "Delete" \
        -command {
            .fftk_gui.hlf.nb.genImprScan.imprs2scan.tv delete [.fftk_gui.hlf.nb.genImprScan.imprs2scan.tv selection]
            set ::ForceFieldToolKit::gui::imsEditIndDef {}
            set ::ForceFieldToolKit::gui::imsEditPlusMinus {}
            set ::ForceFieldToolKit::gui::imsEditStepSize {}
        }
    ttk::button $ims.imprs2scan.clear -text "Clear" \
        -command {
            .fftk_gui.hlf.nb.genImprScan.imprs2scan.tv delete [.fftk_gui.hlf.nb.genImprScan.imprs2scan.tv children {}]
            set ::ForceFieldToolKit::gui::imsEditIndDef {}
            set ::ForceFieldToolKit::gui::imsEditPlusMinus {}
            set ::ForceFieldToolKit::gui::imsEditStepSize {}
        }
    ttk::label $ims.imprs2scan.editLbl -text "Edit Entry" -anchor w
    ttk::entry $ims.imprs2scan.editIndDef -textvariable ::ForceFieldToolKit::gui::imsEditIndDef -width 1 -justify center
    ttk::entry $ims.imprs2scan.editPlusMinus -textvariable ::ForceFieldToolKit::gui::imsEditPlusMinus -width 1 -justify center
    ttk::entry $ims.imprs2scan.editStepSize -textvariable ::ForceFieldToolKit::gui::imsEditStepSize -width 1 -justify center
    ttk::frame $ims.imprs2scan.editAcceptCancel
    ttk::button $ims.imprs2scan.editAcceptCancel.accept -text "$accept" -width 1 \
        -command {
            .fftk_gui.hlf.nb.genImprScan.imprs2scan.tv item [.fftk_gui.hlf.nb.genImprScan.imprs2scan.tv selection] \
            -values [list $::ForceFieldToolKit::gui::imsEditIndDef $::ForceFieldToolKit::gui::imsEditPlusMinus $::ForceFieldToolKit::gui::imsEditStepSize]
        }
    ttk::button $ims.imprs2scan.editAcceptCancel.cancel -text "$cancel" -width 1 \
        -command {
        set editData [.fftk_gui.hlf.nb.genImprScan.imprs2scan.tv item [.fftk_gui.hlf.nb.genImprScan.imprs2scan.tv selection] -values]
        set ::ForceFieldToolKit::gui::imsEditIndDef [lindex $editData 0]
        set ::ForceFieldToolKit::gui::imsEditPlusMinus [lindex $editData 2]
        set ::ForceFieldToolKit::gui::imsEditStepSize [lindex $editData 3]
        }

    # grid impropers to scan
    grid $ims.imprs2scan -column 0 -row 3 -sticky nswe
    grid columnconfigure $ims.imprs2scan 0 -weight 1 -minsize 150
    grid columnconfigure $ims.imprs2scan 1 -weight 1 -minsize 100
    grid columnconfigure $ims.imprs2scan 2 -weight 1 -minsize 100
    grid rowconfigure $ims.imprs2scan 7 -weight 1
    grid rowconfigure $ims.imprs2scan {1 2 3 5 6 9} -uniform rt1

    grid $ims.imprs2scan.imprLbl -column 0 -row 0 -sticky nswe
    grid $ims.imprs2scan.plusMinusLbl -column 1 -row 0 -sticky nswe
    grid $ims.imprs2scan.stepSizeLbl -column 2 -row 0 -sticky nswe
    grid $ims.imprs2scan.tv -column 0 -row 1 -columnspan 4 -rowspan 7 -sticky nswe
    grid $ims.imprs2scan.scroll -column 3 -row 1 -rowspan 7 -sticky nswe

    grid $ims.imprs2scan.add -column 4 -row 2 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $ims.imprs2scan.import -column 4 -row 1 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $ims.imprs2scan.move -column 4 -row 3 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid columnconfigure $ims.imprs2scan.move 0 -weight 1
    grid columnconfigure $ims.imprs2scan.move 1 -weight 1
    grid $ims.imprs2scan.move.up -column 0 -row 0 -sticky nswe
    grid $ims.imprs2scan.move.down -column 1 -row 0 -sticky nswe
    grid $ims.imprs2scan.sep1 -column 4 -row 4 -sticky nswe -padx $hsepPadX -pady $hsepPadY
    grid $ims.imprs2scan.delete -column 4 -row 5 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $ims.imprs2scan.clear -column 4 -row 6 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY

    grid $ims.imprs2scan.editLbl -column 0 -row 8 -sticky nswe
    grid $ims.imprs2scan.editIndDef -column 0 -row 9 -sticky nswe
    grid $ims.imprs2scan.editPlusMinus -column 1 -row 9 -sticky nswe
    grid $ims.imprs2scan.editStepSize -column 2 -row 9 -sticky nswe
    grid $ims.imprs2scan.editAcceptCancel -column 4 -row 9 -sticky nswe  -padx $vbuttonPadX -pady $vbuttonPadY
    grid columnconfigure $ims.imprs2scan.editAcceptCancel 0 -weight 1
    grid columnconfigure $ims.imprs2scan.editAcceptCancel 1 -weight 1
    grid $ims.imprs2scan.editAcceptCancel.accept -column 0 -row 0 -sticky nswe
    grid $ims.imprs2scan.editAcceptCancel.cancel -column 1 -row 0 -sticky nswe

    # build/grid a separator
    ttk::separator $ims.sep2 -orient horizontal
    grid $ims.sep2 -column 0 -row 4 -sticky nswe -padx $hsepPadX -pady $hsepPadY

    # GAUSSIAN SETTINGS
    # -----------------

    # build QM settings
    ttk::labelframe $ims.qm -text "QM Settings" -labelanchor nw -padding $labelFrameInternalPadding

    # add QM Selector
    ttk::menubutton $ims.qm.selector -direction below -menu $w.menuQMSelector -textvariable ::ForceFieldToolKit::qmSoft -width 15

    ttk::label $ims.qm.procLbl -text "Processors:" -anchor w
    ttk::entry $ims.qm.proc -textvariable ::ForceFieldToolKit::Configuration::qmProc -width 2 -justify center
    ttk::label $ims.qm.memLbl -text "Memory (GB):" -anchor w
    ttk::entry $ims.qm.mem -textvariable ::ForceFieldToolKit::Configuration::qmMem -width 2 -justify center
    ttk::label $ims.qm.chargeLbl -text "Charge:" -anchor w
    ttk::entry $ims.qm.charge -textvariable ::ForceFieldToolKit::GenDihScan::qmCharge -width 2 -justify center
    ttk::label $ims.qm.multLbl -text "Multiplicity:" -anchor w
    ttk::entry $ims.qm.mult -textvariable ::ForceFieldToolKit::GenDihScan::qmMult -width 2 -justify center
    ttk::button $ims.qm.defaults -text "Reset to Defaults" -command { ::ForceFieldToolKit::${::ForceFieldToolKit::qmSoft}::resetDefaultsGenDihScan }
    ttk::label $ims.qm.routeLbl -text "Route:" -justify center
    ttk::entry $ims.qm.route -textvariable ::ForceFieldToolKit::GenDihScan::qmRoute


    # grid QM settings
    grid $ims.qm -column 0 -row 5 -sticky nswe
    grid rowconfigure $ims.qm {0 1} -uniform rt1

    grid $ims.qm.selector   -column 0 -row 0 -columnspan 5 -sticky nsw

    grid $ims.qm.procLbl -column 0 -row 1 -sticky w
    grid $ims.qm.proc -column 1 -row 1 -sticky w
    grid $ims.qm.memLbl -column 2 -row 1 -sticky w
    grid $ims.qm.mem -column 3 -row 1 -sticky w
    grid $ims.qm.chargeLbl -column 4 -row 1 -sticky w
    grid $ims.qm.charge -column 5 -row 1 -sticky w
    grid $ims.qm.multLbl -column 6 -row 1 -sticky w
    grid $ims.qm.mult -column 7 -row 1 -sticky w
    grid $ims.qm.defaults -column 8 -row 1 -sticky we -padx $hbuttonPadX -pady $hbuttonPadY
    grid $ims.qm.routeLbl -column 0 -row 2
    grid $ims.qm.route -column 1 -row 2 -columnspan 8 -sticky nswe -padx $entryPadX -pady $entryPadY

    # build/grid a separator
    ttk::separator $ims.sep3 -orient horizontal
    grid $ims.sep3 -column 0 -row 6 -sticky nswe -padx $hsepPadX -pady $hsepPadY


    # GENERATE
    # build generate section
    ttk::frame $ims.generate
    ttk::button $ims.generate.go -text "Generate Improper Scan Input" \
        -command {
#            if {$::ForceFieldToolKit::qmSoft eq "ORCA"} {
#              ::ForceFieldToolKit::ORCA::tempORCAmessage
#              return
#            }
            set ::ForceFieldToolKit::GenDihScan::dihData {}
            foreach ele [.fftk_gui.hlf.nb.genImprScan.imprs2scan.tv children {}] {
                lappend ::ForceFieldToolKit::GenDihScan::dihData [.fftk_gui.hlf.nb.genImprScan.imprs2scan.tv item $ele -values]
            }
            ::ForceFieldToolKit::GenDihScan::buildGaussianFiles
            ::ForceFieldToolKit::gui::consoleMessage "QM files written (Scan Impropers)"
        }
    ttk::button $ims.generate.load -text "Load Improper Scan Output Files" \
        -command {
#            if {$::ForceFieldToolKit::qmSoft eq "ORCA"} {
#              ::ForceFieldToolKit::ORCA::tempORCAmessage
#              return
#            }
            set glogs [tk_getOpenFile -title "Select Output File(s) to Load" -multiple 1 -filetypes $::ForceFieldToolKit::gui::AllLogType]
            if { [llength $glogs] == 0 } {
                unset glogs
                return
            ### The psf and pdb variable names here were changed. The previous variable names could point to no files.
            } elseif { $::ForceFieldToolKit::Configuration::chargeOptPSF eq "" || ![file exists $::ForceFieldToolKit::Configuration::chargeOptPSF] } {
                tk_messageBox -type ok -icon warning -message "Action halted on error!" -detail "Cannot find PSF file."
                unset glogs
                return
            } elseif { $::ForceFieldToolKit::Configuration::geomOptPDB eq "" || ![file exists $::ForceFieldToolKit::Configuration::geomOptPDB] } {
                tk_messageBox -type ok -icon warning -message "Action halted on error!" -detail "Cannot find PDB file."
                unset glogs
                return
            } else {
                set scanData [::ForceFieldToolKit::DihOpt::parseGlog $glogs]
		# Continue only if scanData contains some information, namely if there was no error during the parseGlog procedure
                if { $scanData ne "" } {::ForceFieldToolKit::DihOpt::vmdLoadQMData $::ForceFieldToolKit::Configuration::chargeOptPSF $::ForceFieldToolKit::Configuration::geomOptPDB $scanData
                unset scanData
                unset glogs
                ::ForceFieldToolKit::gui::consoleMessage "QM output file(s) loaded (Scan Impropers)"
		}
           }
        }

    # grid generate section
    grid $ims.generate -column 0 -row 7 -sticky nswe
    grid columnconfigure $ims.generate {0 1 2} -uniform ct1 -weight 1
    grid rowconfigure $ims.generate 0 -minsize 50

    grid $ims.generate.go        -column 0 -row 0 -sticky nswe -padx $buttonRunPadX -pady $buttonRunPadY
    grid $ims.generate.load      -column 1 -row 0 -sticky nswe -padx $buttonRunPadX -pady $buttonRunPadY



    #---------------------------------------------------#
    #  DihOpt     tab                                   #
    #---------------------------------------------------#

    # build the frame, add it to the notebook
    ttk::frame $w.hlf.nb.dihopt -width 500 -height 500
    $w.hlf.nb add $w.hlf.nb.dihopt -text "Opt. Torsions"
    # allow frame to change width with content
    grid columnconfigure $w.hlf.nb.dihopt 0 -weight 1

    # for shorter naming convention
    set dopt $w.hlf.nb.dihopt

    # Dih/Impr Optimization Selector
    # -----------------------------------
    ttk::frame      $dopt.dihImprSelector
    ttk::label      $dopt.dihImprSelector.lbl      -text "Dihedrals/Impropers: " -anchor w -font TkDefaultFont
    ttk::menubutton $dopt.dihImprSelector.selector -direction below -menu $w.dihImprSelectorMenu -textvariable ::ForceFieldToolKit::gui::dihImprMethod -width 15
    ttk::separator  $dopt.dihImprSelectorSep -orient horizontal

    grid $dopt.dihImprSelector    -column 0 -row 0 -sticky nswe -padx $hsepPadX -pady $labelFramePadY
    grid $dopt.dihImprSelector.lbl      -column 0 -row 0 -sticky nwe
    grid $dopt.dihImprSelector.selector -column 1 -row 0 -sticky nsw
    grid $dopt.dihImprSelectorSep -column 0 -row 1 -sticky nwe -padx $hsepPadX -pady $hsepPadY

    grid columnconfigure $dopt.dihImprSelector 1 -minsize 15 -weight 1


    # INPUT
    # -----
    # build input labels
    ttk::labelframe $dopt.input -labelanchor nw -padding $labelFrameInternalPadding
    ttk::label $dopt.input.lblWidget -text "$downPoint Input" -anchor w -font TkDefaultFont
    $dopt.input configure -labelwidget $dopt.input.lblWidget

    ttk::label $dopt.inputPlaceHolder -text "$rightPoint Input" -anchor w -font TkDefaultFont

    # set mouse click bindings to expand/contract input settings
    bind $dopt.input.lblWidget <Button-1> {
        grid remove .fftk_gui.hlf.nb.dihopt.input
        grid .fftk_gui.hlf.nb.dihopt.inputPlaceHolder
        grid rowconfigure .fftk_gui.hlf.nb.dihopt 2 -weight 0
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }
    bind $dopt.inputPlaceHolder <Button-1> {
        grid remove .fftk_gui.hlf.nb.dihopt.inputPlaceHolder
        grid .fftk_gui.hlf.nb.dihopt.input
        grid rowconfigure .fftk_gui.hlf.nb.dihopt 2 -weight 1
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }

    # build input elements
    ttk::label $dopt.input.psfPathLbl -text "PSF File:" -anchor center
    ttk::entry $dopt.input.psfPath -textvariable ::ForceFieldToolKit::Configuration::chargeOptPSF
    ttk::button $dopt.input.psfPathBrowse -text "Browse" \
        -command {
            set tempfile [tk_getOpenFile -title "Select A PSF File" -filetypes $::ForceFieldToolKit::gui::psfType]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::Configuration::chargeOptPSF $tempfile }
        }
    ttk::label $dopt.input.pdbPathLbl -text "PDB File:" -anchor center
    ttk::entry $dopt.input.pdbPath -textvariable ::ForceFieldToolKit::Configuration::geomOptPDB
    ttk::button $dopt.input.pdbPathBrowse -text "Browse" \
        -command {
            set tempfile [tk_getOpenFile -title "Select a PDB File" -filetypes $::ForceFieldToolKit::gui::pdbType]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::Configuration::geomOptPDB $tempfile }
        }

    ttk::separator $dopt.input.sep1 -orient horizontal

    ttk::label $dopt.input.parFilesLbl -text "Parameter Files (both pre-defined and in-progress)" -anchor w
    ttk::treeview $dopt.input.parFiles -selectmode browse -yscrollcommand "$dopt.input.parFilesScroll set"
        $dopt.input.parFiles configure -columns {filename} -show {} -height 3
        $dopt.input.parFiles column filename -stretch 1
    ttk::scrollbar $dopt.input.parFilesScroll -orient vertical -command "$dopt.input.parFiles yview"
    ttk::button $dopt.input.add -text "Add" \
        -command {
            set tempfiles [tk_getOpenFile -title "Select Parameter File(s)" -multiple 1 -filetypes $::ForceFieldToolKit::gui::parType]
            foreach tempfile $tempfiles {
                if {![string eq $tempfile ""]} { .fftk_gui.hlf.nb.dihopt.input.parFiles insert {} end -values [list $tempfile] }
            }
        }
    ttk::button $dopt.input.delete -text "Delete" -command { .fftk_gui.hlf.nb.dihopt.input.parFiles delete [.fftk_gui.hlf.nb.dihopt.input.parFiles selection] }
    ttk::button $dopt.input.clear -text "Clear" -command { .fftk_gui.hlf.nb.dihopt.input.parFiles delete [.fftk_gui.hlf.nb.dihopt.input.parFiles children {}] }

    ttk::separator $dopt.input.sep2 -orient horizontal

    ttk::label $dopt.input.namdbinLbl -text "NAMD binary:" -anchor center
    ttk::entry $dopt.input.namdbin -textvariable ::ForceFieldToolKit::Configuration::namdBin
    ttk::button $dopt.input.namdbinBrowse -text "Browse" \
        -command {
            set tempfile [tk_getOpenFile -title "Select NAMD Bin File" -filetypes $::ForceFieldToolKit::gui::allType]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::Configuration::namdBin $tempfile }
        }
    ttk::label $dopt.input.logLbl -text "Output LOG:" -anchor center
    ttk::entry $dopt.input.log -textvariable ::ForceFieldToolKit::DihOpt::outFileName
    ttk::button $dopt.input.logSaveAs -text "SaveAs" \
        -command {
            set tempfile [tk_getSaveFile -title "Save Dihedral Optimization LOG File As..." -initialfile "$::ForceFieldToolKit::DihOpt::outFileName" -filetypes $::ForceFieldToolKit::gui::logType -defaultextension {.log}]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::DihOpt::outFileName $tempfile }
        }

    # grid input elements
    grid $dopt.input -column 0 -row 2 -sticky nswe -padx $labelFramePadX -pady $labelFramePadY
    grid columnconfigure $dopt.input 1 -weight 1
    grid rowconfigure $dopt.input {0 1 4 5 6 9} -uniform rt1
    grid rowconfigure $dopt.input 7 -weight 1
    grid remove $dopt.input
    grid $dopt.inputPlaceHolder -column 0 -row 2 -sticky nswe -padx $placeHolderPadX -pady $placeHolderPadY
    grid $dopt.input.psfPathLbl -column 0 -row 0 -sticky nswe
    grid $dopt.input.psfPath -column 1 -row 0 -columnspan 2 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $dopt.input.psfPathBrowse -column 3 -row 0 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $dopt.input.pdbPathLbl -column 0 -row 1 -sticky nswe
    grid $dopt.input.pdbPath -column 1 -row 1 -columnspan 2 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $dopt.input.pdbPathBrowse -column 3 -row 1 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $dopt.input.sep1 -column 0 -row 2 -columnspan 4 -sticky we -padx $hsepPadX -pady $hsepPadY
    grid $dopt.input.parFilesLbl -column 0 -row 3 -sticky nswe -columnspan 2
    grid $dopt.input.parFiles -column 0 -row 4 -columnspan 2 -rowspan 4 -sticky nswe
    grid $dopt.input.parFilesScroll -column 2 -row 4 -rowspan 4 -sticky nswe
    grid $dopt.input.add -column 3 -row 4 -sticky nwe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $dopt.input.delete -column 3 -row 5 -sticky nwe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $dopt.input.clear -column 3 -row 6 -sticky nwe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $dopt.input.sep2 -column 0 -row 8 -columnspan 4 -sticky we -padx $hsepPadX -pady $hsepPadY
    grid $dopt.input.namdbinLbl -column 0 -row 9 -sticky nswe
    grid $dopt.input.namdbin -column 1 -row 9 -columnspan 2 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $dopt.input.namdbinBrowse -column 3 -row 9 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $dopt.input.logLbl -column 0 -row 10 -sticky nswe
    grid $dopt.input.log -column 1 -row 10 -columnspan 2 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $dopt.input.logSaveAs -column 3 -row 10 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY

    # QM TARGET DATA
    # --------------
    # build QM target data labels
    ttk::labelframe $dopt.qmt -labelanchor nw -padding $labelFrameInternalPadding
    ttk::label $dopt.qmt.lblWidget -text "$downPoint QM Target Data" -anchor w -font TkDefaultFont
    $dopt.qmt configure -labelwidget $dopt.qmt.lblWidget
    ttk::label $dopt.qmtPlaceHolder -text "$rightPoint QM Target Data" -anchor w -font TkDefaultFont

    # set mouse click bindings to expand/contract qmt settings
    bind $dopt.qmt.lblWidget <Button-1> {
        grid remove .fftk_gui.hlf.nb.dihopt.qmt
        grid .fftk_gui.hlf.nb.dihopt.qmtPlaceHolder
        grid rowconfigure .fftk_gui.hlf.nb.dihopt 3 -weight 0
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }
    bind $dopt.qmtPlaceHolder <Button-1> {
        grid remove .fftk_gui.hlf.nb.dihopt.qmtPlaceHolder
        grid .fftk_gui.hlf.nb.dihopt.qmt
        grid rowconfigure .fftk_gui.hlf.nb.dihopt 3 -weight 1
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }

    # build QM target data (Log files) elements
    # QM selector
    ttk::menubutton $dopt.qmt.selector -direction below -menu $w.menuQMSelector -textvariable ::ForceFieldToolKit::qmSoft -width 15

    ttk::label $dopt.qmt.lbl -text "QM Dihedral Scan Output Files" -anchor w
    ttk::treeview $dopt.qmt.tv -selectmode browse -yscrollcommand "$dopt.qmt.scroll set"
        $dopt.qmt.tv configure -columns {filename} -show {} -height 5
        $dopt.qmt.tv column filename -stretch 1
    ttk::scrollbar $dopt.qmt.scroll -orient vertical -command "$dopt.qmt.tv yview"
    ttk::button $dopt.qmt.add -text "Add" \
        -command {
            set tempfiles [tk_getOpenFile -title "Select Output File(s) for Dihedral Scan Calculations" -multiple 1 -filetypes $::ForceFieldToolKit::gui::AllLogType]
            foreach tempfile $tempfiles {
                if {![string eq $tempfile ""]} { .fftk_gui.hlf.nb.dihopt.qmt.tv insert {} end -values $tempfile }
            }
        }
    ttk::button $dopt.qmt.moveUp -text "Move $upArrow" \
        -command {
            # ID of current
            set currentID [.fftk_gui.hlf.nb.dihopt.qmt.tv selection]
            # ID of previous
            if {[set previousID [.fftk_gui.hlf.nb.dihopt.qmt.tv prev $currentID ]] ne ""} {
                # Index of previous
                set previousIndex [.fftk_gui.hlf.nb.dihopt.qmt.tv index $previousID]
                # Move ahead of previous
                .fftk_gui.hlf.nb.dihopt.qmt.tv move $currentID {} $previousIndex
                unset previousIndex
            }
            unset currentID previousID
        }
    ttk::button $dopt.qmt.moveDown -text "Move $downArrow" \
        -command {
            # ID of current
            set currentID [.fftk_gui.hlf.nb.dihopt.qmt.tv selection]
            # ID of Next
            if {[set previousID [.fftk_gui.hlf.nb.dihopt.qmt.tv next $currentID ]] ne ""} {
                # Index of Next
                set previousIndex [.fftk_gui.hlf.nb.dihopt.qmt.tv index $previousID]
                # Move below next
                .fftk_gui.hlf.nb.dihopt.qmt.tv move $currentID {} $previousIndex
                unset previousIndex
            }
            unset currentID previousID
        }
    ttk::separator $dopt.qmt.sep1 -orient horizontal
    ttk::button $dopt.qmt.delete -text "Delete" -command { .fftk_gui.hlf.nb.dihopt.qmt.tv delete [.fftk_gui.hlf.nb.dihopt.qmt.tv selection] }
    ttk::button $dopt.qmt.clear -text "Clear" -command { .fftk_gui.hlf.nb.dihopt.qmt.tv delete [.fftk_gui.hlf.nb.dihopt.qmt.tv children {}] }

    # grid the QM target data elements
    grid $dopt.qmt -column 0 -row 3 -sticky nswe -padx $labelFramePadX -pady $labelFramePadY
    grid columnconfigure $dopt.qmt 0 -weight 1
    grid rowconfigure $dopt.qmt 7 -weight 1

    grid remove $dopt.qmt
    grid $dopt.qmtPlaceHolder -column 0 -row 3 -sticky nswe -padx $placeHolderPadX -pady $placeHolderPadY

    grid $dopt.qmt.selector -column 0 -row 0 -columnspan 5 -sticky nsw

    grid $dopt.qmt.lbl -column 0 -row 2 -sticky nswe
    grid $dopt.qmt.tv -column 0 -row 2 -rowspan 7 -sticky nswe
    grid $dopt.qmt.scroll -column 1 -row 2 -rowspan 7 -sticky nswe
    grid $dopt.qmt.add -column 2 -row 2 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $dopt.qmt.moveUp -column 2 -row 3 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $dopt.qmt.moveDown -column 2 -row 4 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $dopt.qmt.sep1 -column 2 -row 5 -sticky nswe -padx $hsepPadX -pady $hsepPadY
    grid $dopt.qmt.delete -column 2 -row 6 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $dopt.qmt.clear -column 2 -row 7 -sticky nwe -padx $vbuttonPadX -pady $vbuttonPadY


    # DIH PARAMETER SETTINGS
    # ----------------------
    # build the parameter settings labels
    ttk::labelframe $dopt.parSet -labelanchor nw -padding $labelFrameInternalPadding
    ttk::label $dopt.parSet.lblWidget -text "$downPoint Dihedral Parameter Settings" -anchor w -font TkDefaultFont
    $dopt.parSet configure -labelwidget $dopt.parSet.lblWidget
    ttk::label $dopt.parSetPlaceHolder -text "$rightPoint Dihedral Parameter Settings" -anchor w -font TkDefaultFont

    # set mouse click bindings to expand/contract
    bind $dopt.parSet.lblWidget <Button-1> {
        grid remove .fftk_gui.hlf.nb.dihopt.parSet
        grid .fftk_gui.hlf.nb.dihopt.parSetPlaceHolder
        grid rowconfigure .fftk_gui.hlf.nb.dihopt 4 -weight 0
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }
    bind $dopt.parSetPlaceHolder <Button-1> {
        grid remove .fftk_gui.hlf.nb.dihopt.parSetPlaceHolder
        grid .fftk_gui.hlf.nb.dihopt.parSet
        grid rowconfigure .fftk_gui.hlf.nb.dihopt 4 -weight 1
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }

    # build the parameter settings elements
    ttk::label $dopt.parSet.typeDefLbl -text "Dihedral Type Definition" -anchor w
    ttk::label $dopt.parSet.fcLbl -text "Force Constant (k)" -anchor center
    ttk::label $dopt.parSet.multLbl -text "Periodicity (n)" -anchor center
    ttk::label $dopt.parSet.deltaLbl -text "Phase Shift (\u03B4)" -anchor center
    ttk::label $dopt.parSet.lockPhaseLbl -text "Lock Phase?" -anchor center
    ttk::treeview $dopt.parSet.tv -selectmode browse -yscrollcommand "$dopt.parSet.scroll set"
        $dopt.parSet.tv configure -column {def fc mult delta lock} -show {} -height 5
        $dopt.parSet.tv heading def -text "Dihdedral Type Definition" -anchor w
        $dopt.parSet.tv heading fc -text "Force Constant (k)" -anchor center
        $dopt.parSet.tv heading mult -text "Periodicity (n)" -anchor center
        $dopt.parSet.tv heading delta -text "Phase Shift (d)" -anchor center
        $dopt.parSet.tv heading lock -text "Lock Phase?" -anchor center
        $dopt.parSet.tv column def -width 150 -stretch 1 -anchor w
        $dopt.parSet.tv column fc -width 100 -stretch 0 -anchor center
        $dopt.parSet.tv column mult -width 100 -stretch 0 -anchor center
        $dopt.parSet.tv column delta -width 100 -stretch 0 -anchor center
        $dopt.parSet.tv column lock -width 100 -stretch 0 -anchor center
    ttk::scrollbar $dopt.parSet.scroll -orient vertical -command "$dopt.parSet.tv yview"

    # setup the binding to copy the selected TV item data to the edit boxes
    bind $dopt.parSet.tv <<TreeviewSelect>> {
        set editData [.fftk_gui.hlf.nb.dihopt.parSet.tv item [.fftk_gui.hlf.nb.dihopt.parSet.tv selection] -values]
        set ::ForceFieldToolKit::gui::doptEditDef [lindex $editData 0]
        set ::ForceFieldToolKit::gui::doptEditFC [lindex $editData 1]
        set ::ForceFieldToolKit::gui::doptEditMult [lindex $editData 2]
        set ::ForceFieldToolKit::gui::doptEditDelta [lindex $editData 3]
        set ::ForceFieldToolKit::gui::doptEditLock [lindex $editData 4]
    }

    ttk::button $dopt.parSet.import -text "Read from PAR" \
        -command {
            set tempfile [tk_getOpenFile -title "Select A Parameter File" -filetypes $::ForceFieldToolKit::gui::parType]
            if {![string eq $tempfile ""]} {
                # read the parameter file and grab the dihedrals section
                set dihParamsIn [lindex [::ForceFieldToolKit::SharedFcns::readParFile $tempfile] 2]
                # parse out indv dihedral parameter data and add a new entry to the TV
                foreach dih $dihParamsIn {
                    .fftk_gui.hlf.nb.dihopt.parSet.tv insert {} end -values [list [lindex $dih 0] [lindex $dih 1 0] [lindex $dih 1 1] [lindex $dih 1 2] "no"]
                }
                # clean up
                unset dihParamsIn
            }
        }
    ttk::button $dopt.parSet.add -text "Add" -command { .fftk_gui.hlf.nb.dihopt.parSet.tv insert {} end -values [list "AT1 AT2 AT3 AT4" "0.0" "1" "0" "no"] }
    ttk::button $dopt.parSet.duplicate -text "Duplicate" -width 8 \
        -command {
            set currID [.fftk_gui.hlf.nb.dihopt.parSet.tv selection]
            set currIndex [.fftk_gui.hlf.nb.dihopt.parSet.tv index $currID]
            set currValues [.fftk_gui.hlf.nb.dihopt.parSet.tv item $currID -values]
            .fftk_gui.hlf.nb.dihopt.parSet.tv insert {} [expr {$currIndex+1}] -values $currValues
            unset currID currIndex currValues
        }
    ttk::frame $dopt.parSet.move
    ttk::button $dopt.parSet.move.up -text "$upArrow" -width 1 \
        -command {
            # ID of current
            set currentID [.fftk_gui.hlf.nb.dihopt.parSet.tv selection]
            # ID of previous
            if {[set previousID [.fftk_gui.hlf.nb.dihopt.parSet.tv prev $currentID ]] ne ""} {
                # Index of previous
                set previousIndex [.fftk_gui.hlf.nb.dihopt.parSet.tv index $previousID]
                # Move ahead of previous
                .fftk_gui.hlf.nb.dihopt.parSet.tv move $currentID {} $previousIndex
                unset previousIndex
            }
            unset currentID previousID
        }
    ttk::button $dopt.parSet.move.down -text "$downArrow" -width 1 \
        -command {
            # ID of current
            set currentID [.fftk_gui.hlf.nb.dihopt.parSet.tv selection]
            # ID of Next
            if {[set previousID [.fftk_gui.hlf.nb.dihopt.parSet.tv next $currentID ]] ne ""} {
                # Index of Next
                set previousIndex [.fftk_gui.hlf.nb.dihopt.parSet.tv index $previousID]
                # Move below next
                .fftk_gui.hlf.nb.dihopt.parSet.tv move $currentID {} $previousIndex
                unset previousIndex
            }
            unset currentID previousID
        }

    ttk::separator $dopt.parSet.sep -orient horizontal

    ttk::button $dopt.parSet.delete -text "Delete" \
        -command {
            .fftk_gui.hlf.nb.dihopt.parSet.tv delete [.fftk_gui.hlf.nb.dihopt.parSet.tv selection]
            set ::ForceFieldToolKit::gui::doptEditDef {}
            set ::ForceFieldToolKit::gui::doptEditFC {}
            set ::ForceFieldToolKit::gui::doptEditMult {}
            set ::ForceFieldToolKit::gui::doptEditDelta {}
            set ::ForceFieldToolKit::gui::doptEditLock {}
        }
    ttk::button $dopt.parSet.clear -text "Clear" \
        -command {
            .fftk_gui.hlf.nb.dihopt.parSet.tv delete [.fftk_gui.hlf.nb.dihopt.parSet.tv children {}]
            set ::ForceFieldToolKit::gui::doptEditDef {}
            set ::ForceFieldToolKit::gui::doptEditFC {}
            set ::ForceFieldToolKit::gui::doptEditMult {}
            set ::ForceFieldToolKit::gui::doptEditDelta {}
            set ::ForceFieldToolKit::gui::doptEditLock {}
        }

    ttk::label $dopt.parSet.editLbl -text "Edit Entry" -anchor w
    ttk::entry $dopt.parSet.editDef -textvariable ::ForceFieldToolKit::gui::doptEditDef -justify left
    ttk::entry $dopt.parSet.editFC -textvariable ::ForceFieldToolKit::gui::doptEditFC -justify center -width 1
    ttk::menubutton $dopt.parSet.editMult -direction below -menu $dopt.parSet.editMult.menu -textvariable ::ForceFieldToolKit::gui::doptEditMult -width 1
    menu $dopt.parSet.editMult.menu -tearoff no
        $dopt.parSet.editMult.menu add command -label "1" -command { set ::ForceFieldToolKit::gui::doptEditMult 1 }
        $dopt.parSet.editMult.menu add command -label "2" -command { set ::ForceFieldToolKit::gui::doptEditMult 2 }
        $dopt.parSet.editMult.menu add command -label "3" -command { set ::ForceFieldToolKit::gui::doptEditMult 3 }
        $dopt.parSet.editMult.menu add command -label "4" -command { set ::ForceFieldToolKit::gui::doptEditMult 4 }
        $dopt.parSet.editMult.menu add command -label "6" -command { set ::ForceFieldToolKit::gui::doptEditMult 6 }

    ttk::menubutton $dopt.parSet.editDelta -direction below -menu $dopt.parSet.editDelta.menu -textvariable ::ForceFieldToolKit::gui::doptEditDelta -width 5
    menu $dopt.parSet.editDelta.menu -tearoff no
        $dopt.parSet.editDelta.menu add command -label "0" -command { set ::ForceFieldToolKit::gui::doptEditDelta "0.00" }
        $dopt.parSet.editDelta.menu add command -label "180" -command { set ::ForceFieldToolKit::gui::doptEditDelta "180.00" }

    ttk::menubutton $dopt.parSet.editLockPhase -direction below -menu $dopt.parSet.editLockPhase.menu -textvariable ::ForceFieldToolKit::gui::doptEditLock -width 2
    menu $dopt.parSet.editLockPhase.menu -tearoff no
        $dopt.parSet.editLockPhase.menu add command -label "no" -command { set ::ForceFieldToolKit::gui::doptEditLock "no" }
        $dopt.parSet.editLockPhase.menu add command -label "yes" -command { set ::ForceFieldToolKit::gui::doptEditLock "yes" }

    ttk::frame $dopt.parSet.editButtons
    ttk::button $dopt.parSet.editButtons.accept -text "$accept" -width 1 \
        -command {
            .fftk_gui.hlf.nb.dihopt.parSet.tv item [.fftk_gui.hlf.nb.dihopt.parSet.tv selection] \
            -values [list $::ForceFieldToolKit::gui::doptEditDef $::ForceFieldToolKit::gui::doptEditFC $::ForceFieldToolKit::gui::doptEditMult $::ForceFieldToolKit::gui::doptEditDelta $::ForceFieldToolKit::gui::doptEditLock]
        }
    ttk::button $dopt.parSet.editButtons.cancel -text "$cancel" -width 1 \
        -command {
            set editData [.fftk_gui.hlf.nb.dihopt.parSet.tv item [.fftk_gui.hlf.nb.dihopt.parSet.tv selection] -values]
            set ::ForceFieldToolKit::gui::doptEditDef [lindex $editData 0]
            set ::ForceFieldToolKit::gui::doptEditFC [lindex $editData 1]
            set ::ForceFieldToolKit::gui::doptEditMult [lindex $editData 2]
            set ::ForceFieldToolKit::gui::doptEditDelta [lindex $editData 3]
        }

    # grid the parameter settings elements
    grid $dopt.parSet -column 0 -row 4 -sticky nswe -padx $labelFramePadX -pady $labelFramePadY
    grid columnconfigure $dopt.parSet 0 -weight 1 -minsize 150
    grid columnconfigure $dopt.parSet {1 2 3 4} -weight 0 -minsize 100

    grid rowconfigure $dopt.parSet {1 2 3 4 6} -uniform rt1
    grid rowconfigure $dopt.parSet 8 -weight 1
    grid remove $dopt.parSet

    grid $dopt.parSetPlaceHolder -column 0 -row 4 -sticky nswe -padx $placeHolderPadX -pady $placeHolderPadY

    grid $dopt.parSet.typeDefLbl -column 0 -row 0 -sticky nwse
    grid $dopt.parSet.fcLbl -column 1 -row 0 -sticky nswe
    grid $dopt.parSet.multLbl -column 2 -row 0 -sticky nswe
    grid $dopt.parSet.deltaLbl -column 3 -row 0 -sticky nswe
    grid $dopt.parSet.lockPhaseLbl -column 4 -row 0 -sticky nswe
    grid $dopt.parSet.tv -column 0 -row 1 -columnspan 5 -rowspan 8 -sticky nswe
    grid $dopt.parSet.scroll -column 5 -row 1 -rowspan 8 -sticky nswe

    grid $dopt.parSet.import -column 6 -row 1 -sticky nwse -padx $vbuttonPadX -pady $vbuttonPadY
    grid $dopt.parSet.add -column 6 -row 2 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $dopt.parSet.duplicate -column 6 -row 3 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $dopt.parSet.move -column 6 -row 4 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid columnconfigure $dopt.parSet.move {0 1} -weight 1
    grid $dopt.parSet.move.up -column 0 -row 0 -sticky nswe
    grid $dopt.parSet.move.down -column 1 -row 0 -sticky nswe
    grid $dopt.parSet.sep -column 6 -row 5 -sticky we -padx $hsepPadX -pady $hsepPadY

    grid $dopt.parSet.delete -column 6 -row 6 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $dopt.parSet.clear -column 6 -row 7 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $dopt.parSet.editLbl -column 0 -row 9 -sticky nswe
    grid $dopt.parSet.editDef -column 0 -row 10 -sticky nswe -pady "0 5"
    grid $dopt.parSet.editFC -column 1 -row 10 -sticky nswe -pady "0 5" -padx 10
    grid $dopt.parSet.editMult -column 2 -row 10 -sticky nswe -pady "0 5" -padx 24
    grid $dopt.parSet.editDelta -column 3 -row 10 -sticky nswe -pady "0 5" -padx 10
    grid $dopt.parSet.editLockPhase -column 4 -row 10 -sticky nswe -pady "0 5" -padx 10
    grid $dopt.parSet.editButtons -column 6 -row 10 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid columnconfigure $dopt.parSet.editButtons 0 -weight 1
    grid columnconfigure $dopt.parSet.editButtons 1 -weight 1
    grid $dopt.parSet.editButtons.accept -column 0 -row 0 -sticky nswe
    grid $dopt.parSet.editButtons.cancel -column 1 -row 0 -sticky nswe


    # ADVANCED SETTINGS
    # -----------------
    # build the advanced settings labels
    ttk::labelframe $dopt.adv -labelanchor nw -padding $labelFrameInternalPadding
    ttk::label $dopt.adv.lblWidget -text "$downPoint Advanced Settings" -anchor w -font TkDefaultFont
    $dopt.adv configure -labelwidget $dopt.adv.lblWidget
    ttk::label $dopt.advPlaceHolder -text "$rightPoint Advanced Settings" -anchor w -font TkDefaultFont

    # set mouse click bindings to expand/contract
    bind $dopt.adv.lblWidget <Button-1> {
        grid remove .fftk_gui.hlf.nb.dihopt.adv
        grid .fftk_gui.hlf.nb.dihopt.advPlaceHolder
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }
    bind $dopt.advPlaceHolder <Button-1> {
        grid remove .fftk_gui.hlf.nb.dihopt.advPlaceHolder
        grid .fftk_gui.hlf.nb.dihopt.adv
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }

    # build advanced settings section
    ttk::frame $dopt.adv.dih
    ttk::label $dopt.adv.dih.lbl -text "Dihedral Settings" -anchor w
    ttk::label $dopt.adv.dih.kmaxLbl -text "Kmax:" -anchor w
    ttk::entry $dopt.adv.dih.kmax -textvariable ::ForceFieldToolKit::DihOpt::kmax -width 8 -justify center
    ttk::label $dopt.adv.dih.eCutoffLbl -text "Energy Cutoff" -anchor w
    ttk::entry $dopt.adv.dih.eCutoff -textvariable ::ForceFieldToolKit::DihOpt::cutoff -width 8 -justify center
    ttk::separator $dopt.adv.sep1 -orient horizontal
    ttk::frame $dopt.adv.opt
    ttk::label $dopt.adv.opt.lbl -text "Optimize Settings" -anchor w
    ttk::label $dopt.adv.opt.tolLbl -text "Tolerance:" -anchor w
    ttk::entry $dopt.adv.opt.tol -textvariable ::ForceFieldToolKit::DihOpt::tol -width 6 -justify center
    ttk::label $dopt.adv.opt.modeLbl -text "Mode:" -anchor w
    ttk::menubutton $dopt.adv.opt.mode -direction below -menu $dopt.adv.opt.mode.menu -textvariable ::ForceFieldToolKit::DihOpt::mode -width 16
    menu $dopt.adv.opt.mode.menu -tearoff no
        $dopt.adv.opt.mode.menu add command -label "downhill" \
            -command {
                set ::ForceFieldToolKit::DihOpt::mode downhill
                grid remove .fftk_gui.hlf.nb.dihopt.adv.opt.saSettings
            }
        $dopt.adv.opt.mode.menu add command -label "simulated annealing" \
            -command {
                set ::ForceFieldToolKit::DihOpt::mode {simulated annealing}
                grid .fftk_gui.hlf.nb.dihopt.adv.opt.saSettings
            }
    ttk::frame $dopt.adv.opt.saSettings
    ttk::label $dopt.adv.opt.saSettings.tempLbl -text "T:" -anchor w
    ttk::entry $dopt.adv.opt.saSettings.temp -textvariable ::ForceFieldToolKit::DihOpt::saT -width 8 -justify center
    ttk::label $dopt.adv.opt.saSettings.tStepsLbl -text "Tsteps:" -anchor w
    ttk::entry $dopt.adv.opt.saSettings.tSteps -textvariable ::ForceFieldToolKit::DihOpt::saTSteps -width 8 -justify center
    ttk::label $dopt.adv.opt.saSettings.iterLbl -text "Iter:" -anchor w
    ttk::entry $dopt.adv.opt.saSettings.iter -textvariable ::ForceFieldToolKit::DihOpt::saIter -width 8 -justify center
    ttk::label $dopt.adv.opt.saSettings.expLbl -text "TExp:" -anchor w
    ttk::entry $dopt.adv.opt.saSettings.exp -textvariable ::ForceFieldToolKit::DihOpt::saTExp -width 8 -justify center
    ttk::separator $dopt.adv.sep2 -orient horizontal
    ttk::frame $dopt.adv.run
    ttk::label $dopt.adv.run.lbl -text "Run Settings" -anchor w
    ttk::checkbutton $dopt.adv.run.debugButton -offvalue 0 -onvalue 1 -variable ::ForceFieldToolKit::DihOpt::debug
    ttk::label $dopt.adv.run.debugLbl -text "Write debugging log" -anchor w
    ttk::checkbutton $dopt.adv.run.buildScriptButton -offvalue 0 -onvalue 1 -variable ::ForceFieldToolKit::gui::doptBuildScript
    ttk::label $dopt.adv.run.buildScriptLbl -text "Build run script"
    ttk::checkbutton $dopt.adv.run.writeEnCompsButton -offvalue 0 -onvalue 1 -variable ::ForceFieldToolKit::DihOpt::WriteEnComps
    ttk::label $dopt.adv.run.writeEnCompsLbl -text "Write Energy Comparison Data"
    ttk::label $dopt.adv.run.outFreqLbl -text "Output Freq.:" -anchor w
    ttk::entry $dopt.adv.run.outFreq -textvariable ::ForceFieldToolKit::DihOpt::outFreq -width 8 -justify center
    ttk::checkbutton $dopt.adv.run.keepMMTraj -offvalue 0 -onvalue 1 -variable ::ForceFieldToolKit::DihOpt::keepMMTraj
    ttk::label $dopt.adv.run.keepMMTrajLbl -text "Save MM Traj." -anchor w

    # grid advanced settings section
    grid $dopt.adv -column 0 -row 5 -sticky nswe -padx $labelFramePadX -pady $labelFramePadY
    grid columnconfigure $dopt.adv 0 -weight 1
    grid remove $dopt.adv
    grid $dopt.advPlaceHolder -column 0 -row 5 -sticky nswe -padx $placeHolderPadX -pady $placeHolderPadY
    grid $dopt.adv.dih -column 0 -row 0 -sticky nswe
    grid $dopt.adv.dih.lbl -column 0 -row 0 -columnspan 2 -sticky nswe
    grid $dopt.adv.dih.kmaxLbl -column 0 -row 1 -sticky nswe
    grid $dopt.adv.dih.kmax -column 1 -row 1 -sticky nswe
    grid $dopt.adv.dih.eCutoffLbl -column 2 -row 1 -sticky nswe
    grid $dopt.adv.dih.eCutoff -column 3 -row 1 -sticky nswe
    grid $dopt.adv.sep1 -column 0 -row 1 -sticky we -pady 5
    grid $dopt.adv.opt -column 0 -row 2 -sticky nswe
    grid $dopt.adv.opt.lbl -column 0 -row 0 -columnspan 3 -sticky nswe
    grid $dopt.adv.opt.tolLbl -column 0 -row 1 -sticky nswe
    grid $dopt.adv.opt.tol -column 1 -row 1 -sticky nsw
    grid $dopt.adv.opt.modeLbl -column 0 -row 2 -sticky nswe
    grid $dopt.adv.opt.mode -column 1 -row 2 -sticky nswe
    grid $dopt.adv.opt.saSettings -column 2 -row 2 -sticky we -padx "5 0"
    grid $dopt.adv.opt.saSettings.tempLbl -column 0 -row 0 -sticky nswe
    grid $dopt.adv.opt.saSettings.temp -column 1 -row 0 -sticky nswe
    grid $dopt.adv.opt.saSettings.tStepsLbl -column 2 -row 0 -sticky nswe
    grid $dopt.adv.opt.saSettings.tSteps -column 3 -row 0 -sticky nswe
    grid $dopt.adv.opt.saSettings.iterLbl -column 4 -row 0 -sticky nswe
    grid $dopt.adv.opt.saSettings.iter -column 5 -row 0 -sticky nswe
    grid $dopt.adv.opt.saSettings.expLbl -column 6 -row 0 -sticky nswe
    grid $dopt.adv.opt.saSettings.exp -column 7 -row 0 -sticky nswe
    grid $dopt.adv.sep2 -column 0 -row 3 -sticky we -pady 5
    grid $dopt.adv.run -column 0 -row 4 -sticky nswe
    grid $dopt.adv.run.lbl -column 0 -row 0 -columnspan 2 -sticky nswe
    grid $dopt.adv.run.debugButton -column 0 -row 1 -sticky nswe
    grid $dopt.adv.run.debugLbl -column 1 -row 1 -sticky nswe -padx "0 10"
    grid $dopt.adv.run.buildScriptButton -column 2 -row 1 -sticky nswe
    grid $dopt.adv.run.buildScriptLbl -column 3 -row 1 -sticky nswe -padx "0 10"
    # writeEnComps is not as useful with addition of Viz. Results
    #grid $dopt.adv.run.writeEnCompsButton -column 4 -row 1 -sticky nswe
    #grid $dopt.adv.run.writeEnCompsLbl -column 5 -row 1 -sticky nswe -padx "0 10"
    grid $dopt.adv.run.outFreqLbl -column 6 -row 1 -sticky nswe
    grid $dopt.adv.run.outFreq -column 7 -row 1 -sticky nswe -padx "0 10"
    grid $dopt.adv.run.keepMMTraj -column 8 -row 1 -sticky nswe
    grid $dopt.adv.run.keepMMTrajLbl -column 9 -row 1 -sticky nswe

    # RESULTS
    # -------
    # build the results section heading
    ttk::labelframe $dopt.results -labelanchor nw -padding $labelFrameInternalPadding
    ttk::label $dopt.results.lblWidget -text "$downPoint Visualize Results" -anchor w -font TkDefaultFont
    $dopt.results configure -labelwidget $dopt.results.lblWidget
    ttk::label $dopt.resultsPlaceHolder -text "$rightPoint Visualize Results" -anchor w -font TkDefaultFont

    # set mouse click bindings to expand/contract
    bind $dopt.results.lblWidget <Button-1> {
        grid remove .fftk_gui.hlf.nb.dihopt.results
        grid .fftk_gui.hlf.nb.dihopt.resultsPlaceHolder
        grid rowconfigure .fftk_gui.hlf.nb.dihopt 6 -weight 0
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }
    bind $dopt.resultsPlaceHolder <Button-1> {
        grid remove .fftk_gui.hlf.nb.dihopt.resultsPlaceHolder
        grid .fftk_gui.hlf.nb.dihopt.results
        grid rowconfigure .fftk_gui.hlf.nb.dihopt 6 -weight 1
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }

    # grid the results section heading
    grid $dopt.results -column 0 -row 6 -sticky nswe -padx $labelFramePadX -pady $labelFramePadY
    grid columnconfigure $dopt.results 0 -weight 1
    grid rowconfigure $dopt.results 2 -weight 1
    grid remove $dopt.results
    grid $dopt.resultsPlaceHolder -column 0 -row 6 -sticky nswe -padx $placeHolderPadX -pady $placeHolderPadY

    # PREAMBLE
    # --------
    # build the preamble Section
    ttk::frame $dopt.results.preamble
    ttk::label $dopt.results.preamble.lbl -text "Reference Data -- " -anchor w
    ttk::label $dopt.results.preamble.qmeLbl -text "QME:" -anchor w
    ttk::label $dopt.results.preamble.qmeStatusLbl -textvariable ::ForceFieldToolKit::gui::doptQMEStatus -anchor w
    ttk::label $dopt.results.preamble.mmeLbl -text "MMEi:" -anchor w
    ttk::label $dopt.results.preamble.mmeStatusLbl -textvariable ::ForceFieldToolKit::gui::doptMMEStatus -anchor w
    ttk::label $dopt.results.preamble.dihAllLbl -text "dihAll:" -anchor w
    ttk::label $dopt.results.preamble.dihAllStatusLbl -textvariable ::ForceFieldToolKit::gui::doptDihAllStatus -anchor w

    # grid the preamble Section
    grid $dopt.results.preamble -column 0 -row 0 -sticky nswe -padx "10 0"
    grid $dopt.results.preamble.lbl -column 0 -row 0 -sticky nswe
    grid $dopt.results.preamble.qmeLbl -column 1 -row 0 -sticky nswe
    grid $dopt.results.preamble.qmeStatusLbl -column 2 -row 0 -sticky nswe
    grid $dopt.results.preamble.mmeLbl -column 3 -row 0 -sticky nswe
    grid $dopt.results.preamble.mmeStatusLbl -column 4 -row 0 -sticky nswe
    grid $dopt.results.preamble.dihAllLbl -column 5 -row 0 -sticky nswe
    grid $dopt.results.preamble.dihAllStatusLbl -column 6 -row 0 -sticky nswe

    # build/grid separator
    ttk::separator $dopt.results.sep1 -orient horizontal
    grid $dopt.results.sep1 -column 0 -row 1 -sticky nswe -padx $hsepPadX -pady $hsepPadY

    # DATA
    # ----
    # build the results data section
    ttk::frame $dopt.results.data
    ttk::label $dopt.results.data.dsetLbl -text "Data Set" -anchor center
    ttk::label $dopt.results.data.rmseLbl -text "RMSE" -anchor center
    ttk::label $dopt.results.data.colorLbl -text "Plot Color" -anchor center
    ttk::treeview $dopt.results.data.tv -selectmode extended -yscrollcommand "$dopt.results.data.scroll set"
        $dopt.results.data.tv configure -column {dset rmse color enData outPar} -displaycolumns {dset rmse color} -show {} -height 5
        $dopt.results.data.tv heading dset -text "dset" -anchor center
        $dopt.results.data.tv heading rmse -text "RMSE" -anchor center
        $dopt.results.data.tv heading color -text "Plot Color" -anchor center
        $dopt.results.data.tv column dset -width 100 -stretch 0 -anchor center
        $dopt.results.data.tv column rmse -width 100 -stretch 0 -anchor center
        $dopt.results.data.tv column color -width 100 -stretch 0 -anchor center
    ttk::scrollbar $dopt.results.data.scroll -orient vertical -command "$dopt.results.data.tv yview"
    bind $dopt.results.data.tv <KeyPress-Escape> { .fftk_gui.hlf.nb.dihopt.results.data.tv selection remove [.fftk_gui.hlf.nb.dihopt.results.data.tv children {}] }

    ttk::label $dopt.results.data.editColorLbl -text "Set Data Color:" -anchor w
    ttk::menubutton $dopt.results.data.editColor -direction below -menu $dopt.results.data.editColor.menu -textvariable ::ForceFieldToolKit::gui::doptEditColor -width 12
    menu $dopt.results.data.editColor.menu -tearoff no
        $dopt.results.data.editColor.menu add command -label "blue" -command { set ::ForceFieldToolKit::gui::doptEditColor "blue"; ::ForceFieldToolKit::gui::doptSetColor }
        $dopt.results.data.editColor.menu add command -label "green" -command { set ::ForceFieldToolKit::gui::doptEditColor "green"; ::ForceFieldToolKit::gui::doptSetColor }
        #$dopt.results.data.editColor.menu add command -label "red" -command { set ::ForceFieldToolKit::gui::doptEditColor "red"; ::ForceFieldToolKit::gui::doptSetColor }
        $dopt.results.data.editColor.menu add command -label "cyan" -command { set ::ForceFieldToolKit::gui::doptEditColor "cyan"; ::ForceFieldToolKit::gui::doptSetColor }
        $dopt.results.data.editColor.menu add command -label "magenta" -command { set ::ForceFieldToolKit::gui::doptEditColor "magenta"; ::ForceFieldToolKit::gui::doptSetColor }
        $dopt.results.data.editColor.menu add command -label "orange" -command { set ::ForceFieldToolKit::gui::doptEditColor "orange"; ::ForceFieldToolKit::gui::doptSetColor }
        $dopt.results.data.editColor.menu add command -label "purple" -command { set ::ForceFieldToolKit::gui::doptEditColor "purple"; ::ForceFieldToolKit::gui::doptSetColor }
        $dopt.results.data.editColor.menu add command -label "yellow" -command { set ::ForceFieldToolKit::gui::doptEditColor "yellow"; ::ForceFieldToolKit::gui::doptSetColor }

    ttk::button $dopt.results.data.plot -text "Plot Selected" \
        -command {
            # simple validation
            if { [llength $::ForceFieldToolKit::DihOpt::EnQM] == 0 || [llength $::ForceFieldToolKit::DihOpt::EnMM] == 0 } { tk_messageBox -type ok -icon warning -message "Action halted on error!" -detail "No data loaded."; return }
            # aggregate the datasets
            set datasets {}; set colorsets {}; set legend {}
            if { $::ForceFieldToolKit::gui::doptPlotQME } {
                lappend datasets $::ForceFieldToolKit::DihOpt::EnQM
                lappend colorsets black
                lappend legend QME
            }
            if { $::ForceFieldToolKit::gui::doptPlotMME } {
                lappend datasets $::ForceFieldToolKit::DihOpt::EnMM
                lappend colorsets red
                lappend legend MMEi
            }
            foreach item2plot [.fftk_gui.hlf.nb.dihopt.results.data.tv selection] {
                lappend datasets [.fftk_gui.hlf.nb.dihopt.results.data.tv set $item2plot enData]
                lappend colorsets [.fftk_gui.hlf.nb.dihopt.results.data.tv set $item2plot color]
                lappend legend [.fftk_gui.hlf.nb.dihopt.results.data.tv set $item2plot dset]
            }
            # plot the datasets
            ::ForceFieldToolKit::gui::doptBuildPlotWin
            ::ForceFieldToolKit::gui::doptPlotData $datasets $colorsets $legend
            unset datasets
            unset colorsets
            unset legend
        }

    ttk::frame $dopt.results.data.refdata
    ttk::checkbutton $dopt.results.data.refdata.qmePlotCheckbox -offvalue 0 -onvalue 1 -variable ::ForceFieldToolKit::gui::doptPlotQME
    ttk::label $dopt.results.data.refdata.qmePlotLbl -text "Include QME" -anchor w
    ttk::checkbutton $dopt.results.data.refdata.mmePlotCheckbox -offvalue 0 -onvalue 1 -variable ::ForceFieldToolKit::gui::doptPlotMME
    ttk::label $dopt.results.data.refdata.mmePlotLbl -text "Include MMEi" -anchor w

    ttk::separator $dopt.results.data.sep1 -orient horizontal
    ttk::frame $dopt.results.data.remove
    ttk::button $dopt.results.data.remove.delete -text "Delete" -command { .fftk_gui.hlf.nb.dihopt.results.data.tv delete [.fftk_gui.hlf.nb.dihopt.results.data.tv selection] }
    ttk::button $dopt.results.data.remove.clear -text "Clear" -command { .fftk_gui.hlf.nb.dihopt.results.data.tv delete [.fftk_gui.hlf.nb.dihopt.results.data.tv children {}] }

    ttk::separator $dopt.results.data.sep2 -orient horizontal
    ttk::frame $dopt.results.data.io
    ttk::button $dopt.results.data.io.import -text "Import From LOG" \
        -command {
            set tempfile [tk_getOpenFile -title "Select A Dihedral Optimization LOG File" -filetypes $::ForceFieldToolKit::gui::logType]
            if {![string eq $tempfile ""]} {
                ::ForceFieldToolKit::gui::doptLogParser $tempfile
                ::ForceFieldToolKit::gui::consoleMessage "Dihedral optimization data read from file"
            }
        }

    ttk::button $dopt.results.data.io.write -text "Write Selected to LOG" \
        -command {
            foreach itemID [.fftk_gui.hlf.nb.dihopt.results.data.tv selection] {
                set values [.fftk_gui.hlf.nb.dihopt.results.data.tv item $itemID -values]
                set basename [lindex $values 0]
                set rmse [lindex $values 1]
                set mmef [lindex $values 3]
                set parData [lindex $values 4]
                set filename [tk_getSaveFile -title "Save Dataset ($basename) to LOG As..." -initialfile "DihOptRefine.${basename}.log" -filetypes $::ForceFieldToolKit::gui::logType -defaultextension {.log}]
                ::ForceFieldToolKit::gui::doptLogWriter $filename $rmse $mmef $parData
                unset values basename rmse mmef parData filename
                ::ForceFieldToolKit::gui::consoleMessage "Dihedral optimization data written to file"
            }
        }

    ttk::button $dopt.results.data.io.setRefitInp -text "Set As Refit Input" \
        -command {
            # clear the parSet box
            .fftk_gui.hlf.nb.dihopt.refine.parSet.tv delete [.fftk_gui.hlf.nb.dihopt.refine.parSet.tv children {}]
            # copy the parameters over to the parSet box
            set parList [.fftk_gui.hlf.nb.dihopt.results.data.tv set [.fftk_gui.hlf.nb.dihopt.results.data.tv selection] outPar]
            foreach ele $parList {
                set typedef [lrange $ele 0 3]
                set k [lindex $ele 4]
                set mult [lindex $ele 5]
                set delta [lindex $ele 6]
                if { [lindex $ele 7] == 1} {
                   set lock "yes"
                } else {
                   set lock "no"
                }
                .fftk_gui.hlf.nb.dihopt.refine.parSet.tv insert {} end -values [list $typedef $k $mult $delta $lock]
            }

        }

    # grid results data section
    grid $dopt.results.data -column 0 -row 2 -sticky nswe
    grid columnconfigure $dopt.results.data 0 -weight 0 -minsize 100
    grid columnconfigure $dopt.results.data 1 -weight 0 -minsize 100
    grid columnconfigure $dopt.results.data 2 -weight 0 -minsize 100
    grid columnconfigure $dopt.results.data 5 -weight 1
    grid rowconfigure $dopt.results.data {1 2 3 5} -uniform rt1
    grid rowconfigure $dopt.results.data 6 -weight 1

    grid $dopt.results.data.dsetLbl -column 0 -row 0 -sticky nswe
    grid $dopt.results.data.rmseLbl -column 1 -row 0 -sticky nswe
    grid $dopt.results.data.colorLbl -column 2 -row 0 -sticky nswe
    grid $dopt.results.data.tv -column 0 -row 1 -columnspan 3 -rowspan 6 -sticky nswe
    grid $dopt.results.data.scroll -column 3 -row 1 -rowspan 6 -sticky nswe

    grid $dopt.results.data.editColorLbl -column 4 -row 1 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $dopt.results.data.editColor -column 4 -row 2 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $dopt.results.data.plot -column 4 -row 3 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY

    grid $dopt.results.data.refdata -column 4 -row 4 -sticky nswe -padx 4 -pady "5 0"
    grid $dopt.results.data.refdata.qmePlotCheckbox -column 0 -row 0 -sticky nswe
    grid $dopt.results.data.refdata.qmePlotLbl -column 1 -row 0 -sticky nswe
    grid $dopt.results.data.refdata.mmePlotCheckbox -column 2 -row 0 -sticky nswe -padx "5 0"
    grid $dopt.results.data.refdata.mmePlotLbl -column 3 -row 0 -sticky nswe

    grid $dopt.results.data.sep1 -column 4 -row 5 -columnspan 1 -sticky nswe -padx $hsepPadX -pady $hsepPadY
    grid $dopt.results.data.remove -column 4 -row 6 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid columnconfigure $dopt.results.data.remove {0 1} -weight 1
    grid $dopt.results.data.remove.delete -column 0 -row 0 -sticky nswe
    grid $dopt.results.data.remove.clear -column 1 -row 0 -sticky nswe

    grid $dopt.results.data.sep2 -column 0 -row 7 -columnspan 5 -sticky nswe -padx $hsepPadX -pady $hsepPadY
    grid $dopt.results.data.io -column 0 -row 8 -columnspan 5 -sticky nswe
    grid columnconfigure $dopt.results.data.io {0 1 2} -weight 1
    grid $dopt.results.data.io.import -column 0 -row 0 -sticky nswe -padx $hbuttonPadX -pady $hbuttonPadY
    grid $dopt.results.data.io.write -column 1 -row 0 -sticky nswe -padx $hbuttonPadX -pady $hbuttonPadY
    grid $dopt.results.data.io.setRefitInp -column 2 -row 0 -sticky nswe -padx $hbuttonPadX -pady $hbuttonPadY


    # REFINE
    # ------
    # build the refine section heading
    ttk::labelframe $dopt.refine -labelanchor nw -padding $labelFrameInternalPadding
    ttk::label $dopt.refine.lblWidget -text "$downPoint Refine" -anchor w -font TkDefaultFont
    $dopt.refine configure -labelwidget $dopt.refine.lblWidget
    ttk::label $dopt.refinePlaceHolder -text "$rightPoint Refine" -anchor w -font TkDefaultFont

    # set mouse click bindings to expand/contract
    bind $dopt.refine.lblWidget <Button-1> {
        grid remove .fftk_gui.hlf.nb.dihopt.refine
        grid .fftk_gui.hlf.nb.dihopt.refinePlaceHolder
        grid rowconfigure .fftk_gui.hlf.nb.dihopt 7 -weight 0
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }

    bind $dopt.refinePlaceHolder <Button-1> {
        grid remove .fftk_gui.hlf.nb.dihopt.refinePlaceHolder
        grid .fftk_gui.hlf.nb.dihopt.refine
        grid rowconfigure .fftk_gui.hlf.nb.dihopt 7 -weight 1
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }

    # grid the refine section heading
    grid $dopt.refine -column 0 -row 7 -sticky nswe -padx $labelFramePadX -pady $labelFramePadY
    grid columnconfigure $dopt.refine 0 -weight 1
    grid rowconfigure $dopt.refine 2 -weight 1
    grid remove $dopt.refine
    grid $dopt.refinePlaceHolder -column 0 -row 7 -sticky nswe -padx $placeHolderPadX -pady $placeHolderPadY

    # build the refine section
    ttk::label $dopt.refine.lbl -text "Modify Dihedral Parameters for Refitting/Refinement" -anchor w
    ttk::separator $dopt.refine.sep1 -orient horizontal

    # grid the refine top section
    grid $dopt.refine.lbl -column 0 -row 0 -sticky nswe
    grid $dopt.refine.sep1 -column 0 -row 1 -sticky nswe -padx $hsepPadX -pady $hsepPadY

    # build the refine parSet section
    ttk::frame $dopt.refine.parSet
    ttk::label $dopt.refine.parSet.typeDefLbl -text "Dihedral Type Definition" -anchor w
    ttk::label $dopt.refine.parSet.fcLbl -text "Force Constant (k)" -anchor center
    ttk::label $dopt.refine.parSet.multLbl -text "Periodicity (n)" -anchor center
    ttk::label $dopt.refine.parSet.deltaLbl -text "Phase Shift (\u03B4)" -anchor center
    ttk::label $dopt.refine.parSet.lockPhaseLbl -text "Lock Phase?" -anchor center
    ttk::treeview $dopt.refine.parSet.tv -selectmode browse -yscroll "$dopt.refine.parSet.scroll set"
        $dopt.refine.parSet.tv configure -column {def fc mult delta lock} -show {} -height 3
        $dopt.refine.parSet.tv heading def -text "Dihdedral Type Definition" -anchor w
        $dopt.refine.parSet.tv heading fc -text "Force Constant (k)" -anchor center
        $dopt.refine.parSet.tv heading mult -text "Periodicity (n)" -anchor center
        $dopt.refine.parSet.tv heading delta -text "Phase Shift (d)" -anchor center
        $dopt.refine.parSet.tv heading lock -text "Lock Phase?" -anchor center
        $dopt.refine.parSet.tv column def -width 150 -stretch 1 -anchor w
        $dopt.refine.parSet.tv column fc -width 100 -stretch 0 -anchor center
        $dopt.refine.parSet.tv column mult -width 100 -stretch 0 -anchor center
        $dopt.refine.parSet.tv column delta -width 100 -stretch 0 -anchor center
        $dopt.refine.parSet.tv column lock -width 100 -stretch 0 -anchor center
    ttk::scrollbar $dopt.refine.parSet.scroll -orient vertical -command "$dopt.refine.parSet.tv yview"

    # setup the binding to copy the selected TV item data to the edit boxes
    bind $dopt.refine.parSet.tv <<TreeviewSelect>> {
        set editData [.fftk_gui.hlf.nb.dihopt.refine.parSet.tv item [.fftk_gui.hlf.nb.dihopt.refine.parSet.tv selection] -values]
        set ::ForceFieldToolKit::gui::doptRefineEditDef [lindex $editData 0]
        set ::ForceFieldToolKit::gui::doptRefineEditFC [lindex $editData 1]
        set ::ForceFieldToolKit::gui::doptRefineEditMult [lindex $editData 2]
        set ::ForceFieldToolKit::gui::doptRefineEditDelta [lindex $editData 3]
        set ::ForceFieldToolKit::gui::doptRefineEditLock [lindex $editData 4]
    }

    ttk::button $dopt.refine.parSet.duplicate -text "Duplicate" -width 8 \
        -command {
            set currID [.fftk_gui.hlf.nb.dihopt.refine.parSet.tv selection]
            set currIndex [.fftk_gui.hlf.nb.dihopt.refine.parSet.tv index $currID]
            set currValues [.fftk_gui.hlf.nb.dihopt.refine.parSet.tv item $currID -values]
            .fftk_gui.hlf.nb.dihopt.refine.parSet.tv insert {} [expr {$currIndex+1}] -values $currValues
            unset currID currIndex currValues
        }
    ttk::frame $dopt.refine.parSet.move
    ttk::button $dopt.refine.parSet.move.up -text "$upArrow" -width 1 \
        -command {
            # ID of current
            set currentID [.fftk_gui.hlf.nb.dihopt.refine.parSet.tv selection]
            # ID of previous
            if {[set previousID [.fftk_gui.hlf.nb.dihopt.refine.parSet.tv prev $currentID ]] ne ""} {
                # Index of previous
                set previousIndex [.fftk_gui.hlf.nb.dihopt.refine.parSet.tv index $previousID]
                # Move ahead of previous
                .fftk_gui.hlf.nb.dihopt.refine.parSet.tv move $currentID {} $previousIndex
                unset previousIndex
            }
            unset currentID previousID
        }
     ttk::button $dopt.refine.parSet.move.down -text "$downArrow" -width 1 \
        -command {
            # ID of current
            set currentID [.fftk_gui.hlf.nb.dihopt.refine.parSet.tv selection]
            # ID of Next
            if {[set previousID [.fftk_gui.hlf.nb.dihopt.refine.parSet.tv next $currentID ]] ne ""} {
                # Index of Next
                set previousIndex [.fftk_gui.hlf.nb.dihopt.refine.parSet.tv index $previousID]
                # Move below next
                .fftk_gui.hlf.nb.dihopt.refine.parSet.tv move $currentID {} $previousIndex
                unset previousIndex
            }
            unset currentID previousID
        }
    ttk::separator $dopt.refine.parSet.sep -orient horizontal
    ttk::button $dopt.refine.parSet.resetK -text "Reset all Ks" \
        -command {
            foreach item [.fftk_gui.hlf.nb.dihopt.refine.parSet.tv children {}] {
                .fftk_gui.hlf.nb.dihopt.refine.parSet.tv set $item fc 0.0
            }
        }
    ttk::button $dopt.refine.parSet.delete -text "Delete" \
        -command {
            .fftk_gui.hlf.nb.dihopt.refine.parSet.tv delete [.fftk_gui.hlf.nb.dihopt.refine.parSet.tv selection]
            set ::ForceFieldToolKit::gui::doptRefineEditDef {}
            set ::ForceFieldToolKit::gui::doptRefineEditFC {}
            set ::ForceFieldToolKit::gui::doptRefineEditMult {}
            set ::ForceFieldToolKit::gui::doptRefineEditDelta {}
            set ::ForceFieldToolKit::gui::doptRefineEditLock {}
        }

    ttk::label $dopt.refine.parSet.editLbl -text "Edit Entry" -anchor w
    ttk::entry $dopt.refine.parSet.editDef -textvariable ::ForceFieldToolKit::gui::doptRefineEditDef -justify left
    ttk::entry $dopt.refine.parSet.editFC -textvariable ::ForceFieldToolKit::gui::doptRefineEditFC -justify center -width 1
    ttk::menubutton $dopt.refine.parSet.editMult -direction below -menu $dopt.refine.parSet.editMult.menu -textvariable ::ForceFieldToolKit::gui::doptRefineEditMult -width 1
    menu $dopt.refine.parSet.editMult.menu -tearoff no
        $dopt.refine.parSet.editMult.menu add command -label "1" -command { set ::ForceFieldToolKit::gui::doptRefineEditMult 1 }
        $dopt.refine.parSet.editMult.menu add command -label "2" -command { set ::ForceFieldToolKit::gui::doptRefineEditMult 2 }
        $dopt.refine.parSet.editMult.menu add command -label "3" -command { set ::ForceFieldToolKit::gui::doptRefineEditMult 3 }
        $dopt.refine.parSet.editMult.menu add command -label "4" -command { set ::ForceFieldToolKit::gui::doptRefineEditMult 4 }
        $dopt.refine.parSet.editMult.menu add command -label "6" -command { set ::ForceFieldToolKit::gui::doptRefineEditMult 6 }

    ttk::menubutton $dopt.refine.parSet.editDelta -direction below -menu $dopt.refine.parSet.editDelta.menu -textvariable ::ForceFieldToolKit::gui::doptRefineEditDelta -width 5
    menu $dopt.refine.parSet.editDelta.menu -tearoff no
        $dopt.refine.parSet.editDelta.menu add command -label "0" -command { set ::ForceFieldToolKit::gui::doptRefineEditDelta "0.00" }
        $dopt.refine.parSet.editDelta.menu add command -label "180" -command { set ::ForceFieldToolKit::gui::doptRefineEditDelta "180.00" }

    ttk::menubutton $dopt.refine.parSet.editLockPhase -direction below -menu $dopt.refine.parSet.editLockPhase.menu -textvariable ::ForceFieldToolKit::gui::doptRefineEditLock -width 2
    menu $dopt.refine.parSet.editLockPhase.menu -tearoff no
        $dopt.refine.parSet.editLockPhase.menu add command -label "no" -command { set ::ForceFieldToolKit::gui::doptRefineEditLock "no" }
        $dopt.refine.parSet.editLockPhase.menu add command -label "yes" -command { set ::ForceFieldToolKit::gui::doptRefineEditLock "yes" }

    ttk::frame $dopt.refine.parSet.editButtons
    ttk::button $dopt.refine.parSet.editButtons.accept -text "$accept" -width 1 \
        -command {
            .fftk_gui.hlf.nb.dihopt.refine.parSet.tv item [.fftk_gui.hlf.nb.dihopt.refine.parSet.tv selection] \
            -values [list $::ForceFieldToolKit::gui::doptRefineEditDef $::ForceFieldToolKit::gui::doptRefineEditFC $::ForceFieldToolKit::gui::doptRefineEditMult $::ForceFieldToolKit::gui::doptRefineEditDelta $::ForceFieldToolKit::gui::doptRefineEditLock]
        }
    ttk::button $dopt.refine.parSet.editButtons.cancel -text "$cancel" -width 1 \
        -command {
            set editData [.fftk_gui.hlf.nb.dihopt.refine.parSet.tv item [.fftk_gui.hlf.nb.dihopt.refine.parSet.tv selection] -values]
            set ::ForceFieldToolKit::gui::doptRefineEditDef [lindex $editData 0]
            set ::ForceFieldToolKit::gui::doptRefineEditFC [lindex $editData 1]
            set ::ForceFieldToolKit::gui::doptRefineEditMult [lindex $editData 2]
            set ::ForceFieldToolKit::gui::doptRefineEditDelta [lindex $editData 3]
            set ::ForceFieldToolKit::gui::doptRefineEditLock [lindex $editData 4]
        }


    # grid the refine parSet section
    grid $dopt.refine.parSet -column 0 -row 2 -sticky nswe
    grid columnconfigure $dopt.refine.parSet 0 -weight 1 -minsize 150
    grid columnconfigure $dopt.refine.parSet {1 2 3 4} -weight 0 -minsize 100
    grid rowconfigure $dopt.refine.parSet {1 2 4 5} -uniform rt1
    grid rowconfigure $dopt.refine.parSet 6 -weight 1

    grid $dopt.refine.parSet.typeDefLbl -column 0 -row 0 -sticky nwse
    grid $dopt.refine.parSet.fcLbl -column 1 -row 0 -sticky nswe
    grid $dopt.refine.parSet.multLbl -column 2 -row 0 -sticky nswe
    grid $dopt.refine.parSet.deltaLbl -column 3 -row 0 -sticky nswe
    grid $dopt.refine.parSet.lockPhaseLbl -column 4 -row 0 -sticky nswe
    grid $dopt.refine.parSet.tv -column 0 -row 1 -columnspan 5 -rowspan 6 -sticky nswe
    grid $dopt.refine.parSet.scroll -column 5 -row 1 -rowspan 6 -sticky nswe

    grid $dopt.refine.parSet.duplicate -column 6 -row 1 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $dopt.refine.parSet.move -column 6 -row 2 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid columnconfigure $dopt.refine.parSet.move {0 1} -weight 1
    grid $dopt.refine.parSet.move.up -column 0 -row 0 -sticky nswe
    grid $dopt.refine.parSet.move.down -column 1 -row 0 -sticky nswe
    grid $dopt.refine.parSet.sep -column 6 -row 3 -sticky we -padx $hsepPadX -pady $hsepPadY
    grid $dopt.refine.parSet.resetK -column 6 -row 4 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $dopt.refine.parSet.delete -column 6 -row 5 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY

    grid $dopt.refine.parSet.editLbl -column 0 -row 7 -sticky nswe
    grid $dopt.refine.parSet.editDef -column 0 -row 8 -sticky nswe
    grid $dopt.refine.parSet.editFC -column 1 -row 8 -sticky nswe -padx 10
    grid $dopt.refine.parSet.editMult -column 2 -row 8 -sticky nswe -padx 24
    grid $dopt.refine.parSet.editDelta -column 3 -row 8 -sticky nswe -padx 10
    grid $dopt.refine.parSet.editLockPhase -column 4 -row 8 -sticky nswe -padx 10
    grid $dopt.refine.parSet.editButtons -column 6 -row 8 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid columnconfigure $dopt.refine.parSet.editButtons {0 1} -weight 1
    grid $dopt.refine.parSet.editButtons.accept -column 0 -row 0 -sticky nswe
    grid $dopt.refine.parSet.editButtons.cancel -column 1 -row 0 -sticky nswe

    # build/grid a separator for refine section
    ttk::separator $dopt.refine.sep2 -orient horizontal
    grid $dopt.refine.sep2 -column 0 -row 3 -sticky nswe -pady 5

    # build the refine refitting parameters section
    ttk::frame $dopt.refine.optSettings
    ttk::label $dopt.refine.optSettings.kmaxLbl -text "Kmax:" -anchor w
    ttk::entry $dopt.refine.optSettings.kmax -textvariable ::ForceFieldToolKit::DihOpt::refineKmax -width 8 -justify center
    ttk::label $dopt.refine.optSettings.cutoffLbl -text "Cutoff:" -anchor w
    ttk::entry $dopt.refine.optSettings.cutoff -textvariable ::ForceFieldToolKit::DihOpt::refineCutoff -width 8 -justify center
    ttk::label $dopt.refine.optSettings.tolLbl -text "Tol:" -anchor w
    ttk::entry $dopt.refine.optSettings.tol -textvariable ::ForceFieldToolKit::DihOpt::refineTol -width 8 -justify center
    ttk::label $dopt.refine.optSettings.modeLbl -text "Mode:" -anchor w
    ttk::menubutton $dopt.refine.optSettings.mode -direction below -menu $dopt.refine.optSettings.mode.menu -textvariable ::ForceFieldToolKit::DihOpt::refineMode -width 16
    menu $dopt.refine.optSettings.mode.menu -tearoff no
        $dopt.refine.optSettings.mode.menu add command -label "downhill" \
            -command {
                set ::ForceFieldToolKit::DihOpt::refineMode downhill
                grid remove .fftk_gui.hlf.nb.dihopt.refine.optSettings.saSettings
            }
        $dopt.refine.optSettings.mode.menu add command -label "simulated annealing" \
            -command {
                set ::ForceFieldToolKit::DihOpt::refineMode {simulated annealing}
                grid .fftk_gui.hlf.nb.dihopt.refine.optSettings.saSettings
            }
    ttk::frame $dopt.refine.optSettings.saSettings
    ttk::label $dopt.refine.optSettings.saSettings.tempLbl -text "T:" -anchor center -width 3
    ttk::entry $dopt.refine.optSettings.saSettings.temp -textvariable ::ForceFieldToolKit::DihOpt::refinesaT -width 8 -justify center
    ttk::label $dopt.refine.optSettings.saSettings.tStepsLbl -text "Tsteps:" -anchor w
    ttk::entry $dopt.refine.optSettings.saSettings.tSteps -textvariable ::ForceFieldToolKit::DihOpt::refinesaTSteps -width 8 -justify center
    ttk::label $dopt.refine.optSettings.saSettings.iterLbl -text "Iter:" -anchor w
    ttk::entry $dopt.refine.optSettings.saSettings.iter -textvariable ::ForceFieldToolKit::DihOpt::refinesaIter -width 8 -justify center
    ttk::label $dopt.refine.optSettings.saSettings.expLbl -text "TExp:" -anchor w
    ttk::entry $dopt.refine.optSettings.saSettings.exp -textvariable ::ForceFieldToolKit::DihOpt::refinesaTExp -width 8 -justify center

    # grid the refine refitting parameters section
    grid $dopt.refine.optSettings -column 0 -row 4 -sticky nswe
    grid columnconfigure $dopt.refine.optSettings 6 -weight 1
    grid $dopt.refine.optSettings.kmaxLbl -column 0 -row 0 -sticky nswe
    grid $dopt.refine.optSettings.kmax -column 1 -row 0 -sticky nswe
    grid $dopt.refine.optSettings.cutoffLbl -column 2 -row 0 -sticky nswe
    grid $dopt.refine.optSettings.cutoff -column 3 -row 0 -sticky nswe
    grid $dopt.refine.optSettings.tolLbl -column 4 -row 0 -sticky nswe
    grid $dopt.refine.optSettings.tol -column 5 -row 0 -sticky nswe
    grid $dopt.refine.optSettings.modeLbl -column 0 -row 1 -sticky nswe
    grid $dopt.refine.optSettings.mode -column 1 -row 1 -columnspan 3 -sticky nswe
    grid $dopt.refine.optSettings.saSettings -column 4 -row 1 -columnspan 3 -sticky we
    grid $dopt.refine.optSettings.saSettings.tempLbl -column 0 -row 0 -sticky nswe
    grid $dopt.refine.optSettings.saSettings.temp -column 1 -row 0 -sticky nswe
    grid $dopt.refine.optSettings.saSettings.tStepsLbl -column 2 -row 0 -sticky nswe
    grid $dopt.refine.optSettings.saSettings.tSteps -column 3 -row 0 -sticky nswe
    grid $dopt.refine.optSettings.saSettings.iterLbl -column 4 -row 0 -sticky nswe
    grid $dopt.refine.optSettings.saSettings.iter -column 5 -row 0 -sticky nswe
    grid $dopt.refine.optSettings.saSettings.expLbl -column 6 -row 0 -sticky nswe
    grid $dopt.refine.optSettings.saSettings.exp -column 7 -row 0 -sticky nswe

    # build/grid a separator for refine section
    ttk::separator $dopt.refine.sep3 -orient horizontal
    grid $dopt.refine.sep3 -column 0 -row 5 -sticky nswe -pady 5

    # build/grid a refine run section
    ttk::frame $dopt.refine.run
    ttk::button $dopt.refine.run.runManualRefine -text "Compute MM PES from Refinement Parameters" -command { ::ForceFieldToolKit::gui::doptRunManualRefine }
    ttk::button $dopt.refine.run.runRefine -text "Run Refitting/Refinement" -command {
#            if {$::ForceFieldToolKit::qmSoft eq "ORCA"} {
#              ::ForceFieldToolKit::ORCA::tempORCAmessage
#              return
#            }
	    ::ForceFieldToolKit::gui::doptRunRefine
	    }

    # grid the refinement run section
    grid $dopt.refine.run -column 0 -row 6 -sticky nswe
    grid columnconfigure $dopt.refine.run 1 -weight 1
    grid rowconfigure $dopt.refine.run 1 -minsize 50 -weight 0
    grid rowconfigure $dopt.refine.run 2 -minsize 50 -weight 0
    grid $dopt.refine.run.runManualRefine -column 0 -row 1 -columnspan 2 -sticky nswe -padx $buttonRunPadX -pady $buttonRunPadY
    grid $dopt.refine.run.runRefine -column 0 -row 2 -columnspan 2 -sticky nswe -padx $buttonRunPadX -pady $buttonRunPadY

    # build/grid a separator
    ttk::separator $dopt.sep1 -orient horizontal
    grid $dopt.sep1 -column 0 -row 9 -sticky we -padx $hsepPadX -pady $hsepPadY

    # RUN
    # ---
    # build the run section
    ttk::frame $dopt.status
    ttk::label $dopt.status.lbl -text "Status:" -anchor w
    ttk::label $dopt.status.txt -textvariable ::ForceFieldToolKit::gui::doptStatus -anchor w
    ttk::button $dopt.runOpt -text "Run Optimization" -command {
#            if {$::ForceFieldToolKit::qmSoft eq "ORCA"} {
#              ::ForceFieldToolKit::ORCA::tempORCAmessage
#              return
#            }
	    ::ForceFieldToolKit::gui::doptRunOpt
	    }

    # grid the run section
    grid $dopt.status -column 0 -row 10 -sticky nswe -padx $buttonRunPadX -pady $buttonRunPadY
    grid columnconfigure $dopt.status 1 -weight 1
    grid $dopt.status.lbl -column 0 -row 0 -sticky nswe
    grid $dopt.status.txt -column 1 -row 0 -sticky nswe

    grid $dopt.runOpt -column 0 -row 11 -sticky nswe -padx $buttonRunPadX -pady $buttonRunPadY
    grid rowconfigure $dopt 11 -minsize 50 -weight 0



    #---------------------------------------------------#
    #  ImprOpt     tab                                   #
    #---------------------------------------------------#

    # build the frame, add it to the notebook
    ttk::frame $w.hlf.nb.impropt -width 500 -height 500
    $w.hlf.nb add $w.hlf.nb.impropt -text "Opt. Impropers"
    # allow frame to change width with content
    grid columnconfigure $w.hlf.nb.impropt 0 -weight 1

    # for shorter naming convention
    set imopt $w.hlf.nb.impropt

    # Dih/Impr Optimization Selector
    # -----------------------------------
    ttk::frame      $imopt.dihImprSelector
    ttk::label      $imopt.dihImprSelector.lbl      -text "Dihedrals/Impropers: " -anchor w -font TkDefaultFont
    ttk::menubutton $imopt.dihImprSelector.selector -direction below -menu $w.dihImprSelectorMenu -textvariable ::ForceFieldToolKit::gui::dihImprMethod -width 15
    ttk::separator  $imopt.dihImprSelectorSep -orient horizontal

    grid $imopt.dihImprSelector    -column 0 -row 0 -sticky nswe -padx $hsepPadX -pady $labelFramePadY
    grid $imopt.dihImprSelector.lbl      -column 0 -row 0 -sticky nwe
    grid $imopt.dihImprSelector.selector -column 1 -row 0 -sticky nsw
    grid $imopt.dihImprSelectorSep -column 0 -row 1 -sticky nwe -padx $hsepPadX -pady $hsepPadY

    grid columnconfigure $imopt.dihImprSelector 1 -minsize 15 -weight 1


    # INPUT
    # -----
    # build input labels
    ttk::labelframe $imopt.input -labelanchor nw -padding $labelFrameInternalPadding
    ttk::label $imopt.input.lblWidget -text "$downPoint Input" -anchor w -font TkDefaultFont
    $imopt.input configure -labelwidget $imopt.input.lblWidget

    ttk::label $imopt.inputPlaceHolder -text "$rightPoint Input" -anchor w -font TkDefaultFont

    # set mouse click bindings to expand/contract input settings
    bind $imopt.input.lblWidget <Button-1> {
        grid remove .fftk_gui.hlf.nb.impropt.input
        grid .fftk_gui.hlf.nb.impropt.inputPlaceHolder
        grid rowconfigure .fftk_gui.hlf.nb.impropt 2 -weight 0
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }
    bind $imopt.inputPlaceHolder <Button-1> {
        grid remove .fftk_gui.hlf.nb.impropt.inputPlaceHolder
        grid .fftk_gui.hlf.nb.impropt.input
        grid rowconfigure .fftk_gui.hlf.nb.impropt 2 -weight 1
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }

    # build input elements
    ttk::label $imopt.input.psfPathLbl -text "PSF File:" -anchor center
    ttk::entry $imopt.input.psfPath -textvariable ::ForceFieldToolKit::Configuration::chargeOptPSF
    ttk::button $imopt.input.psfPathBrowse -text "Browse" \
        -command {
            set tempfile [tk_getOpenFile -title "Select A PSF File" -filetypes $::ForceFieldToolKit::gui::psfType]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::Configuration::chargeOptPSF $tempfile }
        }
    ttk::label $imopt.input.pdbPathLbl -text "PDB File:" -anchor center
    ttk::entry $imopt.input.pdbPath -textvariable ::ForceFieldToolKit::Configuration::geomOptPDB
    ttk::button $imopt.input.pdbPathBrowse -text "Browse" \
        -command {
            set tempfile [tk_getOpenFile -title "Select a PDB File" -filetypes $::ForceFieldToolKit::gui::pdbType]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::Configuration::geomOptPDB $tempfile }
        }

    ttk::separator $imopt.input.sep1 -orient horizontal

    ttk::label $imopt.input.parFilesLbl -text "Parameter Files (both pre-defined and in-progress)" -anchor w
    ttk::treeview $imopt.input.parFiles -selectmode browse -yscrollcommand "$imopt.input.parFilesScroll set"
        $imopt.input.parFiles configure -columns {filename} -show {} -height 3
        $imopt.input.parFiles column filename -stretch 1
    ttk::scrollbar $imopt.input.parFilesScroll -orient vertical -command "$imopt.input.parFiles yview"
    ttk::button $imopt.input.add -text "Add" \
        -command {
            set tempfiles [tk_getOpenFile -title "Select Parameter File(s)" -multiple 1 -filetypes $::ForceFieldToolKit::gui::parType]
            foreach tempfile $tempfiles {
                if {![string eq $tempfile ""]} { .fftk_gui.hlf.nb.impropt.input.parFiles insert {} end -values [list $tempfile] }
            }
        }
    ttk::button $imopt.input.delete -text "Delete" -command { .fftk_gui.hlf.nb.impropt.input.parFiles delete [.fftk_gui.hlf.nb.impropt.input.parFiles selection] }
    ttk::button $imopt.input.clear -text "Clear" -command { .fftk_gui.hlf.nb.impropt.input.parFiles delete [.fftk_gui.hlf.nb.impropt.input.parFiles children {}] }

    ttk::separator $imopt.input.sep2 -orient horizontal

    ttk::label $imopt.input.namdbinLbl -text "NAMD binary:" -anchor center
    ttk::entry $imopt.input.namdbin -textvariable ::ForceFieldToolKit::Configuration::namdBin
    ttk::button $imopt.input.namdbinBrowse -text "Browse" \
        -command {
            set tempfile [tk_getOpenFile -title "Select NAMD Bin File" -filetypes $::ForceFieldToolKit::gui::allType]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::Configuration::namdBin $tempfile }
        }
    ttk::label $imopt.input.logLbl -text "Output LOG:" -anchor center
    ttk::entry $imopt.input.log -textvariable ::ForceFieldToolKit::DihOpt::outFileNameImpr
    ttk::button $imopt.input.logSaveAs -text "SaveAs" \
        -command {
            set tempfile [tk_getSaveFile -title "Save Dihedral Optimization LOG File As..." -initialfile "$::ForceFieldToolKit::DihOpt::outFileNameImpr" -filetypes $::ForceFieldToolKit::gui::logType -defaultextension {.log}]
            if {![string eq $tempfile ""]} { set ::ForceFieldToolKit::DihOpt::outFileNameImpr $tempfile }
        }

    # grid input elements
    grid $imopt.input -column 0 -row 2 -sticky nswe -padx $labelFramePadX -pady $labelFramePadY
    grid columnconfigure $imopt.input 1 -weight 1
    grid rowconfigure $imopt.input {0 1 4 5 6 9} -uniform rt1
    grid rowconfigure $imopt.input 7 -weight 1
    grid remove $imopt.input
    grid $imopt.inputPlaceHolder -column 0 -row 2 -sticky nswe -padx $placeHolderPadX -pady $placeHolderPadY
    grid $imopt.input.psfPathLbl -column 0 -row 0 -sticky nswe
    grid $imopt.input.psfPath -column 1 -row 0 -columnspan 2 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $imopt.input.psfPathBrowse -column 3 -row 0 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $imopt.input.pdbPathLbl -column 0 -row 1 -sticky nswe
    grid $imopt.input.pdbPath -column 1 -row 1 -columnspan 2 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $imopt.input.pdbPathBrowse -column 3 -row 1 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $imopt.input.sep1 -column 0 -row 2 -columnspan 4 -sticky we -padx $hsepPadX -pady $hsepPadY
    grid $imopt.input.parFilesLbl -column 0 -row 3 -sticky nswe -columnspan 2
    grid $imopt.input.parFiles -column 0 -row 4 -columnspan 2 -rowspan 4 -sticky nswe
    grid $imopt.input.parFilesScroll -column 2 -row 4 -rowspan 4 -sticky nswe
    grid $imopt.input.add -column 3 -row 4 -sticky nwe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $imopt.input.delete -column 3 -row 5 -sticky nwe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $imopt.input.clear -column 3 -row 6 -sticky nwe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $imopt.input.sep2 -column 0 -row 8 -columnspan 4 -sticky we -padx $hsepPadX -pady $hsepPadY
    grid $imopt.input.namdbinLbl -column 0 -row 9 -sticky nswe
    grid $imopt.input.namdbin -column 1 -row 9 -columnspan 2 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $imopt.input.namdbinBrowse -column 3 -row 9 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $imopt.input.logLbl -column 0 -row 10 -sticky nswe
    grid $imopt.input.log -column 1 -row 10 -columnspan 2 -sticky nswe -padx $entryPadX -pady $entryPadY
    grid $imopt.input.logSaveAs -column 3 -row 10 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY

    # QM TARGET DATA
    # --------------
    # build QM target data labels
    ttk::labelframe $imopt.qmt -labelanchor nw -padding $labelFrameInternalPadding
    ttk::label $imopt.qmt.lblWidget -text "$downPoint QM Target Data" -anchor w -font TkDefaultFont
    $imopt.qmt configure -labelwidget $imopt.qmt.lblWidget
    ttk::label $imopt.qmtPlaceHolder -text "$rightPoint QM Target Data" -anchor w -font TkDefaultFont

    # set mouse click bindings to expand/contract qmt settings
    bind $imopt.qmt.lblWidget <Button-1> {
        grid remove .fftk_gui.hlf.nb.impropt.qmt
        grid .fftk_gui.hlf.nb.impropt.qmtPlaceHolder
        grid rowconfigure .fftk_gui.hlf.nb.impropt 3 -weight 0
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }
    bind $imopt.qmtPlaceHolder <Button-1> {
        grid remove .fftk_gui.hlf.nb.impropt.qmtPlaceHolder
        grid .fftk_gui.hlf.nb.impropt.qmt
        grid rowconfigure .fftk_gui.hlf.nb.impropt 3 -weight 1
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }

    # build QM target data (Log files) elements
    # QM selector
    ttk::menubutton $imopt.qmt.selector -direction below -menu $w.menuQMSelector -textvariable ::ForceFieldToolKit::qmSoft -width 15

    ttk::label $imopt.qmt.lbl -text "QM Dihedral Scan Output Files" -anchor w
    ttk::treeview $imopt.qmt.tv -selectmode browse -yscrollcommand "$imopt.qmt.scroll set"
        $imopt.qmt.tv configure -columns {filename} -show {} -height 5
        $imopt.qmt.tv column filename -stretch 1
    ttk::scrollbar $imopt.qmt.scroll -orient vertical -command "$imopt.qmt.tv yview"
    ttk::button $imopt.qmt.add -text "Add" \
        -command {
            set tempfiles [tk_getOpenFile -title "Select Output File(s) for Dihedral Scan Calculations" -multiple 1 -filetypes $::ForceFieldToolKit::gui::AllLogType]
            foreach tempfile $tempfiles {
                if {![string eq $tempfile ""]} { .fftk_gui.hlf.nb.impropt.qmt.tv insert {} end -values $tempfile }
            }
        }
    ttk::button $imopt.qmt.moveUp -text "Move $upArrow" \
        -command {
            # ID of current
            set currentID [.fftk_gui.hlf.nb.impropt.qmt.tv selection]
            # ID of previous
            if {[set previousID [.fftk_gui.hlf.nb.impropt.qmt.tv prev $currentID ]] ne ""} {
                # Index of previous
                set previousIndex [.fftk_gui.hlf.nb.impropt.qmt.tv index $previousID]
                # Move ahead of previous
                .fftk_gui.hlf.nb.impropt.qmt.tv move $currentID {} $previousIndex
                unset previousIndex
            }
            unset currentID previousID
        }
    ttk::button $imopt.qmt.moveDown -text "Move $downArrow" \
        -command {
            # ID of current
            set currentID [.fftk_gui.hlf.nb.impropt.qmt.tv selection]
            # ID of Next
            if {[set previousID [.fftk_gui.hlf.nb.impropt.qmt.tv next $currentID ]] ne ""} {
                # Index of Next
                set previousIndex [.fftk_gui.hlf.nb.impropt.qmt.tv index $previousID]
                # Move below next
                .fftk_gui.hlf.nb.impropt.qmt.tv move $currentID {} $previousIndex
                unset previousIndex
            }
            unset currentID previousID
        }
    ttk::separator $imopt.qmt.sep1 -orient horizontal
    ttk::button $imopt.qmt.delete -text "Delete" -command { .fftk_gui.hlf.nb.impropt.qmt.tv delete [.fftk_gui.hlf.nb.impropt.qmt.tv selection] }
    ttk::button $imopt.qmt.clear -text "Clear" -command { .fftk_gui.hlf.nb.impropt.qmt.tv delete [.fftk_gui.hlf.nb.impropt.qmt.tv children {}] }

    # grid the QM target data elements
    grid $imopt.qmt -column 0 -row 3 -sticky nswe -padx $labelFramePadX -pady $labelFramePadY
    grid columnconfigure $imopt.qmt 0 -weight 1
    grid rowconfigure $imopt.qmt 7 -weight 1

    grid remove $imopt.qmt
    grid $imopt.qmtPlaceHolder -column 0 -row 3 -sticky nswe -padx $placeHolderPadX -pady $placeHolderPadY

    grid $imopt.qmt.selector -column 0 -row 0 -columnspan 5 -sticky nsw

    grid $imopt.qmt.lbl -column 0 -row 2 -sticky nswe
    grid $imopt.qmt.tv -column 0 -row 2 -rowspan 7 -sticky nswe
    grid $imopt.qmt.scroll -column 1 -row 2 -rowspan 7 -sticky nswe
    grid $imopt.qmt.add -column 2 -row 2 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $imopt.qmt.moveUp -column 2 -row 3 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $imopt.qmt.moveDown -column 2 -row 4 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $imopt.qmt.sep1 -column 2 -row 5 -sticky nswe -padx $hsepPadX -pady $hsepPadY
    grid $imopt.qmt.delete -column 2 -row 6 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $imopt.qmt.clear -column 2 -row 7 -sticky nwe -padx $vbuttonPadX -pady $vbuttonPadY


    # IMPROPER PARAMETER SETTINGS
    # ----------------------
    # build the parameter settings labels
    ttk::labelframe $imopt.parSet -labelanchor nw -padding $labelFrameInternalPadding
    ttk::label $imopt.parSet.lblWidget -text "$downPoint Improper Parameter Settings" -anchor w -font TkDefaultFont
    $imopt.parSet configure -labelwidget $imopt.parSet.lblWidget
    ttk::label $imopt.parSetPlaceHolder -text "$rightPoint Improper Parameter Settings" -anchor w -font TkDefaultFont

    # set mouse click bindings to expand/contract
    bind $imopt.parSet.lblWidget <Button-1> {
        grid remove .fftk_gui.hlf.nb.impropt.parSet
        grid .fftk_gui.hlf.nb.impropt.parSetPlaceHolder
        grid rowconfigure .fftk_gui.hlf.nb.impropt 4 -weight 0
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }
    bind $imopt.parSetPlaceHolder <Button-1> {
        grid remove .fftk_gui.hlf.nb.impropt.parSetPlaceHolder
        grid .fftk_gui.hlf.nb.impropt.parSet
        grid rowconfigure .fftk_gui.hlf.nb.impropt 4 -weight 1
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }

    # build the parameter settings elements
    ttk::label $imopt.parSet.typeDefLbl -text "Improper Type Definition" -anchor w
    ttk::label $imopt.parSet.fcLbl -text "Force Constant (k)" -anchor center
    ttk::treeview $imopt.parSet.tv -selectmode browse -yscrollcommand "$imopt.parSet.scroll set"
        $imopt.parSet.tv configure -column {def fc} -show {} -height 5
        $imopt.parSet.tv heading def -text "Improper Type Definition" -anchor w
        $imopt.parSet.tv heading fc -text "Force Constant (k)" -anchor center
        $imopt.parSet.tv column def -width 150 -stretch 1 -anchor w
        $imopt.parSet.tv column fc -width 100 -stretch 0 -anchor center
    ttk::scrollbar $imopt.parSet.scroll -orient vertical -command "$imopt.parSet.tv yview"

    # setup the binding to copy the selected TV item data to the edit boxes
    bind $imopt.parSet.tv <<TreeviewSelect>> {
        set editData [.fftk_gui.hlf.nb.impropt.parSet.tv item [.fftk_gui.hlf.nb.impropt.parSet.tv selection] -values]
        set ::ForceFieldToolKit::gui::imoptEditDef [lindex $editData 0]
        set ::ForceFieldToolKit::gui::imoptEditFC [lindex $editData 1]
    }

    ttk::button $imopt.parSet.import -text "Read from PAR" \
        -command {
            set tempfile [tk_getOpenFile -title "Select A Parameter File" -filetypes $::ForceFieldToolKit::gui::parType]
            if {![string eq $tempfile ""]} {
                # read the parameter file and grab the impropers section
                set imprParamsIn [lindex [::ForceFieldToolKit::SharedFcns::readParFile $tempfile] 3]
                # parse out indv dihedral parameter data and add a new entry to the TV
                foreach impr $imprParamsIn {
                    .fftk_gui.hlf.nb.impropt.parSet.tv insert {} end -values [list [lindex $impr 0] [lindex $impr 1 0]]
                }
                # clean up
                unset imprParamsIn
            }
        }
    ttk::button $imopt.parSet.add -text "Add" -command { .fftk_gui.hlf.nb.impropt.parSet.tv insert {} end -values [list "AT1 AT2 AT3 AT4" "0.0"] }
    ttk::button $imopt.parSet.duplicate -text "Duplicate" -width 8 \
        -command {
            set currID [.fftk_gui.hlf.nb.impropt.parSet.tv selection]
            set currIndex [.fftk_gui.hlf.nb.impropt.parSet.tv index $currID]
            set currValues [.fftk_gui.hlf.nb.impropt.parSet.tv item $currID -values]
            .fftk_gui.hlf.nb.impropt.parSet.tv insert {} [expr {$currIndex+1}] -values $currValues
            unset currID currIndex currValues
        }
    ttk::frame $imopt.parSet.move
    ttk::button $imopt.parSet.move.up -text "$upArrow" -width 1 \
        -command {
            # ID of current
            set currentID [.fftk_gui.hlf.nb.impropt.parSet.tv selection]
            # ID of previous
            if {[set previousID [.fftk_gui.hlf.nb.impropt.parSet.tv prev $currentID ]] ne ""} {
                # Index of previous
                set previousIndex [.fftk_gui.hlf.nb.impropt.parSet.tv index $previousID]
                # Move ahead of previous
                .fftk_gui.hlf.nb.impropt.parSet.tv move $currentID {} $previousIndex
                unset previousIndex
            }
            unset currentID previousID
        }
    ttk::button $imopt.parSet.move.down -text "$downArrow" -width 1 \
        -command {
            # ID of current
            set currentID [.fftk_gui.hlf.nb.impropt.parSet.tv selection]
            # ID of Next
            if {[set previousID [.fftk_gui.hlf.nb.impropt.parSet.tv next $currentID ]] ne ""} {
                # Index of Next
                set previousIndex [.fftk_gui.hlf.nb.impropt.parSet.tv index $previousID]
                # Move below next
                .fftk_gui.hlf.nb.impropt.parSet.tv move $currentID {} $previousIndex
                unset previousIndex
            }
            unset currentID previousID
        }

    ttk::separator $imopt.parSet.sep -orient horizontal

    ttk::button $imopt.parSet.delete -text "Delete" \
        -command {
            .fftk_gui.hlf.nb.impropt.parSet.tv delete [.fftk_gui.hlf.nb.impropt.parSet.tv selection]
            set ::ForceFieldToolKit::gui::imoptEditDef {}
            set ::ForceFieldToolKit::gui::imoptEditFC {}
        }
    ttk::button $imopt.parSet.clear -text "Clear" \
        -command {
            .fftk_gui.hlf.nb.impropt.parSet.tv delete [.fftk_gui.hlf.nb.impropt.parSet.tv children {}]
            set ::ForceFieldToolKit::gui::imoptEditDef {}
            set ::ForceFieldToolKit::gui::imoptEditFC {}
        }

    ttk::label $imopt.parSet.editLbl -text "Edit Entry" -anchor w
    ttk::entry $imopt.parSet.editDef -textvariable ::ForceFieldToolKit::gui::imoptEditDef -justify left
    ttk::entry $imopt.parSet.editFC -textvariable ::ForceFieldToolKit::gui::imoptEditFC -justify center -width 1

    ttk::frame $imopt.parSet.editButtons
    ttk::button $imopt.parSet.editButtons.accept -text "$accept" -width 1 \
        -command {
            .fftk_gui.hlf.nb.impropt.parSet.tv item [.fftk_gui.hlf.nb.impropt.parSet.tv selection] \
            -values [list $::ForceFieldToolKit::gui::imoptEditDef $::ForceFieldToolKit::gui::imoptEditFC]
        }
    ttk::button $imopt.parSet.editButtons.cancel -text "$cancel" -width 1 \
        -command {
            set editData [.fftk_gui.hlf.nb.impropt.parSet.tv item [.fftk_gui.hlf.nb.impropt.parSet.tv selection] -values]
            set ::ForceFieldToolKit::gui::imoptEditDef [lindex $editData 0]
            set ::ForceFieldToolKit::gui::imoptEditFC [lindex $editData 1]
        }

    # grid the parameter settings elements
    grid $imopt.parSet -column 0 -row 4 -sticky nswe -padx $labelFramePadX -pady $labelFramePadY
    grid columnconfigure $imopt.parSet 0 -weight 1 -minsize 100
    grid columnconfigure $imopt.parSet 1 -weight 0 -minsize 100

    grid rowconfigure $imopt.parSet {1 3 4 6} -uniform rt1
    grid rowconfigure $imopt.parSet 8 -weight 1
    grid remove $imopt.parSet

    grid $imopt.parSetPlaceHolder -column 0 -row 4 -sticky nswe -padx $placeHolderPadX -pady $placeHolderPadY

    grid $imopt.parSet.typeDefLbl -column 0 -row 0 -sticky nwse
    grid $imopt.parSet.fcLbl -column 1 -row 0 -sticky nswe
    grid $imopt.parSet.tv -column 0 -row 1 -columnspan 5 -rowspan 8 -sticky nswe
    grid $imopt.parSet.scroll -column 5 -row 1 -rowspan 8 -sticky nswe

    grid $imopt.parSet.import -column 6 -row 1 -sticky nwse -padx $vbuttonPadX -pady $vbuttonPadY
    grid $imopt.parSet.add -column 6 -row 2 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $imopt.parSet.duplicate -column 6 -row 3 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $imopt.parSet.move -column 6 -row 4 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid columnconfigure $imopt.parSet.move {0 1} -weight 1
    grid $imopt.parSet.move.up -column 0 -row 0 -sticky nswe
    grid $imopt.parSet.move.down -column 1 -row 0 -sticky nswe
    grid $imopt.parSet.sep -column 6 -row 5 -sticky we -padx $hsepPadX -pady $hsepPadY

    grid $imopt.parSet.delete -column 6 -row 6 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $imopt.parSet.clear -column 6 -row 7 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $imopt.parSet.editLbl -column 0 -row 9 -sticky nswe
    grid $imopt.parSet.editDef -column 0 -row 10 -sticky nswe -pady "0 5"
    grid $imopt.parSet.editFC -column 1 -row 10 -sticky nswe -pady "0 5" -padx 10
    grid $imopt.parSet.editButtons -column 6 -row 10 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid columnconfigure $imopt.parSet.editButtons 0 -weight 1
    grid columnconfigure $imopt.parSet.editButtons 1 -weight 1
    grid $imopt.parSet.editButtons.accept -column 0 -row 0 -sticky nswe
    grid $imopt.parSet.editButtons.cancel -column 1 -row 0 -sticky nswe


    # ADVANCED SETTINGS
    # -----------------
    # build the advanced settings labels
    ttk::labelframe $imopt.adv -labelanchor nw -padding $labelFrameInternalPadding
    ttk::label $imopt.adv.lblWidget -text "$downPoint Advanced Settings" -anchor w -font TkDefaultFont
    $imopt.adv configure -labelwidget $imopt.adv.lblWidget
    ttk::label $imopt.advPlaceHolder -text "$rightPoint Advanced Settings" -anchor w -font TkDefaultFont

    # set mouse click bindings to expand/contract
    bind $imopt.adv.lblWidget <Button-1> {
        grid remove .fftk_gui.hlf.nb.impropt.adv
        grid .fftk_gui.hlf.nb.impropt.advPlaceHolder
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }
    bind $imopt.advPlaceHolder <Button-1> {
        grid remove .fftk_gui.hlf.nb.impropt.advPlaceHolder
        grid .fftk_gui.hlf.nb.impropt.adv
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }

    # build advanced settings section
    ttk::frame $imopt.adv.dih
    ttk::label $imopt.adv.dih.lbl -text "Improper Settings" -anchor w
    ttk::label $imopt.adv.dih.kmaxLbl -text "Kmax:" -anchor w
    ttk::entry $imopt.adv.dih.kmax -textvariable ::ForceFieldToolKit::DihOpt::kmaxImpr -width 8 -justify center
    ttk::label $imopt.adv.dih.eCutoffLbl -text "Energy Cutoff" -anchor w
    ttk::entry $imopt.adv.dih.eCutoff -textvariable ::ForceFieldToolKit::DihOpt::cutoff -width 8 -justify center
    ttk::separator $imopt.adv.sep1 -orient horizontal
    ttk::frame $imopt.adv.opt
    ttk::label $imopt.adv.opt.lbl -text "Optimize Settings" -anchor w
    ttk::label $imopt.adv.opt.tolLbl -text "Tolerance:" -anchor w
    ttk::entry $imopt.adv.opt.tol -textvariable ::ForceFieldToolKit::DihOpt::tol -width 6 -justify center
    ttk::label $imopt.adv.opt.modeLbl -text "Mode:" -anchor w
    ttk::menubutton $imopt.adv.opt.mode -direction below -menu $imopt.adv.opt.mode.menu -textvariable ::ForceFieldToolKit::DihOpt::modeImpr -width 16
    menu $imopt.adv.opt.mode.menu -tearoff no
        $imopt.adv.opt.mode.menu add command -label "downhill" \
            -command {
                set ::ForceFieldToolKit::DihOpt::modeImpr downhill
                grid remove .fftk_gui.hlf.nb.impropt.adv.opt.saSettings
            }
        $imopt.adv.opt.mode.menu add command -label "simulated annealing" \
            -command {
                set ::ForceFieldToolKit::DihOpt::modeImpr {simulated annealing}
                grid .fftk_gui.hlf.nb.impropt.adv.opt.saSettings
            }
    ttk::frame $imopt.adv.opt.saSettings
    ttk::label $imopt.adv.opt.saSettings.tempLbl -text "T:" -anchor w
    ttk::entry $imopt.adv.opt.saSettings.temp -textvariable ::ForceFieldToolKit::DihOpt::saT -width 8 -justify center
    ttk::label $imopt.adv.opt.saSettings.tStepsLbl -text "Tsteps:" -anchor w
    ttk::entry $imopt.adv.opt.saSettings.tSteps -textvariable ::ForceFieldToolKit::DihOpt::saTSteps -width 8 -justify center
    ttk::label $imopt.adv.opt.saSettings.iterLbl -text "Iter:" -anchor w
    ttk::entry $imopt.adv.opt.saSettings.iter -textvariable ::ForceFieldToolKit::DihOpt::saIter -width 8 -justify center
    ttk::label $imopt.adv.opt.saSettings.expLbl -text "TExp:" -anchor w
    ttk::entry $imopt.adv.opt.saSettings.exp -textvariable ::ForceFieldToolKit::DihOpt::saTExp -width 8 -justify center
    ttk::separator $imopt.adv.sep2 -orient horizontal
    ttk::frame $imopt.adv.run
    ttk::label $imopt.adv.run.lbl -text "Run Settings" -anchor w
    ttk::checkbutton $imopt.adv.run.debugButton -offvalue 0 -onvalue 1 -variable ::ForceFieldToolKit::DihOpt::debug
    ttk::label $imopt.adv.run.debugLbl -text "Write debugging log" -anchor w
    ttk::checkbutton $imopt.adv.run.buildScriptButton -offvalue 0 -onvalue 1 -variable ::ForceFieldToolKit::gui::imoptBuildScript
    ttk::label $imopt.adv.run.buildScriptLbl -text "Build run script"
    ttk::checkbutton $imopt.adv.run.writeEnCompsButton -offvalue 0 -onvalue 1 -variable ::ForceFieldToolKit::DihOpt::WriteEnComps
    ttk::label $imopt.adv.run.writeEnCompsLbl -text "Write Energy Comparison Data"
    ttk::label $imopt.adv.run.outFreqLbl -text "Output Freq.:" -anchor w
    ttk::entry $imopt.adv.run.outFreq -textvariable ::ForceFieldToolKit::DihOpt::outFreq -width 8 -justify center
    ttk::checkbutton $imopt.adv.run.keepMMTraj -offvalue 0 -onvalue 1 -variable ::ForceFieldToolKit::DihOpt::keepMMTraj
    ttk::label $imopt.adv.run.keepMMTrajLbl -text "Save MM Traj." -anchor w

    # grid advanced settings section
    grid $imopt.adv -column 0 -row 5 -sticky nswe -padx $labelFramePadX -pady $labelFramePadY
    grid columnconfigure $imopt.adv 0 -weight 1
    grid remove $imopt.adv
    grid $imopt.advPlaceHolder -column 0 -row 5 -sticky nswe -padx $placeHolderPadX -pady $placeHolderPadY
    grid $imopt.adv.dih -column 0 -row 0 -sticky nswe
    grid $imopt.adv.dih.lbl -column 0 -row 0 -columnspan 2 -sticky nswe
    grid $imopt.adv.dih.kmaxLbl -column 0 -row 1 -sticky nswe
    grid $imopt.adv.dih.kmax -column 1 -row 1 -sticky nswe
    grid $imopt.adv.dih.eCutoffLbl -column 2 -row 1 -sticky nswe
    grid $imopt.adv.dih.eCutoff -column 3 -row 1 -sticky nswe
    grid $imopt.adv.sep1 -column 0 -row 1 -sticky we -pady 5
    grid $imopt.adv.opt -column 0 -row 2 -sticky nswe
    grid $imopt.adv.opt.lbl -column 0 -row 0 -columnspan 3 -sticky nswe
    grid $imopt.adv.opt.tolLbl -column 0 -row 1 -sticky nswe
    grid $imopt.adv.opt.tol -column 1 -row 1 -sticky nsw
    grid $imopt.adv.opt.modeLbl -column 0 -row 2 -sticky nswe
    grid $imopt.adv.opt.mode -column 1 -row 2 -sticky nswe
    grid $imopt.adv.opt.saSettings -column 2 -row 2 -sticky we -padx "5 0"
    grid $imopt.adv.opt.saSettings.tempLbl -column 0 -row 0 -sticky nswe
    grid $imopt.adv.opt.saSettings.temp -column 1 -row 0 -sticky nswe
    grid $imopt.adv.opt.saSettings.tStepsLbl -column 2 -row 0 -sticky nswe
    grid $imopt.adv.opt.saSettings.tSteps -column 3 -row 0 -sticky nswe
    grid $imopt.adv.opt.saSettings.iterLbl -column 4 -row 0 -sticky nswe
    grid $imopt.adv.opt.saSettings.iter -column 5 -row 0 -sticky nswe
    grid $imopt.adv.opt.saSettings.expLbl -column 6 -row 0 -sticky nswe
    grid $imopt.adv.opt.saSettings.exp -column 7 -row 0 -sticky nswe
    grid $imopt.adv.sep2 -column 0 -row 3 -sticky we -pady 5
    grid $imopt.adv.run -column 0 -row 4 -sticky nswe
    grid $imopt.adv.run.lbl -column 0 -row 0 -columnspan 2 -sticky nswe
    grid $imopt.adv.run.debugButton -column 0 -row 1 -sticky nswe
    grid $imopt.adv.run.debugLbl -column 1 -row 1 -sticky nswe -padx "0 10"
    grid $imopt.adv.run.buildScriptButton -column 2 -row 1 -sticky nswe
    grid $imopt.adv.run.buildScriptLbl -column 3 -row 1 -sticky nswe -padx "0 10"
    # writeEnComps is not as useful with addition of Viz. Results
    #grid $imopt.adv.run.writeEnCompsButton -column 4 -row 1 -sticky nswe
    #grid $imopt.adv.run.writeEnCompsLbl -column 5 -row 1 -sticky nswe -padx "0 10"
    grid $imopt.adv.run.outFreqLbl -column 6 -row 1 -sticky nswe
    grid $imopt.adv.run.outFreq -column 7 -row 1 -sticky nswe -padx "0 10"
    grid $imopt.adv.run.keepMMTraj -column 8 -row 1 -sticky nswe
    grid $imopt.adv.run.keepMMTrajLbl -column 9 -row 1 -sticky nswe

    # default is downhill
    grid remove .fftk_gui.hlf.nb.impropt.adv.opt.saSettings


    # RESULTS
    # -------
    # build the results section heading
    ttk::labelframe $imopt.results -labelanchor nw -padding $labelFrameInternalPadding
    ttk::label $imopt.results.lblWidget -text "$downPoint Visualize Results" -anchor w -font TkDefaultFont
    $imopt.results configure -labelwidget $imopt.results.lblWidget
    ttk::label $imopt.resultsPlaceHolder -text "$rightPoint Visualize Results" -anchor w -font TkDefaultFont

    # set mouse click bindings to expand/contract
    bind $imopt.results.lblWidget <Button-1> {
        grid remove .fftk_gui.hlf.nb.impropt.results
        grid .fftk_gui.hlf.nb.impropt.resultsPlaceHolder
        grid rowconfigure .fftk_gui.hlf.nb.impropt 6 -weight 0
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }
    bind $imopt.resultsPlaceHolder <Button-1> {
        grid remove .fftk_gui.hlf.nb.impropt.resultsPlaceHolder
        grid .fftk_gui.hlf.nb.impropt.results
        grid rowconfigure .fftk_gui.hlf.nb.impropt 6 -weight 1
        ::ForceFieldToolKit::gui::resizeToActiveTab
    }

    # grid the results section heading
    grid $imopt.results -column 0 -row 6 -sticky nswe -padx $labelFramePadX -pady $labelFramePadY
    grid columnconfigure $imopt.results 0 -weight 1
    grid rowconfigure $imopt.results 2 -weight 1
    grid remove $imopt.results
    grid $imopt.resultsPlaceHolder -column 0 -row 6 -sticky nswe -padx $placeHolderPadX -pady $placeHolderPadY

    # PREAMBLE
    # --------
    # build the preamble Section
    ttk::frame $imopt.results.preamble
    ttk::label $imopt.results.preamble.lbl -text "Reference Data -- " -anchor w
    ttk::label $imopt.results.preamble.qmeLbl -text "QME:" -anchor w
    ttk::label $imopt.results.preamble.qmeStatusLbl -textvariable ::ForceFieldToolKit::gui::imoptQMEStatus -anchor w
    ttk::label $imopt.results.preamble.mmeLbl -text "MMEi:" -anchor w
    ttk::label $imopt.results.preamble.mmeStatusLbl -textvariable ::ForceFieldToolKit::gui::imoptMMEStatus -anchor w
    ttk::label $imopt.results.preamble.imprAllLbl -text "imprAll:" -anchor w
    ttk::label $imopt.results.preamble.imprAllStatusLbl -textvariable ::ForceFieldToolKit::gui::imoptImprAllStatus -anchor w

    # grid the preamble Section
    grid $imopt.results.preamble -column 0 -row 0 -sticky nswe -padx "10 0"
    grid $imopt.results.preamble.lbl -column 0 -row 0 -sticky nswe
    grid $imopt.results.preamble.qmeLbl -column 1 -row 0 -sticky nswe
    grid $imopt.results.preamble.qmeStatusLbl -column 2 -row 0 -sticky nswe
    grid $imopt.results.preamble.mmeLbl -column 3 -row 0 -sticky nswe
    grid $imopt.results.preamble.mmeStatusLbl -column 4 -row 0 -sticky nswe
    grid $imopt.results.preamble.imprAllLbl -column 5 -row 0 -sticky nswe
    grid $imopt.results.preamble.imprAllStatusLbl -column 6 -row 0 -sticky nswe

    # build/grid separator
    ttk::separator $imopt.results.sep1 -orient horizontal
    grid $imopt.results.sep1 -column 0 -row 1 -sticky nswe -padx $hsepPadX -pady $hsepPadY

    # DATA
    # ----
    # build the results data section
    ttk::frame $imopt.results.data
    ttk::label $imopt.results.data.dsetLbl -text "Data Set" -anchor center
    ttk::label $imopt.results.data.rmseLbl -text "RMSE" -anchor center
    ttk::label $imopt.results.data.colorLbl -text "Plot Color" -anchor center
    ttk::treeview $imopt.results.data.tv -selectmode extended -yscrollcommand "$imopt.results.data.scroll set"
        $imopt.results.data.tv configure -column {dset rmse color enData outPar} -displaycolumns {dset rmse color} -show {} -height 5
        $imopt.results.data.tv heading dset -text "dset" -anchor center
        $imopt.results.data.tv heading rmse -text "RMSE" -anchor center
        $imopt.results.data.tv heading color -text "Plot Color" -anchor center
        $imopt.results.data.tv column dset -width 100 -stretch 0 -anchor center
        $imopt.results.data.tv column rmse -width 100 -stretch 0 -anchor center
        $imopt.results.data.tv column color -width 100 -stretch 0 -anchor center
    ttk::scrollbar $imopt.results.data.scroll -orient vertical -command "$imopt.results.data.tv yview"
    bind $imopt.results.data.tv <KeyPress-Escape> { .fftk_gui.hlf.nb.impropt.results.data.tv selection remove [.fftk_gui.hlf.nb.impropt.results.data.tv children {}] }

    ttk::label $imopt.results.data.editColorLbl -text "Set Data Color:" -anchor w
    ttk::menubutton $imopt.results.data.editColor -direction below -menu $imopt.results.data.editColor.menu -textvariable ::ForceFieldToolKit::gui::imoptEditColor -width 12
    menu $imopt.results.data.editColor.menu -tearoff no
        $imopt.results.data.editColor.menu add command -label "blue" -command { set ::ForceFieldToolKit::gui::imoptEditColor "blue"; ::ForceFieldToolKit::gui::imoptSetColor }
        $imopt.results.data.editColor.menu add command -label "green" -command { set ::ForceFieldToolKit::gui::imoptEditColor "green"; ::ForceFieldToolKit::gui::imoptSetColor }
        #$imopt.results.data.editColor.menu add command -label "red" -command { set ::ForceFieldToolKit::gui::imoptEditColor "red"; ::ForceFieldToolKit::gui::imoptSetColor }
        $imopt.results.data.editColor.menu add command -label "cyan" -command { set ::ForceFieldToolKit::gui::imoptEditColor "cyan"; ::ForceFieldToolKit::gui::imoptSetColor }
        $imopt.results.data.editColor.menu add command -label "magenta" -command { set ::ForceFieldToolKit::gui::imoptEditColor "magenta"; ::ForceFieldToolKit::gui::imoptSetColor }
        $imopt.results.data.editColor.menu add command -label "orange" -command { set ::ForceFieldToolKit::gui::imoptEditColor "orange"; ::ForceFieldToolKit::gui::imoptSetColor }
        $imopt.results.data.editColor.menu add command -label "purple" -command { set ::ForceFieldToolKit::gui::imoptEditColor "purple"; ::ForceFieldToolKit::gui::imoptSetColor }
        $imopt.results.data.editColor.menu add command -label "yellow" -command { set ::ForceFieldToolKit::gui::imoptEditColor "yellow"; ::ForceFieldToolKit::gui::imoptSetColor }

    ttk::button $imopt.results.data.plot -text "Plot Selected" \
        -command {
            # simple validation
            if { [llength $::ForceFieldToolKit::DihOpt::EnQM] == 0 || [llength $::ForceFieldToolKit::DihOpt::EnMM] == 0 } { tk_messageBox -type ok -icon warning -message "Action halted on error!" -detail "No data loaded."; return }
            # aggregate the datasets
            set datasets {}; set colorsets {}; set legend {}
            if { $::ForceFieldToolKit::gui::imoptPlotQME } {
                lappend datasets $::ForceFieldToolKit::DihOpt::EnQM
                lappend colorsets black
                lappend legend QME
            }
            if { $::ForceFieldToolKit::gui::imoptPlotMME } {
                lappend datasets $::ForceFieldToolKit::DihOpt::EnMM
                lappend colorsets red
                lappend legend MMEi
            }
            foreach item2plot [.fftk_gui.hlf.nb.impropt.results.data.tv selection] {
                lappend datasets [.fftk_gui.hlf.nb.impropt.results.data.tv set $item2plot enData]
                lappend colorsets [.fftk_gui.hlf.nb.impropt.results.data.tv set $item2plot color]
                lappend legend [.fftk_gui.hlf.nb.impropt.results.data.tv set $item2plot dset]
            }
            # plot the datasets
            ::ForceFieldToolKit::gui::doptBuildPlotWin
            ::ForceFieldToolKit::gui::doptPlotData $datasets $colorsets $legend
            unset datasets
            unset colorsets
            unset legend
        }

    ttk::frame $imopt.results.data.refdata
    ttk::checkbutton $imopt.results.data.refdata.qmePlotCheckbox -offvalue 0 -onvalue 1 -variable ::ForceFieldToolKit::gui::imoptPlotQME
    ttk::label $imopt.results.data.refdata.qmePlotLbl -text "Include QME" -anchor w
    ttk::checkbutton $imopt.results.data.refdata.mmePlotCheckbox -offvalue 0 -onvalue 1 -variable ::ForceFieldToolKit::gui::imoptPlotMME
    ttk::label $imopt.results.data.refdata.mmePlotLbl -text "Include MMEi" -anchor w

    ttk::separator $imopt.results.data.sep1 -orient horizontal
    ttk::frame $imopt.results.data.remove
    ttk::button $imopt.results.data.remove.delete -text "Delete" -command { .fftk_gui.hlf.nb.impropt.results.data.tv delete [.fftk_gui.hlf.nb.impropt.results.data.tv selection] }
    ttk::button $imopt.results.data.remove.clear -text "Clear" -command { .fftk_gui.hlf.nb.impropt.results.data.tv delete [.fftk_gui.hlf.nb.impropt.results.data.tv children {}] }

    # grid results data section
    grid $imopt.results.data -column 0 -row 2 -sticky nswe
    grid columnconfigure $imopt.results.data 0 -weight 0 -minsize 100
    grid columnconfigure $imopt.results.data 1 -weight 0 -minsize 100
    grid columnconfigure $imopt.results.data 2 -weight 0 -minsize 100
    grid columnconfigure $imopt.results.data 5 -weight 1
    grid rowconfigure $imopt.results.data {1 2 3 5} -uniform rt1
    grid rowconfigure $imopt.results.data 6 -weight 1

    grid $imopt.results.data.dsetLbl -column 0 -row 0 -sticky nswe
    grid $imopt.results.data.rmseLbl -column 1 -row 0 -sticky nswe
    grid $imopt.results.data.colorLbl -column 2 -row 0 -sticky nswe
    grid $imopt.results.data.tv -column 0 -row 1 -columnspan 3 -rowspan 6 -sticky nswe
    grid $imopt.results.data.scroll -column 3 -row 1 -rowspan 6 -sticky nswe

    grid $imopt.results.data.editColorLbl -column 4 -row 1 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $imopt.results.data.editColor -column 4 -row 2 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid $imopt.results.data.plot -column 4 -row 3 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY

    grid $imopt.results.data.refdata -column 4 -row 4 -sticky nswe -padx 4 -pady "5 0"
    grid $imopt.results.data.refdata.qmePlotCheckbox -column 0 -row 0 -sticky nswe
    grid $imopt.results.data.refdata.qmePlotLbl -column 1 -row 0 -sticky nswe
    grid $imopt.results.data.refdata.mmePlotCheckbox -column 2 -row 0 -sticky nswe -padx "5 0"
    grid $imopt.results.data.refdata.mmePlotLbl -column 3 -row 0 -sticky nswe

    grid $imopt.results.data.sep1 -column 4 -row 5 -columnspan 1 -sticky nswe -padx $hsepPadX -pady $hsepPadY
    grid $imopt.results.data.remove -column 4 -row 6 -sticky nswe -padx $vbuttonPadX -pady $vbuttonPadY
    grid columnconfigure $imopt.results.data.remove {0 1} -weight 1
    grid $imopt.results.data.remove.delete -column 0 -row 0 -sticky nswe
    grid $imopt.results.data.remove.clear -column 1 -row 0 -sticky nswe

    # build/grid a separator
    ttk::separator $imopt.sep1 -orient horizontal
    grid $imopt.sep1 -column 0 -row 9 -sticky we -padx $hsepPadX -pady $hsepPadY


    # RUN
    # ---
    # build the run section
    ttk::frame $imopt.status
    ttk::label $imopt.status.lbl -text "Status:" -anchor w
    ttk::label $imopt.status.txt -textvariable ::ForceFieldToolKit::gui::imoptStatus -anchor w
    ttk::button $imopt.runOpt -text "Run Optimization" -command {
#            if {$::ForceFieldToolKit::qmSoft eq "ORCA"} {
#              ::ForceFieldToolKit::ORCA::tempORCAmessage
#              return
#            }
	    ::ForceFieldToolKit::gui::imoptRunOpt
	    }

    # grid the run section
    grid $imopt.status -column 0 -row 10 -sticky nswe -padx $buttonRunPadX -pady $buttonRunPadY
    grid columnconfigure $imopt.status 1 -weight 1
    grid $imopt.status.lbl -column 0 -row 0 -sticky nswe
    grid $imopt.status.txt -column 1 -row 0 -sticky nswe

    grid $imopt.runOpt -column 0 -row 11 -sticky nswe -padx $buttonRunPadX -pady $buttonRunPadY
    grid rowconfigure $imopt 11 -minsize 50 -weight 0

#--------------------------------------------------------------------------

    # By default, hide the impr tabs on startup
    $w.hlf.nb hide $w.hlf.nb.genImprScan
    $w.hlf.nb hide $w.hlf.nb.impropt
    set ::ForceFieldToolKit::gui::dihImprSelectMethod "Dihedral fitting"

#--------------------------------------------------------------------------

    # RESIZE BINDING/ROUTINE
    # add binding to resize the window based on the active tab
    bind .fftk_gui.hlf.nb <<NotebookTabChanged>> { ::ForceFieldToolKit::gui::resizeToActiveTab }

    return $w
}
