.section .data
#ifndef TEST
#define TEST 9
#endif
    .macro linea
    #if TEST==1
            .int 1,1,1,1
    #elif TEST==2
            .int 0x0fffffff, 0x0fffffff, 0x0fffffff, 0x0fffffff
    #elif TEST==3
            .int 0x10000000, 0x10000000, 0x10000000, 0x10000000
    #elif TEST==4
            .int 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff
    #elif TEST==5
            .int -1, -1, -1, -1
    #elif TEST==6
            .int 200000000, 200000000, 200000000, 200000000 
    #elif TEST==7
            .int 300000000, 300000000, 300000000, 300000000
    #elif TEST==8
            .int 5000000000, 5000000000, 5000000000, 5000000000
    #else
        .error "Definir TEST entre 1..8"
    #endif
        .endm
                
lista:		.irpc i, 1234
                    linea
            .endr
longlista:	.int   (.-lista)/4
resultado:	.quad   0

# Buscar manera de poner resultado decimal de 3 en 3 y hexadecimal de 4 en 4
formato: 	.asciz	"suma = %lu = 0x%lx hex\n"


.section .text
main: .global  main

	mov     $lista, %rbx
	mov  longlista, %ecx
	call suma		# == suma(&lista, longlista);
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
	mov  $0, %eax
	mov  $0, %rsi
	mov  $0, %edx
bucle:
	add (%rbx,%rsi,4), %eax
	adc $0, %edx
	
    inc   %rsi
	cmp   %rsi,%rcx
	jne    bucle
	
    ret
