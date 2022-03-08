.286
.model small
.stack 100h

.data
  msg1  DB 'Enter an int: ',0
  msg2  DB 'A - B = ',0
  msg3  DB 'B - C = ',0

.data?
  A   DB  ?
  B   DB  ?
  C   DB  ?

.code

start:

main:

    mov ax, @data
    mov ds, ax

    lea ax, msg1              ; prints 'Enter int: '
    push ax
    call puts

    call getche               ; gets A
    lea bx, A
    mov dh, 0h
    mov ds:[bx], dx           ; address at A

    push 10d                  ; prints newline
    call putch

    lea ax, msg1              ; prints 'Enter int: '
    push ax
    call puts

    call getInt               ; gets B
    lea bx, B
    mov ah, 0h
    mov ds:[bx], ax           ; address at B

    push 10d                  ; prints newline
    call putch

    lea ax, msg1              ; prints 'Enter int: '
    push ax
    call puts

    call getInt               ; gets C
    lea bx, C
    mov ah, 0h
    mov ds:[bx], ax           ; address at C

    push 10d                  ; prints newline
    call putch

    lea ax, msg2              ; prints 'A = A-B'
    push ax
    call puts

    lea bx, ds:[A]
    mov ax, ds:[bx]
    lea bx, ds:[B]
    mov cx, ds:[bx]
    sub al, cl
    mov ah, 0h
    push ax
    call printInt             ; calculates A-B

    push 10d                  ; prints newline
    call putch

    lea ax, msg3              ; prints 'B = B-C'
    push ax
    call puts

    lea bx, ds:[B]
    mov ax, [bx]
    lea bx, ds:[C]
    mov cx, [bx]
    sub al, cl
    mov ah, 0h
    push ax
    call printInt             ; calculates B-C

    mov ax, 4c00h             ; return to DOSBOX
    int 21h

getche:

    push ax
    mov ah, 01h
    int 21h
    mov dl, al
    pop ax
    ret


putch:

    push ax
    push bx
    push dx

    mov bx, sp
    mov dx, ss:[bx+8]
    mov ah, 02h
    int 21h

    pop dx
    pop bx
    pop ax
    ret

puts:

    push ax
    push bx
    push dx
    mov bx, sp
    mov bx, ss:[bx+8]         ; bx contains pointer to first char
  
loop1:
      mov dx, [bx]
      cmp dl, 0h              ; compares dx with 0
      je endloop           ; if null-terminated

      push dx
      call putch
      pop dx

      add bx, 1               ; accounts for null char
      jmp loop1

endloop:
      pop dx
      pop bx
      pop ax
      ret

gets:
    push ax
    push bx
    push dx
    mov bx, sp
    mov bx, ss:[bx+8]         ; bx contains pointer to string

getloop:
      call getche             ; dx holds new char
      mov [bx], dx            ; puts new char into string array
      add bx, 1               ; inc pointer
      cmp dl, 13d             ; if new char is enter/carriage return
      jnz getloop

      mov dx, 0h
      mov [bx], dx            ; null-terminates
      pop dx
      pop bx
      pop ax
      ret

getInt:

    push dx
    call getche               ; dx holds new char
    sub dx, 48d               ; converts from char to int
    mov ax, dx                ; puts int into ax for return
    mov ah, 0h
    pop dx
    ret


printInt:

    push ax
    push bx
    push cx
    mov bx, sp
    mov ax, ss:[bx+8]          ; int is in ax
    mov cx, 0h                 ; initialize counter

convertintloop:

      mov dx, 0h
      mov bx, 0Ah              ; contains 10
      div bx                   ; dx = remainder, ax = quotient
      mov bx, ax               ; swaps ax, dx
      mov ax, dx
      mov dx, bx
      add ax, 30h              ; converts to ascii
      inc cx                   ; increment counter
      push ax

      mov ax, dx
      cmp ax, 0h               ; if quotient is 0, end
      jne convertintloop

printloop:

      call putch
      pop ax                   ; take ax back off stack
      dec cx                   ; decrement counter
      cmp cx, 0h               ; if null, terminate
      jne printloop       

      pop cx
      pop bx
      pop ax
      ret

END start