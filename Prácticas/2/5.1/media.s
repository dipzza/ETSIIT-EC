.section .data
lista:		.int 0xffffffff, 0x00000001
longlista:	.int   (.-lista)/4
resultado:	.quad   0
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
	call _exit		# ==  exit(resultado)
	ret

suma:
	mov  $0, %eax
	mov  $0, %rsi
	mov  $0, %edx
bucle:
	add  (%rbx,%rsi,4), %eax
	jnc   etiqueta
	inc   %edx
etiqueta:
    inc   %rsi
	cmp   %rsi,%rcx
	jne    bucle
    ret
