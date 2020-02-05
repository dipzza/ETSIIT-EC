.section .data
#ifndef TEST
#define TEST 9
#endif
    .macro linea
    #if TEST==1
            .int -1, -1, -1, -1
    #elif TEST==2
            .int 0x04000000, 0x04000000, 0x04000000, 0x04000000
    #elif TEST==3
            .int 0x08000000, 0x08000000, 0x08000000, 0x08000000
    #elif TEST==4
            .int 0x10000000, 0x10000000, 0x10000000, 0x10000000
    #elif TEST==5
            .int 0x7fffffff, 0x7fffffff, 0x7fffffff, 0x7fffffff                                     
    #elif TEST==6
            .int 0x80000000, 0x80000000, 0x80000000, 0x80000000 
    #elif TEST==7
            .int 0xF0000000, 0xF0000000, 0xF0000000, 0xF0000000
    #elif TEST==8
            .int 0xF8000000, 0xF8000000, 0xF8000000, 0xF8000000 
    #elif TEST==9
            .int 0xF7FFFFFF, 0xF7FFFFFF, 0xF7FFFFFF, 0xF7FFFFFF
    #elif TEST==10
            .int 100000000, 100000000, 100000000, 100000000
    #elif TEST==11
            .int 200000000, 200000000, 200000000, 200000000
    #elif TEST==12
            .int 300000000, 300000000, 300000000, 300000000
    #elif TEST==13
            .int 2000000000, 2000000000, 2000000000, 2000000000
    #elif TEST==14
            .int 3000000000, 3000000000, 3000000000, 3000000000
    #elif TEST==15
            .int -100000000, -100000000, -100000000, -100000000
    #elif TEST==16
            .int -200000000, -200000000, -200000000, -200000000
    #elif TEST==17
            .int -300000000, -300000000, -300000000, -300000000
    #elif TEST==18
            .int -2000000000, -2000000000, -2000000000, -2000000000
    #elif TEST==19
            .int -3000000000, -3000000000, -3000000000, -3000000000
    #else
        .error "Definir TEST entre 1..19"
    #endif
        .endm
                
lista:		.irpc i, 1234
                    linea
            .endr
longlista:	.int   (.-lista)/4
resultado:	.quad   0
formato: 	.ascii	"suma  = %ld   = 0x%016lx hex\n"


.section .text
main: .global  main

	mov     $lista, %rbx
	mov  longlista, %ecx
	
	push %rsi
	call suma		# == suma(&lista, longlista);
	pop %rsi
	
	mov  %eax, resultado
	mov  %edx, (resultado+4)

	mov   $formato, %rdi
	mov   resultado,%rsi
	mov   resultado,%rdx
	mov          $0,%eax	# varargin sin xmm
	call  printf		# == printf(formato, res, res);
	
	mov  resultado, %edi
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
	
    ret
