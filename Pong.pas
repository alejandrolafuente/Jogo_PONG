Program pong;
const
larguraTela = 80; 
alturaTela = 22 ;
//-------------------
larguraBarra= 1 ;
alturaBarra = 4 ;
distanciaBarra = 4 ;
//-------------------
tamanhoBola = 1 ;
//-------------------
pontos = 10;
//-------------------
var
pontoA, //ponto jogador A
pontoB, //ponto jogador B
localBarraA, //local em linha da Barra A
localBarraB, //local em linha da Barra B
ultimoLocalBarraA, //ultimo local em linha da Barra A
ultimoLocalBarraB:byte; //ultimo local em linha da Barra B

bolaX, //local em coluna da bola
bolaY:real; //local em linha da bola

velocidadeBolaX, //velocidade em coluna da bola
velocidadeBolaY:integer; //velocidade em linha da bola

jogadorA,
jogadorB:String[25]; //armazena os nomes dos jogadores

fimJogo:boolean; //calcula o fim do jogo

Procedure inicio();
Begin
  localBarraA := int(alturaTela/2);//meio da tela (linha) 11
  localBarraB := int(alturaTela/2);//meio da tela (linha) 11
  
  ultimoLocalBarraA := 0;
  ultimoLocalBarraB := 0;
  
  bolaX := larguraTela/2; //meio da tela (coluna)  40
  bolaY := alturaTela/2;  //meio da tela (linha)   11
  
  velocidadeBolaX := 1; //velocidade de deslocamento da bola (coluna)
  velocidadeBolaY := 1; //velocidade de deslocamento da bola (linha)
  
  pontoA := 0; //ponto jogador A
  pontoB := 0; //ponto jogador B
  
  fimJogo:=false;
End;


Procedure meioTela(texto:String; y:byte);
var x:byte;
Begin        // 80/2                 51/2 = 25,5
  x:= int(((larguraTela)/2) - ((length(texto)/2))); //calculo do meio da tela, menos o tamanho da String 
  //writeln(x);
	gotoxy(x,y); //vamos pro lugar calculado
  write(texto); //escrevemos a string
End;
  

procedure forma(X,Y,X1,Y1,Cor:byte;preencher:boolean);
Var i,coluna,linha: integer;
begin
  textcolor(cor);
  
  If ((preencher) and (Y1<>1)) then  // T
    For linha:=Y+1 to Y1+Y do       // For linha:= 12 to 15 do
	    For coluna:=X+1 to X1+X do     // For coluna:= 75 to 75 do
	    Begin
	      gotoxy(coluna,linha);      // (75,12),(75,13),(,),(,)
	      write(#219);
	    End;
  
  gotoxy(X,Y);   //
  
  if ((X1=1) and (Y1=1)) then  // usa para desenhar a bola
  begin
    Write(#218,#191);
    gotoxy(X,Y+1);
    write(#192,#217);
  end
  else
  begin
    write(#218);          // quina superior esquerda
    
    for i:=1 to X1 do     // desenha a aresta superior 
    	write(#196);
    
    textcolor(cor);       //  quina superior direita
    write(#191+#10+#8);
    
    for i:=1 to Y1 do     // aresta direita
    	write(#179+#10+#8);
    
    textcolor(cor);
    gotoxy(X, Y + 1);
    
    for i:=1 to Y1 do     // aresta esquerda
    	write(#179+#10+#8);
    
    write(#192);         // quina inferior esquerda
    
    textcolor(cor);
    
    for i:=1 to X1 do    // aresta inferios
    	write(#196);
    
    write(#217);         // quina inferior direita
    
    textbackground(black);
  end;
end;

procedure apresentacao();
begin
  meioTela('---------------------------------------------------',1); //Escrita meio da tela
  meioTela('----------------------- PONG ----------------------',2); //Escrita meio da tela
  meioTela('---------------------------------------------------',3); //Escrita meio da tela
  meioTela('LGK ENTERPRISES',8); //Escrita meio da tela
  meioTela('Desenvolvido por',10);//Escrita meio da tela
  meioTela('Alejandro Mopi Lafuente',12);  //Escrita meio da tela
  meioTela('alejandromopi@hotmail.com',14);  //Escrita meio da tela
  meioTela('Aperte [Enter] para comecar!    ',alturaTela-5);//Escrita meio da tela
                                                //22-5
  //          16          80-45=35            
  forma(20,alturaTela-6,larguraTela-45,1,cyan,false); //Retangulo em volta da String anterior
  //     X       Y            X1      Y1 Cor  preencher
  While not (readkey=#13) do //espera o enter[#13] ser pressionado         
   
end;        

procedure nomeJogadores();
begin
	textcolor(lightgreen);
  meioTela('---------------------------------------------------',1); //Escrita meio da tela
  meioTela('----------------------- PONG ----------------------',2); //Escrita meio da tela
  meioTela('Digite os nomes dos jogadores e aperte ENTER para prosseguir',5); //Escrita meio da tela
  meioTela('Status: aguardando jogador 1',alturaTela-3); //Escrita meio da tela
  
  gotoxy(10,10);
  Write('Jogador 1:');
  gotoxy(10,15);
  Write('Jogador 2:');
  
  forma(21,9,25,2,cyan,false);  //caixa de texto

  forma(21,14,25,2,cyan,false); //caixa de texto
  
  textcolor(lightgreen);
  gotoxy(23,10);
	cursoron; 
	read(jogadorA);//lemos jogador A                      
	
	meioTela('Status: aguardando jogador 2',alturaTela-2); //atualizamos status
	
	gotoxy(23,15); 
	read(jogadorB);//lemos jogador B                 
	cursoroff;
end;

Procedure desenharJogo();
 var i,comprimentoPontoA,posi:integer;
 		 aux: real;
Begin  
				//    4                        1            4
  forma(distanciaBarra,localBarraA,larguraBarra,alturaBarra,lightgreen,true); //desenha barra A
       //  80     -  1  -  4 - 1 = 74 sempre                   
  forma(larguraTela-larguraBarra-distanciaBarra-1,localBarraB,larguraBarra,alturaBarra,lightgreen,true); //desenha barra B
       //                        1            1
  forma(int(bolaX),int(bolaY),tamanhoBola,tamanhoBola,yellow,true); //desenha bola
  
  textcolor(lightgreen);
  //o for abaixo desenha o pontilhado no meio da tela a cada duas linhas
                 // 20
  for i:= 2 to alturaTela-2 do // i:= 2,5,7 ** I ESTÁ INCREMENTANDO A CADA FOR
  begin           // 40
    gotoxy(int((larguraTela)/2), i); // (40,2),(40,5),(40,8)...(40,20)
    Write(#186);                     // 
    i:=i+2; // pulamos 2 linhas      //i = 7
  end;
  
//Abaixo temos um calculo "sujo" pra posição dos pontos na tela
  
  comprimentoPontoA := 5;
  
  if (pontoA > 9) then   
  	comprimentoPontoA := comprimentoPontoA+6  ;
  
  if (pontoA > 99) then
  	comprimentoPontoA := comprimentoPontoA+8 ;
  
  if (pontoA > 999) then
  	comprimentoPontoA := comprimentoPontoA+10 ;
  
  if (pontoA > 9999) then
  	comprimentoPontoA := comprimentoPontoA+12 ;
  	
  aux:= larguraTela/2 - pontos - comprimentoPontoA - length(jogadorA);
  gotoxy(1,1);
  write(#201);
  For i:= 2 to (int(aux)-2) do
  	write(#205);
  
  
  textcolor(magenta);
  highvideo;
  gotoxy(int(aux),1); //calculo sujo
  write(upcase(jogadorA),': ',pontoA,' ');  //jogador A + pontoA
  
  normvideo;
  textcolor(lightgreen);
  aux:= larguraTela/2 + pontos+1 + (length(jogadorB)/3);
	Repeat
		write(#205);
	Until(wherex=(int(aux)-1));
	
	textcolor(magenta);
	highvideo;	   
  gotoxy(int(aux),1); //calculo sujo
  write(upcase(jogadorB),': ',pontoB,' '); //jogador B + pontoB
  
  normvideo;
  textcolor(lightgreen);
  Repeat
		write(#205);
	Until(wherex=larguratela);
	write(#187);
	
	Repeat
		write(#10+#8+#186);
  Until(whereY=20);
  write(#10+#8+#188);
  
  gotoxy(1,1);
  Repeat
		write(#10+#8+#186);
  Until(whereY=20);
  write(#10+#8+#200);
  
  Repeat
		write(#205);
	Until(wherex=larguratela);
	
	gotoxy (3,22);
  write('Jogando');
	meioTela('P: Pausar  ESC: Sair  R: Reiniciar',alturaTela); 
End;

Procedure mapearTeclas();
	var botaoPressionado,aux: char;   
Begin                    
  If (keypressed) then  //se ALGUMA tecla pressionada
  Begin
  	botaoPressionado:= upcase(readkey);
  	
    CASE botaoPressionado OF
      '8':dec(localBarraB); //tecla 8, diminuimos a linha da barra B
      '5':inc(localBarraB); //tecla 2, aumentamos a linha da barra B
      'S': inc(localBarraA);//tecla S, aumentamos a linha da barra A
      'W': dec(localBarraA);//tecla W, diminuimos a linha da barra B
      'R': begin
			      inicio(); //reiniciamos as variaveis;
			      clrscr;
			     end;
      #27: fimJogo:=true; //acabamos o jogo
      'P': Begin         // Se jogo pausado, poderemos também encerrar ou reiniciar diretamente
             gotoxy (3,22);
             write('Pausado');
             
             Repeat
               aux:= readkey; // AQUI O PROGRAMA ESTÁ SOLICITANDO ENTRADA OBRIGATÓRIA
             Until (upcase(aux) = 'R') or (upcase(aux) = 'P') or (aux = #27);
             
             If upcase(aux) = 'R' then
             Begin
			      	inicio(); //reiniciamos as variaveis;
			      	clrscr;
			     	 End
			     	 Else
			     	 If aux = #27 then
               fimJogo:=true
             Else
             Begin
				       while not ((aux='p') or (aux='P')) do ; //não faz nada até que seja despausado  
				       gotoxy (3,22);
	 						 write('Jogando');
 						 End;
           End;    
 		END;
	End; // If (keypressed) then
      
  if(localBarraA<=1) then //se a posição da barra A for menor que a linha 1
  	localBarraA:=1; //travamos na linha atual
  //             
  if(localBarraA >= 16) then //se a posição da barra A for maior que a a altura da tela menos o comprimento da barra
  	localBarraA:= 16; //travamos na linha atual
  
  if(localBarraB<=1) then//se a posição da barra B for menor que a linha 1
  	localBarraB:=1; //travamos na linha atual
 //             
  if(localBarraB>=16)then //se a posição da barra A for maior que a a altura da tela menos o comprimento da barra
  	localBarraB:= 16;//travamos na linha atual
End;

Procedure calcularMovimento();
Begin
  
  mapearTeclas(); // eh aqui que são atualizadas localBarraA e localBarraB
    //      
  if (ultimoLocalBarraA<>localBarraA) then //se a posição atual da barra A, é diferente da anterior
  	forma(distanciaBarra,ultimoLocalBarraA,larguraBarra,alturaBarra,black,true); //apagamos barra A antiga
    //      
  if (ultimoLocalBarraB<>localBarraB) then //se a posição atual da barra B, é diferente da anterior
  	forma(larguraTela-larguraBarra-distanciaBarra-1,ultimoLocalBarraB,larguraBarra,alturaBarra,black,true); //apagamos barra B antiga
           //  80 - 1 - 4 - 1 = 74
           
  forma(int(bolaX),int(bolaY),tamanhoBola,tamanhoBola,black,true); //apagamos a bola anterior SEMPRE        
   
  bolaX := bolaX + velocidadeBolaX; //incrementamos a coluna da bola 
  bolaY := bolaY + velocidadeBolaY; //incrementamos a linha da bola
	// A primeira bola que desenhamos é a de coordenadas (bolaX, bolaY) = (41,12)
	  
  // colisão com o chão ou o teto:
	//         >= 20
  if ((bolaY >= alturaTela - tamanhoBola-1 ) or (bolaY <=2)) then 
  	velocidadeBolaY := velocidadeBolaY*-1; 
  	
                                  //bolaX = 7 6 *5 4 3 2] 1 
                                  //bolaY = 2 3 *4 5 6 7] 8 		    
	//colisão com a barra A:
	If bolaX = 6 then 
  //if ((bolaX >= distanciaBarra) and (bolaX <= distanciaBarra+tamanhoBola+alturaBarra-2) and (velocidadeBolaX < 0)) then 
  begin//  3   >    4-1=3                           3   <=  4+4+1=9
    if ((bolaY >= localBarraA - tamanhoBola) and (bolaY <= localBarraA + alturaBarra+1)) then
    begin
      velocidadeBolaX := velocidadeBolaX*-1;
    end;
  end;
	
	// "quica" na parte superior ou inferior da barra A:
	If ((bolaX = 4) or (bolaX = 5)) AND ((bolaY = localBarraA - 1) or (bolaY  = localBarraA + 6)) then
		velocidadeBolaY := velocidadeBolaY*-1; 
		
	                            //bolaX = 71 72 73 74 75 76 77 78
                              //bolaY = 6   7  8  9 10 11 12 13
  //colisão com a barra B:
  //         > 72      observe que este intervalo é FIXO                           <= 73 
  if ((bolaX > (larguraTela-2)-larguraBarra-distanciaBarra-tamanhoBola) and (bolaX <= (larguraTela)-distanciaBarra-tamanhoBola-2) and (velocidadeBolaX > 0)) then
  begin//      >=    1                                  <=  2 + 4 + 1 =  7
    if ((bolaY >= localBarraB - tamanhoBola) and (bolaY <= localBarraB + alturaBarra+1)) then 
      velocidadeBolaX := velocidadeBolaX*-1;
  end;
  
  // "quica" na parte superior ou inferior da barra B:
	If ((bolaX = 74) or (bolaX = 75)) AND ((bolaY = localBarraB - 1) or (bolaY  = localBarraB + 6)) then
		velocidadeBolaY := velocidadeBolaY*-1; 
  
  // se "encostar" nos limites laterais da tela, faz o ponto:
	//         >= 79 SEMPRE                         
  if ((bolaX >= larguraTela - tamanhoBola) or (bolaX <= 1)) then 
  begin
    
    if (velocidadeBolaX > 0) then //se a bola estiver indo à DIREITA
    begin
      inc(pontoA); //jogador A pontua
      bolaX := larguraTela / 4;   
    end;
    
    if (velocidadeBolaX < 0) then  //se a bola estiver indo à ESQUERDA
    begin
      inc(pontoB); //jogador B pontua
      bolaX := (larguraTela / 4) * 3;
    end;
    
  end;
  
  ultimoLocalBarraA := localBarraA; //salvamos barra A 
  ultimoLocalBarraB := localBarraB; //salvamos barra B 
  
End;

Procedure intrucoes();
begin
 meioTela('COMANDOS DO JOGO',2);
 meioTela('Jogador 1 ==>    W:Sobe          S: Desce',5);
 meioTela('Jogador 2 ==>    8: Sobe         2: Desce',8);
 meioTela('Aperte [Enter] para comecar!    ',alturaTela-5);//Escrita meio da tela
  
 forma(20,alturaTela-6,larguraTela-45,1,lightgreen,false); //Retangulo em volta da String anterior
 cursoroff;
 while not (readkey=#13) do // não faz nada até a tecla enter[#13] ser pressionada
end;

//********************************************************************************************
BEGIN
  cursoroff();     //desligamos o cursor
  
  inicio();        //iniciamos as variaveis
             
  apresentacao();  //nos apresentamos
  
  clrscr;          //limpamos a tela
  
  nomeJogadores(); //lemos nomes dos jogadores A e B
  
  clrscr;					 //limpamos a tela
  
  intrucoes();     //instruimos os jogadores
  
  clrscr;
  
  While not (fimJogo) do   //enquanto o fim de jogo não for detectado (ESC)
  Begin    
    calcularMovimento(); //Este procedimento:
    
		// mapearteclas() => verifica se jogador aperta tecla, se sim, altera localBarraA/B
    // Usando ultimoLocalBarraA/B, APAGA OU NÃO a barra A e/ou a barra B
    // Usando int(bolaX) e int(bolaY) APAGA a bola SEMPRE
    // SEMPRE Incrementa/Decrementa bolaX e/ou bolaY usando velocidadeBolaX/Y
    // Usando BolaY, verifica se houve COLISÃO com o chão ou o teto
    // Usando bolaX e bolaY, verifica se houve COLISÃO com a barra A
    // Usando bolaX e bolaY, verifica se a bola QUICA nos extremos da barra A
    // Usando bolaX e bolaY, verifica se houve COLISÃO com a barra B
    // Usando bolaX e bolaY, verifica se a bola QUICA nos extremos da barra B
    // Usando bolaX, verifica se a bola SAI DA TELA, se sim, INCREMENTA pontoA/B
    							// e com bolaX, REPOSICIONA a bola
    // ultimoLocalBarraA := localBarraA;  
    // ultimoLocalBarraB := localBarraB;
    
    desenharJogo(); //
    delay(10);        
  End;
  
END.        




















