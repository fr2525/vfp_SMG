*************************************************************************************************************
*
* Class definition for menu object 
*  
* Methods:
*    InitMenu
*    AddMenuPad 
*    RemoveMenuPad
*    ActivateMenu
*    ActivateSubMenu
*    MPBDisable
*
*************************************************************************************************************
DEFINE CLASS Menu1 as custom
  
   *************************************************************************************************************
   *
   * This Method is initial the Menu
   *
   *************************************************************************************************************
   PROCEDURE InitMenu
      SET SYSMENU TO
      SET SYSMENU AUTOMATIC
   ENDPROC    


      
   *************************************************************************************************************
   *
   * This Method is to add a Menu title to the System menu
   *
   *  oPad  - Specifies the name of the menu title object
   *  cPadName - Specifies the menu title to create. 
   *  cPromptName  - Specifies the text that appears in the menu title.
   *  cKey  -  Specifies an access key or key combination for a menu title
   *
   *************************************************************************************************************
   PROCEDURE AddMenuPad
      LPARAMETER oPad, cPadName, cPromptName, cKey
      This.Addobject(oPad, "sPad", cPadName, cPromptName, cKey) 
   ENDPROC
   
   
      
   *************************************************************************************************************
   *
   * This Method is to activate a menu
   *
   *  oPopup - Specifies the name of the popup object
   *
   ************************************************************************************************************* 
   PROCEDURE ActivateMenu
       LPARAMETER oPopup 
        ON PAD (oPopup.Parent.cPadName) OF _MSYSMENU ACTIVATE POPUP (oPopup.cPopupName)       
   ENDPROC 



   *************************************************************************************************************
   *
   * This Method is to activate a menu when the menu item from the top level menu is chosen
   *
   *  oBar  -  Specifies the name of the bar object
   *  oTopPopup  - Specifies the name of the menu object which the menu item that activates another menu
   *  oSubPopup  - Specifies the object name of the menu to activate when the menu item from the top level menu is 
   *              chosen
   * 
   *************************************************************************************************************   
   PROCEDURE ActivateSubMenu
       LPARAMETER oBar, oTopPopup, oSubPopup
       ON BAR (oBar.nBarnum) of (oTopPopup.cPopupName) ACTIVATE POPUP (oSubPopup.cPopupName)
   ENDPROC
   

   
   *************************************************************************************************************
   *
   * This Method is to refresh the change of the text for the Menu title
   *
   *  oPad  -  Specifies the name of the menu title object when the text is changed
   * 
   *************************************************************************************************************   
   PROCEDURE RefreshPad
     LPARAMETER oPad
   
     IF EMPTY(oPad.cKey)
          DEFINE PAD (oPad.cPadName) OF _MSYSMENU PROMPT (oPad.cPromptPadName) COLOR SCHEME 3
       ELSE
          oPad.cKey = ALLTRIM(oPad.cKey) 
          oPad.cString = "DEFINE PAD " + ALLTRIM(oPad.cPadName)+ " OF _MSYSMENU PROMPT "+ "'"+ALLTRIM(oPad.cPromptPadName)+"'" +;
                    " COLOR SCHEME 3 KEY ALT+"+ oPad.cKey

          cString = oPad.cString
          &cString 
      ENDIF
              
   ENDPROC
   


   *************************************************************************************************************
   *
   * This Method is to enables or disables a menu title, menu bar or menu item 
   * 
   *  oMPBobject  -  Specifies the name of the menu title, menu bar or menu item object  
   *  cMenuOption  - Specifies the value for the menu title, menu bar or menu item to disables or enables
   *                    "Bar" for menu bar     
   *                    "Pad" for menu title
   *                    "Popup" for menu item  
   *
   *  iFlag  - Specifies the value to either disables or enables a menu title, menu bar or menu item
   *              .T. to disables   
   *              .F. to enables 
   *
   *************************************************************************************************************
   PROCEDURE MPBDisable
     LPARAMETER oMPBobject, cMenuOption, iFlag
     
     DO CASE
        CASE UPPER(cMenuOption) = "BAR"
             SET SKIP OF BAR (oMPBobject.nBarNum) OF (oMPBobject.Parent.cPopupName) iFlag
        CASE UPPER(cMenuOption) = "POPUP"
             SET SKIP OF POPUP (oMPBobject.cPopupName) iFlag
        CASE UPPER(cMenuOption) = "PAD"     
             SET SKIP OF PAD (oMPBobject.cPadName) OF _MSYSMENU iFlag  
     ENDCASE 

   ENDPROC
    


   *************************************************************************************************************
   *
   * This Method is to remove a menu title off the system menu
   *  
   *  oPad - Specifies the name of the menu title object
   * 
   *************************************************************************************************************
   PROCEDURE RemoveMenuPad
     LPARAMETER oPad
     
     RELEASE PAD (oPad.cPadName) OF _MSYSMENU
     This.removeobject(oPad.Name)
          
   ENDPROC
   


ENDDEFINE


*************************************************************************************************************
*
* Class definition for menu title object 
*  
* Methods:
*    AddMenuItem
*
*************************************************************************************************************
DEFINE CLASS sPad AS Custom

    cPadName = ""
    cPromptPadName = ""
    cKey = ""
    cString = ""
    
    PROCEDURE Init
       LPARAMETER cPadName, cPromptPadName, cKey
       
       This.cPromptPadName = cPromptPadName
       This.cPadName = cPadname
       
             
       IF EMPTY(cKey)
          DEFINE PAD (This.cPadName) OF _MSYSMENU PROMPT (This.cPromptPadName) COLOR SCHEME 3
       ELSE
          This.cKey = ALLTRIM(cKey) 
          This.cString = "DEFINE PAD " + ALLTRIM(This.cPadName)+ " OF _MSYSMENU PROMPT "+ "'"+ALLTRIM(This.cPromptPadName)+"'" +;
                    " COLOR SCHEME 3 KEY ALT+"+ This.cKey

          cString = This.cString
          &cString
       ENDIF   
         
        
    ENDPROC   



    *************************************************************************************************************
    *
    * This method is to add menu item to the menu title
    *  
    *   oPopup - Specifies the name for the menu item object
    *   cPopupName - Specifies the name for the manu item. This name has to be unique through out the entire menu
    *                object.
    *
    *************************************************************************************************************
    PROCEDURE AddMenuItem 
      LPARAMETER oPopup, cPopupName

      This.Addobject(oPopup, "sPopup",  cPopupName)
    ENDPROC


    PROCEDURE RemoveMenuItem
      LPARAMETER oPopup
  
      RELEASE POPUPS (oPopup.cPopupName)
      This.removeobject(oPopup.Name)

ENDDEFINE



*************************************************************************************************************
*
* Class definition for menu item object 
*  
* Methods:
*    AddMenuBar
*
*************************************************************************************************************
DEFINE CLASS sPopup as custom

   cPopupName=""
    
   PROCEDURE Init
      LPARAMETER cPopupName

      This.cPopupName = cPopupName
      DEFINE POPUP (This.cPopupName) MARGIN RELATIVE SHADOW COLOR SCHEME 4
   ENDPROC   


    *************************************************************************************************************
    *
    * This method is to add menu bar to the menu item
    *  
    *   oBarName - Specifies the name for the menu bar object
    *   nBarNum  - Specifies the menu bar number
    *   cBarPrompt - Specifies the text that appears on the menu bar
    *   cExpr  - Specifies the type of program to run 
    *                "P"  - Procedure file
    *                "E"  - Expression, i.e. Wait Window, MyTest1()
    *
    *   cProgramName - Specifies the prorgam name to run when the menu bar is chosen
    *
    *************************************************************************************************************
    PROCEDURE AddMenuBar
       LPARAMETER oBarname, nBarNum, cBarPrompt, cExpr, cProgramName

       This.AddObject(oBarName, "sbar", this, nBarNum, cBarPrompt, cExpr, cProgramName)   
    ENDPROC



    PROCEDURE RemoveMenuBar
      LPARAMETER oBar
  
      RELEASE BAR (oBar.nBarNum) of (oBar.Parent.cPopupName)
      This.removeobject(oBar.Name)

ENDDEFINE



*************************************************************************************************************
*
* Class definition for menu bar object 
*  
*************************************************************************************************************
DEFINE CLASS sbar as custom

    nBarNum = 0
    cBarPrompt = ""
    cProgramName = ""
    cExpr = ""
    
    PROCEDURE Init
      LPARAMETER oPopupName, nBarNum, cBarPrompt, cExpr, cProgramName
      
      This.nBarNum=nBarNum
      This.cBarPrompt = cBarPrompt
      This.cExpr = cExpr
      This.cProgramName = cProgramName
      
      DEFINE BAR (This.nBarNum) OF (oPopupName.cPopupName) prompt (This.cBarPrompt)
      
      ON SELECTION BAR (This.nBarNum) OF (oPopupName.cPopupName) RunProgram(PROMPT())

    ENDPROC

ENDDEFINE