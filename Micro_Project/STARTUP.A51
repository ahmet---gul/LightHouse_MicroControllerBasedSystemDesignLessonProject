	ORG 0000H
	LJMP MAIN ; bypass interrupt vector table
	; ISR for hardware interrupt INT1 to turn on the LED
    ORG 0013H ; INT1 ISR
	;; ISR ye girince butun ledler yakiliyor
	MOV P2 , #11111111B 
    ACALL SEC_HALF						  //seri ve hizli sekilde butona basmaya bagli hatalari hatalari engellemek icin delay
	SETB P1.2				  //interrupt aldiktan sonra butona ikinci defa basilmak icin led yakiliyor , bir cesit kontrol
    BEKLET: JNB ie1 , BEKLET 			// ISR icindeyken butona bir daha basilirsa
	CLR  P1.2				  //interrupt aldiktan sonra butona ikinci defa basildigini normal rutini donuldugunu anlatiyor
    ACALL SEC_HALF						   //seri ve hizli sekilde butona basmaya bagli hatalari hatalari engellemek icin delay

	INT_TERK://ISR Sifirlaniyor
	MOV P2 , #00H //ledlerin hepsi sonduruluyor
	clr ie1 ; tusa basilinca ie1 1 olmustu fakat ilk tusa basilmada ISR cikilmadigi icin tekrar ISR'ye girmesin diye sifirlaniyor
	clr it1
	RETI ; return from ISR	 

	YAK1:
	SETB P2.0			; 1.led yakiliyor
    ACALL HALF_SEC		; timer1 ile bekletiliyor
	CLR  P2.0		 ; 1.led sonduruluyor					
	YAK2:					 
	SETB P2.1			; 2.led yakiliyor
	ACALL HALF_SEC		; timer1 ile bekletiliyor
	CLR  P2.1		; 2.led sonduruluyor					 
	YAK3:
	SETB P2.2			; 3.led yakiliyor
	ACALL HALF_SEC		; timer1 ile bekletiliyor
	CLR  P2.2			; 3.led sonduruluyor	
    YAK4:
	SETB P2.3			; 4.led yakiliyor
    ACALL HALF_SEC		; timer1 ile bekletiliyor
	CLR  P2.3		 ; 4.led sonduruluyor	
	YAK5:
	SETB P2.4			; 5.led yakiliyor
    ACALL HALF_SEC		; 1 saniye bekleniyor
	CLR  P2.4		 ; 5.led sonduruluyor	
	YAK6:
	SETB P2.5			; 6.led yakiliyor
    ACALL HALF_SEC		; timer1 ile bekletiliyor
	CLR  P2.5		 ; 6.led sonduruluyor	
	YAK7:
	SETB P2.6			; 7.led yakiliyor
    ACALL HALF_SEC		; timer1 ile bekletiliyor
	CLR  P2.6		 ; 7.led sonduruluyor	
	YAK8:
	SETB P2.7			; 8.led yakiliyor
    ACALL HALF_SEC		; timer1 ile bekletiliyor
	CLR  P2.7		 ; 8.led sonduruluyor	
	SJMP YAK1	   
		
	HALF_SEC:  MOV R0 , #02H 		//Timer1 icin
	FIFTY_MS:  CLR TR1
			   MOV TH1 , #03CH
			   MOV TL1 , #0B0H
			   SETB TR1
			   JNB TF1 , $ ; TF1 1 olana kadar bekle
			   CLR TF1			   			   		   
	LOOP_S :   DJNZ  R0 , FIFTY_MS
			   RET	
			   
	SEC_HALF:  MOV R7 , #05H		 //Timer0 icin
	MS_FIFTY:  //CLR TF0
	           CLR TR0
	           MOV TH0, #03CH
			   MOV TL0, #0B0H
			   SETB TR0
			   JNB TF0 , $ ; TF0 1 olana kadar bekle
			   CLR TF0
	S_LOOP :   DJNZ	R7 , MS_FIFTY
			   RET
			    	   
			   			   
     ; MAIN program for initialization
	ORG 0095H
	MAIN: MOV IE , #10000100B ; enable external INT1
    MOV TMOD , #11H ; timer 1 icin mod 01 , timer0 mod 01

	;;Portlari temizliyoruz
    MOV P2 , #00H	
    CLR P1.2
		   
	LJMP YAK1  ; 1.ledi yakmak icin atlaniyor
    END
