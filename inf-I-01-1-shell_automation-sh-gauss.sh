#!/usr/bin/bash

#Метод Гаусса с матрицей системы в качестве параметра
function g_method(){
	syst=$1
	matrix=()
	n=0
	i=0

	#Преобразование матрицы в одномерный массив
	local IFS=$'\n'
	for item in $(echo "$syst")
	do
		n=$(($n+1))
		local IFS=,
		for itemx in $(echo "$item")
		do
			matrix[$i]=$itemx
			i=$(($i+1))
		done
	done

	#Преобразование матрицы методом Гаусса
	k=$(($n*($n+1)))
	for (( j=0; j<n; j++ ))
	do
		#for (( i=0; i<k; i++ ))
		#do
		#	echo "${matrix[$i]}"
		#done

		temp=$((($n+1)*$j))
		start=$(($temp+$j))
		if [ "${matrix[$start]}" == "0" ]
        	then
        		jj=$start
			while [ "${matrix[$jj]}" == "0" ]
			do
				tj=$jj
				jj=$(($tj+$n))
			done
			for (( i=0; i<n+1; i++ ))
        		do
				h=$(($temp+$i))
				matrix[$h]=`echo "${$matrix[$h]}+${matrix[$jj+$i]}" | bc -l`
        		done
        	fi
		del=${matrix[$start]}
		for (( i=0; i<n+1; i++ ))
        	do
			h=$(($temp+$i))
			matrix[$h]=`echo "${matrix[$h]}/$del" | bc -l`
        	done
	
		for (( l=0; l<n; l++ ))
		do
			if [ "$l" != "$j" ]
			then
				q=$((($n+1)*$l))
				fir=${matrix[$q+$j]}
				for (( i=0; i<n+1; i++ ))
				do      
					#echo "${matrix[$q+$i]}"
					matrix[$q+$i]=`echo "${matrix[$q+$i]}-($fir*${matrix[$temp+$i]})" | bc -l`
					#echo "${matrix[$q+$i]}"

				done
			fi
		done

	done

	j=$(($n+1))
	f=$(($n*$j))
	i=$n
	#Возврат решения СЛУ
	for (( l=0; l<n; l++ ))
	do
		echo ${matrix[$i]}
		t=$i
		i=$(($t+$j))
	done
}

file_n=$1
content=$(cat "$file_n")
answer=$(g_method "$content")
echo "$answer"
