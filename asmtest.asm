INCLUDE irvine32.inc
.data
	displayA BYTE "=======< 하이로우세븐 >=======",0	;하이로우세븐 게임 시작 메시지
	displayC BYTE "소지금: ",0							;남은 소지금 출력
	displayD BYTE "1.LOW 2.SEVEN 3.HIGH",0				;선택지 출력
	disMoney BYTE "베팅할 금액을 입력해주세요 : ",0		;배팅금액 출력
	displayM1 BYTE "돈을 얻었습니다",0					;배팅 성공 메시지 출력
	displayM2 BYTE "돈을 잃었습니다",0					;배팅 실패 메시지 출력
	displayEnd BYTE	"★★★★★★★★★★당신은 파산했습니다★★★★★★★★★★",0			;게임끝남
	playtime BYTE "번째 게임입니다.",0					;게임 횟수 출력
	money DWORD 10000									;처음 돈
	bettingA DWORD 0									;배팅 금액
	bettingB DWORD 0									;배팅으로 인해 받은 돈
	balance DWORD 0										;남은 금액
	count DWORD 1										;게임 횟수 세어줌
	arrayHart BYTE 1,2,3,4,5,6,7,8,9,10,11,12,13		;하트 해당 카드 배열
	arrayDia BYTE 1,2,3,4,5,6,7,8,9,10,11,12,13		;다이아 해당 카드 배열
	arraySpade BYTE 1,2,3,4,5,6,7,8,9,10,11,12,13	;스페이드 해당 카드 배열
	arrayClub BYTE 1,2,3,4,5,6,7,8,9,10,11,12,13		;클로버 해당카드 배열
	Hart BYTE "♥",0									;하트 기호
	Dia BYTE "◆",0										;다이아 기호
	Spade BYTE "♠",0									;스페이드 기호
	Club BYTE "♣",0									;클로버 기호
	answer DWORD 0										;랜덤으로 뽑아서 맞출 카드 번호
	select DWORD 0
.code

main PROC
	mov ecx,100
L1:	
	call displayMessage	
	inc count
	cmp balance,0										;잔액이 0원이면 끝난다
	ja continue
	jmp fin
fin: 
	call exitGame
	jmp getout
continue:
	call crlf
	loop L1
getout:
	exit
main ENDP


;화면 출력 디스플레이
displayMessage PROC USES eax ebx edx edi esi
	mov edx, OFFSET displayA
	call writestring
	call crlf

	mov eax, count
	call writeint
	mov edx, OFFSET playtime
	call writestring									;몇번째 게임인지 출력
	call crlf

	mov edx, OFFSET displayC
	call writestring
	mov eax, money
	call writeint
	call crlf											;소지금 출력

	mov edx, OFFSET displayD
	call writestring
	call crlf
	call readint										;1.Low 2.SEVEN 3.HIGH 출력후 값 선택
	mov select,eax

	mov edx, OFFSET disMoney
	call writestring
	call readint
	mov bettingA, eax									;배팅할 금액 입력받기

	call randomCard
	call crlf

	mov eax, money
	mov ebx, bettingA
	sub eax, ebx
	
	call earnM	
	call crlf

	mov ebx, bettingB
	add eax, ebx										;원래 금액 - 배팅금액 + 딴 금액
	mov balance,eax										;남은 금액 : 초기금액(10000) - 원래 금액 - 배팅금액 + 딴 금액
	mov money,eax
	ret
displayMessage ENDP

;배팅실패 성공여부
earnM PROC USES eax edx ebx
	mov eax, select
	cmp eax,1
	je L1												;1번 선택
	cmp eax,2
	je L2												;2번 선택
	cmp eax,3
	je L3												;3번 선택
L1:	mov eax,answer
	cmp answer,7
	jb correctA
	jmp discorrect										;1번 선택할때 7보다 작으면 정답A(2배)
L2: mov eax, answer
	cmp answer,7
	je correctB
	jmp discorrect										;2번 선택할때 7이면 정답B(5배)
L3:	mov eax, answer
	cmp answer,7
	ja correctA
	jmp discorrect
correctA:
	mov edx, OFFSET displayM1
	call writestring
	mov eax, bettingA
	mov ebx, 3
	mul ebx
	mov bettingB,eax
	jmp finish											;딴금액(2배)
correctB:
	mov edx, OFFSET displayM1
	call writestring
	mov eax, bettingA
	mov ebx, 6
	mul ebx
	mov bettingB, eax
	jmp finish											;딴금액(5배)
discorrect:
	mov edx, OFFSET displayM2
	call writestring
	mov bettingB, 0										;딴금액(0원)
finish:
	
	ret
earnM ENDP

;게임종료
exitGame PROC USES edx
	call crlf
	mov edx, OFFSET displayEnd
	call writestring
	call crlf
	ret
exitGame ENDP

;맞출카드
randomCard PROC USES eax esi edx
	mov eax,52
	call randomrange
	mov esi,eax
	mov eax,0
	mov al, arrayHart[esi]
	mov answer, eax
	cmp	esi,38
	ja club0
	cmp esi,25
	ja spade0
	cmp esi,12
	ja dia0
	mov edx, OFFSET Hart
	call writestring
	call writeint		
	jmp finish2											;;배열[0]~배열[12] 클로버
club0:
	mov edx, OFFSET Club
	call writestring
	call writeint
	jmp finish2											;배열[39]~배열[51] 클로버
spade0:
	mov edx, OFFSET Spade
	call writestring
	call writeint
	jmp finish2											;배열[26]~배열[38] 클로버
dia0:
	mov edx, OFFSET Dia
	call writestring
	call writeint
	jmp finish2											;;배열[13]~배열[25] 클로버
finish2:
	ret
randomCard ENDP
END MAIN