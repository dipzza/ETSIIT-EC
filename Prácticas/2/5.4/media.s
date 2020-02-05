.section .data
#ifndef TEST
#define TEST 20
#endif
        .macro linea
    #if TEST==1
            .int 1, 2, 1, 2
    #elif TEST==2
            .int -1, -2, -1, -2
    #elif TEST==3
            .int 0xfFFFFFFF, 0xfFFFFFFF, 0xfFFFFFFF, 0xfFFFFFFF
    #elif TEST==4
            .int 0x80000000, 0x80000000, 0x80000000, 0x80000000
    #elif TEST==5
            .int 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff                                     
    #elif TEST==6
            .int 2000000000, 2000000000, 2000000000, 2000000000 
    #elif TEST==7
            .int 3000000000, 3000000000, 3000000000, 3000000000
    #elif TEST==8
            .int -2000000000, -2000000000, -2000000000, -2000000000 
    #elif TEST==9
            .int -3000000000, -3000000000, -3000000000, -3000000000
    #elif TEST>=10 && TEST<=14
            .int 1, 1, 1, 1
    #elif TEST>=15 && TEST<=19
            .int -1, -1, -1, -1
    #else
        .error "Definir TEST entre 1..19"
    #endif
        .endm
        
        .macro linea0
    #if TEST>=1 && TEST<=9
            linea
    #elif TEST==10
            .int 0, 2, 1, 1
    #elif TEST==11
            .int 1, 2, 1, 1
    #elif TEST==12
            .int 8, 2, 1, 1
    #elif TEST==13
            .int 15, 2, 1, 1
    #elif TEST==14
            .int 16, 2, 1, 1
    #elif TEST==15
            .int 0, -2, -1, -1
    #elif TEST==16
            .int -1, -2, -1, -1
    #elif TEST==17
            .int -8, -2, -1, -1
    #elif TEST==18
            .int -15, -2, -1, -1
    #elif TEST==19
            .int -16, -2, -1, -1
    #else
        .error "Definir TEST entre 1..19"
    #endif
        .endm
                
lista:		        linea0
            .irpc i, 123
                    linea
            .endr
            
longlista:	.int   (.-lista)/4
media:	    .int 0
resto:      .int 0
formato: 	.ascii	"media \t = %10d \t resto \t = %10d\n"
            .asciz  "\t\t = 0x%08x \t\t = 0x%08x \n\n"


.section .text
main: .global  main

	mov     $lista, %rbx
	mov  longlista, %ecx
	
	call suma		# == suma(&lista, longlista);
	
	mov  %eax, media
	mov  %edx, resto

	mov   $formato, %rdi
	mov   media,%rsi
	mov   resto,%rdx
	mov   media,%rcx
	mov   resto,%r8
	mov   $0,%eax	# varargin sin xmm
	call  printf		# == printf(formato, media, resto, media, resto);
	ret

suma:
    mov  $0, %rsi
	mov  $0, %eax
	mov  $0, %edx
	mov  $0, %r8d
	mov  $0, %r9d
bucle:
	add (%rbx,%rsi,4), %eax
	CDQ
	add %eax, %r8d
	adc %edx, %r9d
	
	mov $0, %eax
	mov $0, %edx
	
    inc   %rsi
	cmp   %rsi,%rcx
	jne    bucle
	
	mov %r8d, %eax
	mov %r9d, %edx
	
	idiv %ecx
	
    ret
