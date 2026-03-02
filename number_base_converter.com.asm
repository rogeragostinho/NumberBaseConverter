org 100h          ; Programa comeca no endereco 100h (padrao .COM)

jmp inicio        ; Pula as variaveis para nao executar texto como codigo

; --- AREA DE DADOS (VARIAVEIS) ---
; 10, 13 sao codigos para pular linha e retornar o cursor
msg_pede_num    db 10,13, "Digite o numero: $"
msg_pede_base   db 10,13, "A base digitada e (1:Dec, 2:Bin, 3:Hex): $"
msg_res_dec     db 10,13, "Resultado em Decimal: $"
msg_res_bin     db 10,13, "Resultado em Binario: $"
msg_res_hex     db 10,13, "Resultado em Hexadecimal: $"

; Buffer para entrada de dados do teclado
buffer_entrada  db 20          ; Tamanho maximo permitido
quantos_lidos   db ?           ; O DOS preenche com a quantidade de caracteres lidos
texto_digitado  db 20 dup(?)   ; Onde os caracteres ficam guardados

valor_final     dw 0           ; Armazena o numero ja convertido

inicio:
; --- 1. SOLICITA O NUMERO ---
lea dx, msg_pede_num       ; Aponta para a mensagem
mov ah, 09h                ; Funcao para exibir texto
int 21h                    ; Executa

lea dx, buffer_entrada
mov ah, 0Ah                ; Funcao para ler o que foi digitado
int 21h

; --- 2. SOLICITA A BASE ---
lea dx, msg_pede_base
mov ah, 09h
int 21h

mov ah, 01h                ; Funcao para ler um unico caractere
int 21h
sub al, '0'                ; Converte o caractere ASCII para valor numerico

; --- 3. ESCOLHE O CONVERSOR ---
cmp al, 1
je converter_dec
cmp al, 2
je converter_bin
cmp al, 3
je converter_hex
jmp inicio                 ; Se base invalida, volta ao inicio

converter_dec:
call processa_decimal
jmp exibir_tudo
converter_bin:
call processa_binario
jmp exibir_tudo
converter_hex:
call processa_hex

exibir_tudo:
mov valor_final, ax        ; Salva o valor convertido em AX para a variavel

; Exibe Decimal
lea dx, msg_res_dec
mov ah, 09h
int 21h
mov ax, valor_final
call imprime_decimal

; Exibe Binario
lea dx, msg_res_bin
mov ah, 09h
int 21h
mov ax, valor_final
call imprime_binario

; Exibe Hexadecimal
lea dx, msg_res_hex
mov ah, 09h
int 21h
mov ax, valor_final
call imprime_hex

; Finaliza o programa
mov ah, 4Ch
int 21h

; --- FUNCOES PARA TRANSFORMAR TEXTO EM NUMERO ---

processa_decimal proc
xor ax, ax                 ; Zera AX
xor cx, cx
mov cl, quantos_lidos      ; CX vira o contador de caracteres
lea si, texto_digitado     ; SI aponta para o texto
ciclo_dec:
mov bl, [si]
sub bl, '0'                ; Converte caractere em numero
mov bh, 0
mov dx, 10
mul dx                     ; Multiplica total acumulado por 10
add ax, bx                 ; Soma o novo digito
inc si
loop ciclo_dec
ret
processa_decimal endp

processa_binario proc
xor bx, bx
xor cx, cx
mov cl, quantos_lidos
lea si, texto_digitado
ciclo_bin:
mov al, [si]
sub al, '0'
shl bx, 1                  ; Desloca bits para a esquerda
or bl, al                  ; Insere o bit (0 ou 1)
inc si
loop ciclo_bin
mov ax, bx
ret
processa_binario endp

processa_hex proc
xor bx, bx
xor cx, cx
mov cl, quantos_lidos
lea si, texto_digitado
ciclo_hex:
mov al, [si]
cmp al, '9'
jbe e_numero_hex
and al, 0DFh               ; Converte letras minusculas em maiusculas
sub al, 7                  ; Ajuste para letras A-F
e_numero_hex:
sub al, '0'
shl bx, 4                  ; Cada digito Hex ocupa 4 bits
or bl, al
inc si
loop ciclo_hex
mov ax, bx
ret
processa_hex endp

; --- FUNCOES PARA EXIBIR O NUMERO NA TELA ---

imprime_decimal proc
mov cx, 0
mov bx, 10
dividir_10:
xor dx, dx
div bx                     ; Divide por 10 para separar os digitos
push dx                    ; Guarda o resto na pilha
inc cx
cmp ax, 0
jne dividir_10
mostrar_dec:
pop dx                     ; Recupera digitos na ordem correta
add dl, '0'                ; Converte de volta para caractere
mov ah, 02h
int 21h
loop mostrar_dec
ret
imprime_decimal endp

imprime_binario proc
push ax
mov cx, 16                 ; Registradores no 8086 tem 16 bits
ciclo_pbin:
rol ax, 1                  ; Rotaciona o bit para o Carry Flag
mov dl, '0'
jnc mostrar_bit            ; Se nao houve carry (bit 0), pula
mov dl, '1'                ; Se houve carry, o bit era 1
mostrar_bit:
push ax
mov ah, 02h
int 21h
pop ax
loop ciclo_pbin
pop ax
ret
imprime_binario endp

imprime_hex proc
push ax
mov cx, 4                  ; Um numero de 16 bits tem 4 digitos Hex
ciclo_phex:
push cx
mov cl, 4
rol ax, cl                 ; Pega o grupo de 4 bits da esquerda
mov bx, ax
and al, 0Fh                ; Isola os 4 bits
cmp al, 10
jl e_digito_hex
add al, 7                  ; Ajuste para letras A-F
e_digito_hex:
add al, '0'
mov dl, al
mov ah, 02h
int 21h
mov ax, bx
pop cx
loop ciclo_phex
pop ax
ret
imprime_hex endp

end

