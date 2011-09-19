{/TODO: Hacer menu de configuracion, Posibilidad Levantar palabras por archivo (o lista de palabras)
Resumen de funciones (de pascal) usadas:
Copy(<Cadena de texto String>, <inicio int>, <largo int>)
	Devuelve una copia de la cadena de texto desde el inicio con el largo de caracteres ingresado.
Length(<String>)
	Devuelve el largo (en caracteres) de la cadena de texto
Pos(<Char/string>, <String>)
	Devuelve la posision del caracter (o la cadena de texto) en la cadena de texto (2 argumento). Si no la encuentra devuelve 0.
}
program Ahorcado;

uses crt;

//Const

Var InicioLetra:integer= 1;
	FinLetra:integer = 1;
	MaxVidas: integer = 5;
	loop: boolean = true;
	opmenu: char;
	Palabra:string;

function Validarletra(letra:char):boolean;
{Validarletr(«caracter»):booleano
Se le pasa un caracter y devuelve true o false dependiendo si es valido.
Caracter valido son de la a hasta la z (incluyendo ñ)}
begin
	letra:= lowercase(letra);
//	if ((letra in ['a'..'z']) or (letra = 'ñ')) then
	if ((letra in ['a'..'z']) or (ord(letra) = 164)) then
		Validarletra := True
	else
		Validarletra := False;
end;

function ValidarPalabra(palabra:string):boolean;
{ValidarPalabra(«Cadena de texto»):booleano
Se le pasa una cadena de texto y devuelve true o false dependiendo si es valida.
Palabras validas, son las que estan compuestas por todos caracteres validos.}
Var
	i:integer=1;
begin
	palabra:= lowercase(palabra);
	ValidarPalabra:=True;
	while ((i<=length(palabra)) and ValidarPalabra) do begin
		ValidarPalabra:=Validarletra(palabra[i]);
//		if not ((palabra[i] in ['a'..'z']) or (palabra[i] = 'ñ')) then
//		//if not (ord(palabra[i]) in [97..122]) then
//			ValidarPalabra:= false;
		i:= i +1;
	end;
end;

function RepeticionLetra(palabra:string; letra:char):integer;
{Repeticionletra(«Cadena de texto», «Caracter»):entero
Devuelve cuantas veces esta repetido el caracter en la cadena de texto.}
	var i:integer;
begin
	RepeticionLetra:=0;
	for i:= 1 to length(palabra) do begin
		if palabra[i] = letra then
			RepeticionLetra:= RepeticionLetra + 1;
	end;
end;

procedure Ahorcado_ImprimirPalabra(palabra: string; letras:string; lIni:integer; lFin:integer);
{Ahorcado_ImprimirPalabra(«Cadena de texto1»,«Cadena de texto2»,«entero1»,«entero2»
Imprime La palabra con todos los caracteres de «Cadena de texto1» reemplazados por _, menos los contenidos en «Cadena de texto2». Entero1 y 2 son los offset inicial y final respectiamente
Ejemplo:
	Ahorcado_ImprimirPalabra('palabra','l', 1,1)
	Imprimira:
		p _ l _ _ _ a
	Ahorcado_ImprimirPalabra('palabra','lbj', 0,0)
	Imprimira:
		_ _ l _ b _ _
}
var i:integer;
	il:integer;
	clIni:integer;
	clFin:integer;
begin
	clIni:= 1;
	clFin:= lFin;
	while (clIni <= lIni) do begin
		write(palabra[clIni]);
		clIni:=clIni+1;
	end;
	//write(palabra[1]);
	for i:=(lIni+1) to (length(palabra)-(lIni))do
	begin
		il :=1;
		while (il <= length(letras)) do
		begin
			if (letras[il] = palabra[i]) then
			begin
				write(' ',letras[il], ' ');
				il := length(letras) +5;
			end;
			il := il +1;
		end;
		if not( il = length(letras)+6) then
			write(' _ ');
	end;
	while not (clFin = 0) do begin
		write(palabra[length(palabra)-(clFin-1)]);
		clFin:=clFin-1;
	end;
//	write(palabra[length(palabra)]);
	writeln('');
end;

procedure Ahorcado_PedirPalabra(var palabra:string);
{Procedimiento que pregunta por que palabra se va a usar}
Begin
	//clrscr;
	Writeln('»» Escriba Palabra:');
	ReadLn(palabra);
	palabra:= lowercase(palabra);
	while ( not ValidarPalabra(palabra) ) do begin
		WriteLn('»» Palabra invalida, Elija otra');
		readln(palabra);
	end;
end;

procedure Ahorcado(palabra:string;mvidas: integer;InicioLetra:integer;FinLetra:integer);
{Procedimiento principal del juego.}
Var
	letra: char;
	letras: string = ' ';
	aciertos: integer = 0;
	tempPalabra:string;
begin
	clrscr;
	Writeln('==Iniciando juego==');
//	write(palabra[1]);
//	for i:=0 to (length(palabra)-2) do
//		write(' _ ');
//	write(palabra[length(palabra)]);
	Ahorcado_ImprimirPalabra(palabra, letras,InicioLetra,FinLetra);
	writeln('');
	while (not(mvidas = 0) and (aciertos < (length(palabra)-(InicioLetra+FinLetra)) )) do
	begin
		writeln('»» Escriba una letra');
		readln(letra);
		letra:= lowercase(letra);
		tempPalabra:=Copy(Palabra,1+InicioLetra, length(Palabra)-(1+InicioLetra));
		if ((pos(letra, letras) = 0) and Validarletra(Letra))then
			begin
				letras := concat(letras, letra);
				if (pos(letra, tempPalabra ) = 0) then
					begin
						writeln('»» "',letra, '" no forma parte de la palabra');
						mvidas := mvidas - 1;
						writeln('»» Vidas Restantes ', mvidas);
					end
				else begin
					Ahorcado_ImprimirPalabra(palabra, letras, InicioLetra, FinLetra);
					aciertos := aciertos + RepeticionLetra(tempPalabra, letra);
				end;
			end
		else
			writeln('»» Letra ya ingresada o no valida, elija otra');
	end;
	if (mvidas=0) then
		writeLn('»» Perdiste!')
	else
		writeLn('»» Ganaste!');
end;

begin
	while loop do begin
		writeln('Que desea hacer?:');
		writeln('j - Jugar');
		writeln('c - Configurar');
		writeln('s - Salir');
		readLn(opmenu);
		case opmenu of
			'j': begin
				Ahorcado_PedirPalabra(palabra);
				Ahorcado(palabra,MaxVidas,InicioLetra,FinLetra);
			end;
			'c': writeln('Proximamente');
			's': loop:=false;
			else
				writeln('Elija una opcion valida');
		end;
	end;
end.
