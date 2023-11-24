.data
	array: .word 12,11,13,5,6,7
	
	temp: .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	size: .word 6
	under: .asciiz "\n"
	space: .asciiz " "
.text

	Main: 
		la $a0, array #a0 = address cua array
		li $a1, 0 #a1 = left
		lw $t0, size #luu gia tri cua t0 la size cua array
		move $a2, $t0 #truyen gia tri cua a2 = t0 = size
		addi $a2, $a2, -1 #a2 = right = size - 1
		
		addi $sp, $sp, -16
		
		sw $ra, 12($sp) #luu gia tri return address vao bo nho
		sw $a0, 8($sp) #luu gia tri a0 = address cua array vao bo nho
		sw $a1, 4($sp) #luu gia tri cua a1 = left vao bo nho
		sw $a2, 0($sp) #luu gia tri cua a2 = right vao bo nho
		
		jal sort #bat dau thuc hien ham sort
		 
		lw $a2, 0($sp) #tra lai gia tri right vao a2
		lw $a1, 4($sp) #tra lai gia tri left vao a1
		lw $a0, 8($sp) #tra lai gia tri dia chi cua address cua
		lw $ra, 12($sp) #tra lai gia tri cua return address cu
		
		addi $sp, $sp, 16
		
		li $v0, 10 #ket thuc chuong trinh
		syscall
		
		
		printArray:
			la $t0, array #luu dia chi cua array vao t0
			lw $t2, size #luu gia tri cua size vao t2
			addi $t2, $t2, -1 #giam gia tri cua t2 di 1
			sll $t2, $t2, 2 #t2 = t2*4 = (size - 1)*4
			add $t2, $t0, $t2 #t2 = address end cua cai array
			
			addi $sp, $sp, -16 #bat dau xai stack
			
			sw $a0, 0($sp) #luu gia tri cua a0 = dia chi cua array
			sw $t0, 4($sp) #luu gia tri cua t0 la 
			sw $t2, 8($sp)
			sw $ra, 12($sp)
			
		print:  
			bgt $t0, $t2, endprint #neu t0 > t2 hay 
			lw $a0, 0($t0) #a0 = array[index]
			li $v0, 1 
			syscall
			la $a0, space 
			li $v0, 4
			syscall 
			addi $t0, $t0, 4 #cong them t0 += 4 de tang bien dem
			j print
			
		endprint:
			la $a0, under
			li $v0, 4
			syscall
			
			lw $a0, 0($sp)
			lw $t0, 4($sp)
			lw $t2, 8($sp)
			lw $ra, 12($sp)
			
			addi $sp, $sp, 16
		
			jr $ra
	
	sort: 
		sge $t0, $a1, $a2 #kiem tra left <= right neu thoa thi thoat ham
		bne $t0, $0, exit 
		
		add $s0, $a1, $a2 #s0 = left + right
		srl $s0, $s0, 1 #s0 = mid = (left + right) / 2
		
		addi $sp, $sp, -20
		
		sw $ra, 16($sp) #luu return address
		sw $a0, 12($sp) #luu a0 luc nay dang giu gia tri dia chi array
		sw $a1, 8($sp) #luu a1 luc nay dang giu gia tri left
		sw $a2, 4($sp) #luu a2 luc nay dang giu gia tri right
		sw $s0, 0($sp) #luu s0 luc nay dang giu gia tri mid
		
		move $a2, $s0 #luc nay gia tri cua mid se truyen vao tham so a2
		
		jal sort # sort phia trai voi tham so array, left, mid
		
		lw $s0, 0($sp) #tra s0 = mid
		lw $a2, 4($sp) #tra a2 tro lai thanh right
		lw $a1, 8($sp) #tra a1 tro lai thanh left
		lw $a0, 12($sp) #tra a0 ve dia chi array ban dau
		lw $ra, 16($sp) # tra ve return address cu
		
		addi $sp, $sp, 20
		
		move $s2, $a1 #tam thoi giu vi tri cua left o trong s2
		addi $s1, $s0, 1 #s1 = mid + 1
		move $a1, $s1 #a1 luc nay se bang mid + 1
				
		addi $sp, $sp, -24
		
		sw $ra, 20($sp) #luu gia tri cua return address
		sw $a0, 16($sp) #luu gia tri cua a0 luc nay la dia chi cua mang array
		sw $a1, 12($sp) #luu gia tri cua a1 = mid + 1
		sw $a2, 8($sp) #luu gia tri cua a2 = right
		sw $s2, 4($sp) #luu gia tri cua s2 luc nay se bang left
		sw $s0, 0($sp) #luu gia tri cua s0 luc nay se bang mid
		
		jal sort #sort phia phai voi tham so array, mid + 1, right
		
		lw $s0, 0($sp) #tra ve gia tri mid bang s0
		lw $s2, 4($sp) #tra ve gia tri left bang s2
		lw $a2, 8($sp) #tra ve gia tri a2 = right
		lw $a1, 12($sp) #tra ve gia tri a1 = mid + 1
		lw $a0, 16($sp) #tra ve gia tri a0 la dia chi cua array
		lw $ra, 20($sp) #tra ve return address
		
		addi $sp, $sp, 24
		
		addi $sp, $sp, -20
		
		move $a1, $s2 # tra a1 ve lai dung vi tri left
		move $a3, $a2 # a2 dang la right chuyen sang a3
		move $a2, $s0 # bien a2 thanh mid tu s0
		
		sw $ra, 16($sp)
		sw $a0, 12($sp)
		sw $a1, 8($sp)
		sw $a2, 4($sp)
		sw $a3, 0($sp)
		
		jal merge
		
		lw $a3, 0($sp)
		lw $a2, 4($sp)
		lw $a1, 8($sp)
		lw $a0, 12($sp)
		addi $sp, $sp, 16
			
		jal printArray
		
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		
		exit:	
			jr $ra
			
	merge:	
		la $s3, temp #cai dat dia chi cho array temp
		li $t0, 0 #t0 se bang bien dem i = 0
		li $t1, 0 #t1 se bang bien dem j = 0
		sll $s6, $a1, 2 # lay left*4 = s6 de giu lai mot bien left ban dau
		
		addi $t2, $a2, 1 #t2 = mid + 1
		sub $t3, $t2, $a1 # do lon cua mang x = mid + 1 - left
		
		addi $t4, $a3, 1 #t4 = right + 1
		sub $t5, $t4, $t2 # do lon cua mang y = right + 1 - (mid + 1)
		
		sll $t4, $a1, 2 # tang thanh left*4
		add $s1, $a0, $t4 # s1 se la mang x tu left den mid + 1
		sll $t2, $t2, 2 # tang thanh (mid + 1)*4 
		add $s2, $a0, $t2 # s2 se la mang y tu mid + 1 den right + 1
		
		 #kiem tra do lon cua tung mang trong array	
		while1:
			lw $t6, 0($s1) # t6 = x[i]
			lw $t7, 0($s2) # t7 = y[j]
		
			sll $t4, $a1, 2 #a1 = t0*4 = left*4
			add $s5, $a0, $t4 #s5 se bang address cua array + left
			#lw $s6, 0($s5) #s6 se bang array[left]
			
			sle $t2, $t6, $t7 # 
			beq $t2, $0, else
			
			sll $s4, $a1, 2 #s4 = left*4 
			add $s5, $s3, $s4 #s5 = left*4 + address cua s3
			sw $t6 0($s5) #cho array[left] = x[i]
			addi $s1, $s1, 4 #luc nay i se duoc cong them 1 nen ta xet phan tu tiep theo cua mang x
			addi $a1, $a1, 1 #cong bien left++
			addi $t0, $t0, 1 #cong bien i++
			j next #roi ra khoi truong hop if va di tiep
			
			
		else: 	sll $s4, $a1, 2 #s4 = left*4
			add $s5, $s3, $s4 #s5 = left*4 + address cua s3
			sw $t7 0($s5) #cho array[left] = y[j]
			addi $s2, $s2, 4 #luc nay j duoc cong them 1 nen ta xet phan tu tiep theo cua mang y
			addi $a1, $a1, 1 #cong bien left++
			addi $t1, $t1, 1 #cong bien j++
		
		next: 	slt $t2, $t0, $t3
			slt $t4, $t1, $t5
			and $t2, $t2, $t4
			bne $t2, $0, while1
		
			slt $t2, $t0, $t3 #kiem tra xem con phan tu nao o mang x can them vao tiep khong
			beq $t2, $0, checkwhile3
			
		while2: 
			lw $t6, 0($s1) # t6 = mang x[i]
			
			sll $s4, $a1, 2 #s4 = left*4 
			add $s5, $s3, $s4 #s5 se bang address cua temp + left*4
			
			sw $t6 0($s5) #cho array[left] = x[i]
			addi $s1, $s1, 4 
			addi $a1, $a1, 1 #cong bien left++
			addi $t0, $t0, 1 #cong bien i++
		
			slt $t2, $t0, $t3 #neu t0 < t3 voi t3 luc nay la x.size con t0 la i
			bne $t2, $0, while2  #neu t2 = 1 thi di vo while2
			
		checkwhile3: 
			slt $t4, $t1, $t5 #neu t1 < t5 voi t5 luc nat la y.size con t1 la j
			beq $t4, $0, final #neu t4 = t0 thi se di vao buoc cuoi final
				
		while3:	
			lw $t7, 0($s2) # mang y[j]
		 
			sll $s4, $a1, 2 #a1 = left*4
			add $s5, $s3, $s4 #s5 se bang address cua temp + left*4
			
			sw $t7 0($s5) #cho array[left] = x[i]
			addi $s2, $s2, 4 
			addi $a1, $a1, 1 #cong bien left++
			addi $t1, $t1, 1 #cong bien j++
			
			slt $t4, $t1, $t5 
			bne $t4, $0, while3
		
		final:  add $t2, $t3, $t5 #cong do lon cua 2 mang x va y
			sll $t2, $t2, 2 #nhan t2 = size x voi 4 de tao thanh offset luon
 			li $t4, 0 #t4 = k = 0
 			add $a0, $a0, $s6 #cap nhat lai cho chuan vi tri cua array + left*4
 			add $a0, $a0, $t4 #cong voi index k de ra dung vi tri can insert
 			add $s3, $s3, $s6 #cap nhat lai cho chuan vi tir cua temp + left*4
			add $s3, $s3, $t4 #cong voi index k de ra dung vi tri can insert
			
		change: lw $s4, 0($s3) #luu gia tri s4 chinh la temp[i[
			sw $s4, 0($a0) #luu gia tri s4 chinh la array[i]
			addi $t4, $t4, 4 #t4 = t4 + 4 bien dem t4 se duoc cong them 4
			addi $s3, $s3, 4 #s3 = s3 + 4 dia chi cua ham temp se duoc cong them 4
			addi $a0, $a0, 4 #a0 = a0 + 4	
			slt $s0, $t4, $t2 #t4 < t2 thi s0 se bang 1 voi t2 luc nay dan la size*4
			bne $s0, $0, change #neu s0 = 1 thi quay lai vi tri change
		
		jr $ra
		
