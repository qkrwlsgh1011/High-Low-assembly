INCLUDE irvine32.inc
.data
	displayA BYTE "=======< ���̷ο켼�� >=======",0	;���̷ο켼�� ���� ���� �޽���
	displayC BYTE "������: ",0							;���� ������ ���
	displayD BYTE "1.LOW 2.SEVEN 3.HIGH",0				;������ ���
	disMoney BYTE "������ �ݾ��� �Է����ּ��� : ",0		;���ñݾ� ���
	displayM1 BYTE "���� ������ϴ�",0					;���� ���� �޽��� ���
	displayM2 BYTE "���� �Ҿ����ϴ�",0					;���� ���� �޽��� ���
	displayEnd BYTE	"�ڡڡڡڡڡڡڡڡڡڴ���� �Ļ��߽��ϴ١ڡڡڡڡڡڡڡڡڡ�",0			;���ӳ���
	playtime BYTE "��° �����Դϴ�.",0					;���� Ƚ�� ���
	money DWORD 10000									;ó�� ��
	bettingA DWORD 0									;���� �ݾ�
	bettingB DWORD 0									;�������� ���� ���� ��
	balance DWORD 0										;���� �ݾ�
	count DWORD 1										;���� Ƚ�� ������
	arrayHart BYTE 1,2,3,4,5,6,7,8,9,10,11,12,13		;��Ʈ �ش� ī�� �迭
	arrayDia BYTE 1,2,3,4,5,6,7,8,9,10,11,12,13		;���̾� �ش� ī�� �迭
	arraySpade BYTE 1,2,3,4,5,6,7,8,9,10,11,12,13	;�����̵� �ش� ī�� �迭
	arrayClub BYTE 1,2,3,4,5,6,7,8,9,10,11,12,13		;Ŭ�ι� �ش�ī�� �迭
	Hart BYTE "��",0									;��Ʈ ��ȣ
	Dia BYTE "��",0										;���̾� ��ȣ
	Spade BYTE "��",0									;�����̵� ��ȣ
	Club BYTE "��",0									;Ŭ�ι� ��ȣ
	answer DWORD 0										;�������� �̾Ƽ� ���� ī�� ��ȣ
	select DWORD 0
.code

main PROC
	mov ecx,100
L1:	
	call displayMessage	
	inc count
	cmp balance,0										;�ܾ��� 0���̸� ������
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


;ȭ�� ��� ���÷���
displayMessage PROC USES eax ebx edx edi esi
	mov edx, OFFSET displayA
	call writestring
	call crlf

	mov eax, count
	call writeint
	mov edx, OFFSET playtime
	call writestring									;���° �������� ���
	call crlf

	mov edx, OFFSET displayC
	call writestring
	mov eax, money
	call writeint
	call crlf											;������ ���

	mov edx, OFFSET displayD
	call writestring
	call crlf
	call readint										;1.Low 2.SEVEN 3.HIGH ����� �� ����
	mov select,eax

	mov edx, OFFSET disMoney
	call writestring
	call readint
	mov bettingA, eax									;������ �ݾ� �Է¹ޱ�

	call randomCard
	call crlf

	mov eax, money
	mov ebx, bettingA
	sub eax, ebx
	
	call earnM	
	call crlf

	mov ebx, bettingB
	add eax, ebx										;���� �ݾ� - ���ñݾ� + �� �ݾ�
	mov balance,eax										;���� �ݾ� : �ʱ�ݾ�(10000) - ���� �ݾ� - ���ñݾ� + �� �ݾ�
	mov money,eax
	ret
displayMessage ENDP

;���ý��� ��������
earnM PROC USES eax edx ebx
	mov eax, select
	cmp eax,1
	je L1												;1�� ����
	cmp eax,2
	je L2												;2�� ����
	cmp eax,3
	je L3												;3�� ����
L1:	mov eax,answer
	cmp answer,7
	jb correctA
	jmp discorrect										;1�� �����Ҷ� 7���� ������ ����A(2��)
L2: mov eax, answer
	cmp answer,7
	je correctB
	jmp discorrect										;2�� �����Ҷ� 7�̸� ����B(5��)
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
	jmp finish											;���ݾ�(2��)
correctB:
	mov edx, OFFSET displayM1
	call writestring
	mov eax, bettingA
	mov ebx, 6
	mul ebx
	mov bettingB, eax
	jmp finish											;���ݾ�(5��)
discorrect:
	mov edx, OFFSET displayM2
	call writestring
	mov bettingB, 0										;���ݾ�(0��)
finish:
	
	ret
earnM ENDP

;��������
exitGame PROC USES edx
	call crlf
	mov edx, OFFSET displayEnd
	call writestring
	call crlf
	ret
exitGame ENDP

;����ī��
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
	jmp finish2											;;�迭[0]~�迭[12] Ŭ�ι�
club0:
	mov edx, OFFSET Club
	call writestring
	call writeint
	jmp finish2											;�迭[39]~�迭[51] Ŭ�ι�
spade0:
	mov edx, OFFSET Spade
	call writestring
	call writeint
	jmp finish2											;�迭[26]~�迭[38] Ŭ�ι�
dia0:
	mov edx, OFFSET Dia
	call writestring
	call writeint
	jmp finish2											;;�迭[13]~�迭[25] Ŭ�ι�
finish2:
	ret
randomCard ENDP
END MAIN