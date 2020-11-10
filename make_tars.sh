#!/bin/bash
#set -e

time_stamp=`date +%Y%m%d.%H%M%S`
if [ -z  "$SPEC_DIR" ]; then 
   echo "  Please set the SPEC_DIR environment variable to point to your copy of SPEC CPU2006."
   exit 1
fi

WORK_DIR=`pwd`
OUTPUT_DIR=$WORK_DIR/tars-$time_stamp
echo "===================================================="
echo "Making tar archives for SPEC benches"
echo "WORK_DIR = $WORK_DIR"
echo "SPEC_DIR = $SPEC_DIR"
echo "OUTPUT_DIR = $OUTPUT_DIR"
echo "===================================================="

bench_src=$SPEC_DIR/benchspec/CPU2006
cd $bench_src 
bench_list=`ls -d 4??.*`
cd - >> /dev/null

mkdir $OUTPUT_DIR
cd $OUTPUT_DIR
for bench in $bench_list; do
	echo "Make tar archive for $bench"
	mkdir ./$bench
	cp -rf $bench_src/$bench/run ./$bench/

	run_cmd=${bench##*.}
	if [ $bench == "482.sphinx3" ]; then
		run_cmd=sphinx_livepretend;
	fi
	if [ $bench == "483.xalancbmk" ]; then
		run_cmd=Xalan
	fi
	run_cmd+="_base.riscv"

	IFS=$'\n' read -d '' -r -a run_args< $WORK_DIR/commands/$bench.test.cmd

	echo "cd ./run/run_base_test_riscv.0000" >> $bench/run.sh
	for a in "${run_args[@]}"; do
		echo "./$run_cmd $a" >> $bench/run.sh
	done
	echo "cd -" >> $bench/run.sh
	chmod a+x $bench/run.sh

	tar cf $bench.tar $bench
done

cd $WORK_DIR
echo "===================================================="
echo "Result"
ls -lh $OUTPUT_DIR/*.tar
