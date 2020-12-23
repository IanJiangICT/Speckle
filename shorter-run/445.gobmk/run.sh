cd ./run/run_base_test_riscv.0000
./gobmk_base.riscv --quiet --mode gtp < capture.tst
./gobmk_base.riscv --quiet --mode gtp < connect.tst
./gobmk_base.riscv --quiet --mode gtp < connect_rot.tst
./gobmk_base.riscv --quiet --mode gtp < connection_rot.tst
./gobmk_base.riscv --quiet --mode gtp < cutstone.tst
cd -
