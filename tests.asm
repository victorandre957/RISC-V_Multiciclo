	.data
test_label:
	.asciz	"Test "
status_ok:
	.asciz	" - [OK]"
status_fail:
	.asciz	" - [FAIL]"
test_word:
	.word	0x1337C0D3
test_byte:
	.byte	0x00
newline:
	.asciz	"\n"

	.text
main:
	li	a1, 0
	jal	test1
	jal	test2
	jal	test3
	jal	test4
	jal	test5
	jal	test6
	jal	test7
	jal	test8
	jal	test9
	jal	test10
	jal	test11
	jal	test12
	jal	test13
	jal	test14
	jal	test15
	jal	test16
	jal	test17
	jal	test18
	jal	test19
	jal	test20
	jal	test21
	jal	test22
	jal	test23
	jal	end

test_results:
	# Print "Test"
	la	a0, test_label
	li	a7, 4
	ecall
	# Print the current test index
	addi	a1, a1, 1
	add	a0, zero, a1
	li	a7, 1
	ecall
	# Print the test status that should be stored in t0
	mv	a0, t0
	li	a7, 4
	ecall
	# Print the newline character
	la	a0, newline
	ecall
	# Return to the main subroutine and continue the testing
	jr	ra

set_tests_results:
	la	t0, status_ok
	# It is expected that the test and reference results are in t5 and t6
	beq	t5, t6, test_results
	la	t0, status_fail
	j	test_results

test1:
	li	t1, -5
	li	t2, 6
	add	t5, t1, t2
	li	t6, 1
	j	set_tests_results

test2:
	li	t3, -32
	addi	t5, t3, -64
	li	t6, -96
	j	set_tests_results

test3:
	li	t1, 0xFF
	li	t2, 0x0F
	and	t5, t1, t2
	li	t6, 0x0F
	j	set_tests_results

test4:
	li	t1, 0xF0
	andi	t5, t1, 0x0F
	li	t6, 0x00
	j	set_tests_results

test5:
	auipc	t1, 0
	auipc	t2, 0
	sub	t5, t2, t1
	li	t6, 0x4
	j	set_tests_results

test6:
	li	t1, 420
	li	t2, 69
	li	t5, 0
	li	t6, 0
	bne	t1, t2, set_tests_results
	la	t0, status_fail
	j	test_results

test7:
	li	t1, -69
	li	t2, -420
	li	t5, 0
	li	t6, 0
	bge	t1, t2, set_tests_results
	la	t0, status_fail
	j	test_results

test8:
	li	t1, -69
	li	t2, -420
	li	t5, 0
	li	t6, 0
	bgeu	t1, t2, set_tests_results
	la	t0, status_fail
	j	test_results

test9:
	li	t1, -420
	li	t2, -69
	li	t5, 0
	li	t6, 0
	blt	t1, t2, set_tests_results
	la	t0, status_fail
	j	test_results

test10:
	li	t1, 420
	li	t2, 69
	li	t5, 0
	li	t6, 0
	blt	t2, t1, set_tests_results
	la	t0, status_fail
	j	test_results

test11:
	la	t1, test_word
	lw	t5, 0(t1)
	li	t6, 0x1337C0D3
	j	set_tests_results

test12:
	la	t1, test_word
	lb	t5, 0(t1)
	li	t6, 0xFFFFFFD3
	j	set_tests_results

test13:
	la	t1, test_word
	lbu	t5, 0(t1)
	li	t6, 0x000000D3
	j	set_tests_results

test14:
	lui	t5, 9
	li	t6, 9
	slli	t6, t6, 12
	j	set_tests_results

test15:
	la	t5, test_word
	li	t0, 0x1337CAFE
	sw	t0, 0(t5)
	la	t6, test_word
	j	set_tests_results

test16:
	la	t5, test_byte
	li	t0, 0x7F
	sb	t0, 0(t5)
	la	t6, test_byte
	j	set_tests_results

test17:
	li	t0, 0xF0F0F0F0
	li	t1, 0x0F0F0F0F
	or	t5, t0, t1
	li	t6, 0xFFFFFFFF
	j	set_tests_results

test18:
	li	t0, 0xFFFFFF00
	ori	t5, t0, 0x0F
	li	t6, 0xFFFFFF0F
	j	set_tests_results

test19:
	li	t0, 0xF0F0F0F0
	li	t1, 0xFF0F0F0F
	xor	t5, t0, t1
	li	t6, 0x0FFFFFFF
	j	set_tests_results

test20:
	li	t0, -5
	li	t1, 5
	sub	t5, t0, t1
	li	t6, -10
	j	set_tests_results

test21:
	li	t1, -2
	li	t2, 3
	slt	t5, t1, t2
	li	t6, 1
	j	set_tests_results

test22:
	li	t1, 3
	srai	t5, t1, 1
	li	t6, 1
	j	set_tests_results

test23:
	li	t1, 3
	srli	t5, t1, 1
	li	t6, 1
	j	set_tests_results

end:
	li a7, 10
	ecall