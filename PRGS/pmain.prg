********************************************************************** 
***
***    Programa : Main.prg (Programa Principal)
*** Descricao   : Programa principal da Aplicacao 
***  Parámetros : 
***       Notas : 
*** Programador : Fabio Reinert
***       Data  : 10 / Outubro /2001
***     Versión : 1.0
***    Historia : * 
***
**********************************************************************
Local lnWinHandle

*--- Limpeza do ambiente
CLEAR
CLEAR ALL

SET CLASSLIB TO reposito ADDITIVE
*** DECLARAMOS A FUNCÃO API PARA LER DOS ARQUIVOS .INI

DECLARE INTEGER GetPrivateProfileString IN WIN32API;
	STRING Seccion,;
	STRING Clave,;
	STRING PorDefecto,;
	STRING @CadenaRetorno,;
	INTEGER longitud,;
	STRING NombreFichero

*** Declaramos as API para a criação do ODBC

DECLARE Integer RegOpenKeyEx IN Win32API ;
	Integer nKey, ;
	String cSubKey,;
	Integer nReserved, ;
	Integer nSamDesired, ;
	Integer @nResult

DECLARE Integer RegQueryValueEx In Win32API ;
	Integer nKey, ;
	String cValueName, ;
	Integer nReserved, ;
	Integer @nType, ;
	String @cData, ;
	Integer @nSizeData

DECLARE Integer RegCloseKey In Win32API ;
	Integer nKey

DECLARE Integer RegDeleteValue In WIN32API ;
	Integer  nKey, ;
	String cValueName

DECLARE Integer RegCreateKeyEx In Win32API ;
	Integer nKey, ;
	String cSubKey, ;
	Integer nReserved, ;
	String cClass, ;
	Integer nOptions,;
	Integer nDesired, ;
	String @cSecurityAttributes, ;
	Integer @nResult, ;
	Integer @nDisposition

DECLARE Integer RegSetValueEx In Win32API ;
	Integer nKey, ;
	String cValueName, ;
	Integer nReserved, ;
	Integer nType, ;
	String cData, ;
	Integer nSizeData

*** Declaro as API para manter ativa a tela de preview do report
	
*DECLARE LONG GetActiveWindow IN USER32

*DECLARE LONG IsWindow IN USER32 LONG hndventana
	
PUBLIC gousuario, goconfig
PUBLIC gDesenv

*--- verifica se o aplicativo está sendo rodado dentro do VFP
* FILE() Verifica se o arquivo existe em disco
* HOME() Retorna o diretorio do 1o. programa executado

IF FILE(HOME()+"VFP.EXE") ;
OR FILE(HOME()+"VFP6.EXE") ;
OR FILE(HOME()+"VFP7.EXE") ; 
OR FILE(HOME()+"VFP8.EXE") ; 
OR FILE(HOME()+"VFP9.EXE") 
   m.gDesenv = .t.
ELSE
   m.gDesenv = .F.
ENDIF

*--> Variavel onde será armazenada a variavel indicadora de nivel de usuario
PUBLIC gNivel
*--> Variavel publica onde será guardado o codigo do operador
PUBLIC m.gOperador 
PUBLIC m.gEmpresa
PUBLIC m.gpalavra
PUBLIC m.gImpresso 
PUBLIC gSenha 
PUBLIC gDivcupom 
PUBLIC gMensa1 
PUBLIC gMensa2 
PUBLIC gDemo

gOperador = "Master"
gDemo = .F.

IF m.gDesenv 
*!*	   ** desabilita as opções de desenvolvimento
*!*	   PUSH MENU _MSYSMENU
*!*	   IF WVISIBLE("project manager")
*!*	      DEACTIVATE WINDOW "project manager"
*!*	   ENDIF   
*!*	   IF WVISIBLE("standard")
*!*	      DEACTIVATE WINDOW "standard"
*!*	   ENDIF       	
*!*	       		   
*!*	   RELEASE WINDOWS "layout",;
*!*	                   "form controls".;
*!*	                   "report controls",;
*!*	                   "form designer",;
*!*	                   "database designer",;
*!*	                   "view designer",;
*!*	                   "query designer",;
*!*	                   "color pallete"
ELSE
   ON SHUTDOWN quit     && sai da aplicação pelo X
ENDIF
   
                         		   
*--- Preparação do ambiente
* Salva configurações

oldFundo = _screen.picture
oldTalk = SET("talk")
oldPath = SET("path")
oldDate = SET("date")
oldDel = SET("Deleted" )
oldCurrency = SET("Currency",1)
oldPoint = SET("point")
oldSeparator = SET("Separator")
oldExclusive = SET("Exclusive" )
oldReprocess = SET("Reprocess")
oldRefresh = SET("refresh")
*olderror = ON("error")

SET TALK OFF
SET NOTIFY OFF
SET CONSOLE OFF
SET DATE TO DMY
SET DELETED ON
SET CURRENCY TO "R$"
SET POINT TO ","
SET SEPARATOR TO "."
SET ENGINEBEHAVIOR 70

SET EXCLUSIVE OFF
SET REPROCESS TO 5
SET REFRESH TO 5

_SCREEN.WindowState = 2

*DO FORM frmsplash

PUBLIC lcdatabase

LOCAL lcPathAtual, lcPathNovo, lcNovo, lcAtual

SET STEP ON 

CLOSE DATABASES

*: Establecemos los path con la creación del objeto configuración:*
goconfig = CREATEOBJECT('configura','smg.ini')
*goConfig.pcini = GETENV("windir") + "dbsMG.INI"

*{ Abertura da base de dados }*
***-> Banco de dados Access
****lcdatabase = goconfig.pdatabasepath  + 'DBSGL.mdb'
*!*	lcPathAtual = goconfig.pdatabasepath
*!*	lcbasenova = goconfig.pbasenovapath   
IF goconfig.pdatabasepath <> ""  
	lcdatabase = pDatabasePath + 'dbsmg.dbc'
	OPEN DATABASE (lcdatabase) SHARED
	SET DATABASE TO (lcdatabase)
ELSE
    gcConnstring = goconfig.pConnection
	gnConexao = SQLStringConnect(gcConnString)
ENDIF

CLEAR

*!*	*** Nos conectamos a la base de datos ....


*OPEN DATABASE (lcdatabase) SHARED

*SET DATABASE TO (lcdatabase)

**--->> Verifica se existem atualizacoes nas tabelas

***--> nConexao = sqlconnect("banco de dados do ms access;dbq=&lcdatabase","","") 

***--> IF nConexao < 1 
***-->    MESSAGEBOX("Erro na conexão ao banco de dados", 16)
***-->    QUIT
***--> ENDIF   
*!*	lcOldPath = SYS(5) + SYS(2003)  && Guarda o path atual

*!*	SET DEFAULT TO (lcbasenova)

*!*	gnDbcnumber = ADIR(gaDatabase, '*.dbf')  && Create array

*!*	CLEAR
*!*	FOR nCount = 1 TO gnDbcnumber  && Loop for number of databases
*!*	    lcTabela = gaDatabase(nCount,1)
*!*	    IF FILE(lcPathAtual + lctabela)
*!*	       USE dbsmg!&lctabela
*!*	       COPY TO lcPathAtual + "temp.dbf" 
*!*	       REMOVE TABLE dbsmg!&lctabela DELETE
*!*	    ENDIF
*!*	    lcnovo = lcbasenova + lctabela
*!*	    lcAtual = lcPathAtual + lctabela   
*!*	    COPY FILE (lcnovo) TO (lcAtual)
*!*	    ADD TABLE &lctabela
*!*	    USE (lctabela)
*!*	    IF FILE(TEMP.DBF)
*!*	       ZAP
*!*	       APPEND FROM temp    
*!*	    ENDIF 
*!*	ENDFOR

*!*	SET PATH TO lcOldPath  && Set path to Visual FoxPro directory

*--> Abrimos o arquivo de Parametros 
*!*	instrucaoSQL = "select * from cadloja" 

*!*	sqlexec(nConexao,instrucaoSQL,"curLoja") 
*!*	sqldisconnect(nConexao) 

USE Dbsmg!tab_loja
gEmpresa = tab_loja.nome
gImpresso = tab_loja.impresso
gPalavra = tab_loja.palavra
gSenha = tab_loja.senha
gDivcupom = tab_loja.divcupom
gMensa1 = tab_loja.Mensagem1
gMensa2 = tab_loja.mensagem2 

*!*	Declare Integer FindWindow In Win32API Integer, String 
*!*	lnWinHandle = FindWindow( 0, "Sistema de Gerenciamento Comercial" )
*!*	If lnWinHandle # 0 
*!*	   =Messagebox( "O aplicativo já está sendo executado!", 16 )
*!*	   Cancel
*!*	Endif

IF m.gDesenv 
   gNivel = 1
   DO FORM frmprinc

	*{ Ocultamos a tela do fox }*
	_SCREEN.Hide
   
*   frmprinc.picture = "figura.bmp"
   frmprinc.caption = frmprinc.caption + " - " + gEmpresa 
   frmprinc.show
ELSE
	*: Ativamos o formulario de entrada que não esta visivel :*
	DO FORM frmlogin

	*{ Ocultamos a tela do fox }*
	_SCREEN.Hide

	*( Criamos o objeto de criptografia )*
	gOcripta = CREATEOBJECT('crypto')


	*{ Mostramos o formulário de entrada}*
	frmLogin.show()
ENDIF

READ EVENTS


FUNCTION oRS_Access() as ADODB.RecordSet
	LOCAL loRS as ADODB.RecordSet
	IF VARTYPE(this.oRS)<>"O" THEN
		this.oRS = NULL
		loRS = NEWOBJECT("ADODB.Recordset")
		IF VARTYPE(loRS)="O" THEN
			loRS.CursorType= 3 && adOpenStatic
			loRS.CursorLocation = 3 && adUseClient
			loRS.LockType= 3 && adLockOptimistic
			this.oRS = loRS
		ENDIF
	ENDIF
RETURN this.oRS
